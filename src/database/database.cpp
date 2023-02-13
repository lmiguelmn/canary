/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.h"
#include "database/database.h"

Database::~Database() {
	if (handle != nullptr) {
		mysql_close(handle);
	}
}

bool Database::connect() {
	// connection handle initialization
	handle = mysql_init(nullptr);
	if (!handle) {
		SPDLOG_ERROR("Failed to initialize MySQL connection handle");
		return false;
	}

	// automatic reconnect
	bool reconnect = true;
	mysql_options(handle, MYSQL_OPT_RECONNECT, &reconnect);

	// check if all required parameters have been provided
	const std::string host = g_configManager().getString(MYSQL_HOST);
	const std::string user = g_configManager().getString(MYSQL_USER);
	const std::string password = g_configManager().getString(MYSQL_PASS);
	const std::string database = g_configManager().getString(MYSQL_DB);
	const int port = g_configManager().getNumber(SQL_PORT);
	const std::string socket = g_configManager().getString(MYSQL_SOCK);

	if (host.empty() || user.empty() || password.empty() || database.empty() || port <= 0) {
		SPDLOG_WARN("MySQL host, user, password, database or port not provided");
	}

	// connects to database
	if (!mysql_real_connect(handle, host.c_str(), user.c_str(), password.c_str(), database.c_str(), port, socket.c_str(), 0)) {
		SPDLOG_ERROR("MySQL Error Message: {}", mysql_error(handle));
		return false;
	}

	DBResult_ptr result = storeQuery("SHOW VARIABLES LIKE 'max_allowed_packet'");
	if (result) {
		maxPacketSize = result->getNumber<uint64_t>("Value");
	}
	return true;
}

bool Database::beginTransaction() {
	if (!executeQuery("BEGIN")) {
		return false;
	}
	databaseLock.lock();
	return true;
}

bool Database::rollback() {
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}

	if (mysql_rollback(handle) != 0) {
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		databaseLock.unlock();
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::commit() {
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		databaseLock.unlock();
		return false;
	}

	if (mysql_commit(handle) != 0) {
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::executeQuery(const std::string_view& query) {
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}

	databaseLock.lock();

	bool success = true;
	int retry = 10;
	while (retry > 0 && mysql_query(handle, query.data()) != 0) {
		SPDLOG_ERROR("Query: {}", query.substr(0, 256));
		SPDLOG_ERROR("MySQL error [{}]: {}", mysql_errno(handle), mysql_error(handle));
		if (!isRecoverableError(mysql_errno(handle))) {
			success = false;
			break;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
		retry--;
	}

	if (retry == 0) {
		SPDLOG_ERROR("Query {} failed after {} retries.", query, 10);
		success = false;
	}

	auto m_res = std::unique_ptr<MYSQL_RES, decltype(&mysql_free_result)>(mysql_store_result(handle), mysql_free_result);
	databaseLock.unlock();

	return success;
}

DBResult_ptr Database::storeQuery(const std::string_view &query) {
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return nullptr;
	}

	databaseLock.lock();

	retry:
	if (mysql_query(handle, query.data()) != 0) {
		SPDLOG_ERROR("Query: {}", query);
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		if (!isRecoverableError(mysql_errno(handle))) {
			return nullptr;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
		goto retry;
	}

	// Retrieving results of query
	MYSQL_RES* res = mysql_store_result(handle);
	databaseLock.unlock();
	if (res != nullptr) {
		DBResult_ptr result = std::make_shared<DBResult>(res);
		if (!result->hasNext()) {
			return nullptr;
		}
		return result;
	}
	return nullptr;
}

std::string Database::escapeString(const std::string &s) const {
	std::string::size_type length = s.length();
	//uint32_t length = static_cast<uint32_t>(len);
	std::string escaped = escapeBlob(s.c_str(), length);
	if (escaped.empty()) {
		SPDLOG_ERROR("Error escaping string");
	}
	return escaped;
}

std::string Database::escapeBlob(const char* s, uint32_t length) const {
	// the worst case is 2n + 1
	size_t maxLength = (length * 2) + 1;

	std::string escaped;
	escaped.reserve(maxLength + 2);
	escaped.push_back('\'');

	if (length != 0) {
		auto output = std::make_unique<char[]>(maxLength);
		size_t escapedLength = mysql_real_escape_string(handle, output.get(), s, length);
		if (escapedLength == maxLength) {
			SPDLOG_ERROR("Error escaping blob");
			return "";
		}
		escaped.append(output.get(), escapedLength);
	}

	escaped.push_back('\'');
	return escaped;
}

DBResult::DBResult(MYSQL_RES* res) {
	handle = res;

	int num_fields = mysql_num_fields(handle);

	listNames.reserve(num_fields); // pre-allocate memory for listNames

	MYSQL_FIELD* fields = mysql_fetch_fields(handle);
	for (size_t i = 0; i < num_fields; i++) {
		listNames[fields[i].name] = i;
	}
	row = mysql_fetch_row(handle);
}

DBResult::~DBResult() {
	mysql_free_result(handle);
}

std::string DBResult::getString(const std::string &s) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		SPDLOG_ERROR("Column '{}' does not exist in result set", s);
		return std::string();
	}
	if (row[it->second] == nullptr) {
		return std::string();
	}
	return std::string(row[it->second]);
}

const char* DBResult::getStream(const std::string &s, unsigned long &size) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		SPDLOG_ERROR("Column '{}' doesn't exist in the result set", s);
		size = 0;
		return nullptr;
	}

	if (row[it->second] == nullptr) {
		size = 0;
		return nullptr;
	}

	size = mysql_fetch_lengths(handle)[it->second];
	return row[it->second];
}

uint8_t DBResult::getU8FromString(const std::string &string, const std::string &function) const {
	auto result = static_cast<uint8_t>(std::atoi(string.c_str()));
	if (result > std::numeric_limits<uint8_t>::max()) {
		SPDLOG_ERROR("[{}] Failed to get number value {} for tier table result, on function call: {}", __FUNCTION__, result, function);
		return 0;
	}

	return result;
}

int8_t DBResult::getInt8FromString(const std::string &string, const std::string &function) const {
	auto result = static_cast<int8_t>(std::atoi(string.c_str()));
	if (result > std::numeric_limits<int8_t>::max()) {
		SPDLOG_ERROR("[{}] Failed to get number value {} for tier table result, on function call: {}", __FUNCTION__, result, function);
		return 0;
	}

	return result;
}

size_t DBResult::countResults() const {
	return static_cast<size_t>(mysql_num_rows(handle));
}

bool DBResult::hasNext() const {
	return row != nullptr;
}

bool DBResult::next() {
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}
	row = mysql_fetch_row(handle);
	return row != nullptr;
}

DBInsert::DBInsert(std::string insertQuery) :
	query(std::move(insertQuery)) {
	this->length = this->query.length();
}

bool DBInsert::addRow(std::string_view row) {
	const size_t rowLength = row.length();
	length += rowLength;
	auto max_packet_size = Database::getInstance().getMaxPacketSize();

	if (length > max_packet_size && !execute()) {
		return false;
	}

	if (values.empty()) {
		values.reserve(rowLength + 2);
		values.push_back('(');
		values.append(row);
		values.push_back(')');
	} else {
		values.reserve(values.length() + rowLength + 3);
		values.push_back(',');
		values.push_back('(');
		values.append(row);
		values.push_back(')');
	}
	return true;
}

bool DBInsert::addRow(std::ostringstream &row) {
	bool ret = addRow(row.str());
	row.str(std::string());
	return ret;
}

bool DBInsert::execute() {
	if (values.empty()) {
		return true;
	}

	// executes buffer
	bool res = Database::getInstance().executeQuery(query + values);
	values.clear();
	length = query.length();
	return res;
}
