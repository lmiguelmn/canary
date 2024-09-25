/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "database/databasemanager.hpp"
#include "lua/functions/core/libs/core_libs_functions.hpp"
#include "lua/scripts/luascript.hpp"
#include "game/game.hpp"

bool DatabaseManager::optimizeTables() {
	Database &db = Database::getInstance();
	std::ostringstream query;

	query << "SELECT `TABLE_NAME` FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB, __FUNCTION__)) << " AND `DATA_FREE` > 0";
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	do {
		std::string tableName = result->getString("TABLE_NAME");

		query.str(std::string());
		query << "OPTIMIZE TABLE `" << tableName << '`';

		std::string tableResult;
		if (db.executeQuery(query.str())) {
			tableResult = "[Success]";
		} else {
			tableResult = "[Failed]";
		}

		g_logger().info("Optimizing table {}... {}", tableName, tableResult);
	} while (result->next());

	return true;
}

bool DatabaseManager::tableExists(const std::string &tableName) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB, __FUNCTION__)) << " AND `TABLE_NAME` = " << db.escapeString(tableName) << " LIMIT 1";
	return db.storeQuery(query.str()).get() != nullptr;
}

bool DatabaseManager::isDatabaseSetup() {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB, __FUNCTION__));
	return db.storeQuery(query.str()).get() != nullptr;
}

int32_t DatabaseManager::getDatabaseVersion() {
	if (!tableExists("server_config")) {
		Database &db = Database::getInstance();
		db.executeQuery("CREATE TABLE `server_config` (`config` VARCHAR(50) NOT NULL, `value` VARCHAR(256) NOT NULL DEFAULT '', `world_id` INT(11) NOT NULL DEFAULT '1', UNIQUE(`config`, `world_id`)) ENGINE = InnoDB");
		db.executeQuery(fmt::format("INSERT INTO `server_config` (`config`, `value`) VALUES ('db_version', 0)"));
		return 0;
	}

	int32_t version = 0;
	if (getDatabaseConfig("db_version", version)) {
		return version;
	}
	return -1;
}

void DatabaseManager::updateDatabase() {
	lua_State* L = luaL_newstate();
	if (!L) {
		return;
	}

	luaL_openlibs(L);

	CoreLibsFunctions::init(L);

	int32_t version = getDatabaseVersion();
	do {
		std::string file = fmt::format("{}/migrations/{}.lua", g_configManager().getString(DATA_DIRECTORY, __FUNCTION__), version);
		if (luaL_dofile(L, file.c_str()) != 0) {
			g_logger().error("DatabaseManager::updateDatabase - Version: {}"
			                 "] {}",
			                 version, lua_tostring(L, -1));
			break;
		}

		if (!LuaScriptInterface::reserveScriptEnv()) {
			break;
		}

		lua_getglobal(L, "onUpdateDatabase");
		if (lua_pcall(L, 0, 1, 0) != 0) {
			LuaScriptInterface::resetScriptEnv();
			g_logger().warn("[DatabaseManager::updateDatabase - Version: {}] {}", version, lua_tostring(L, -1));
			break;
		}

		if (!LuaScriptInterface::getBoolean(L, -1, false)) {
			LuaScriptInterface::resetScriptEnv();
			break;
		}

		version++;
		g_logger().info("Database has been updated to version {}", version);
		registerDatabaseConfig("db_version", version);

		LuaScriptInterface::resetScriptEnv();
	} while (true);
	lua_close(L);
}

bool DatabaseManager::getDatabaseConfig(const std::string &config, int32_t &value) {
	Database &db = Database::getInstance();
	std::string query = fmt::format("SELECT `value` FROM `server_config` WHERE `world_id` = {} AND `config` = {}", g_game().worlds()->getCurrentWorld()->id, db.escapeString(config));
	if (config == "db_version") {
		query = fmt::format("SELECT `value` FROM `server_config` WHERE `config` = {}", db.escapeString(config));
	}

	const auto result = db.storeQuery(query);
	if (!result) {
		return false;
	}

	value = result->getNumber<int32_t>("value");
	return true;
}

void DatabaseManager::registerDatabaseConfig(const std::string &config, int32_t value) {
	Database &db = Database::getInstance();
	std::string query;

	int32_t tmp;

	if (!getDatabaseConfig(config, tmp)) {
		query = fmt::format("INSERT INTO `server_config` (`config`, `value`, `world_id`) VALUES ({}, {}, {})", db.escapeString(config), value, g_game().worlds()->getCurrentWorld()->id);
	} else {
		query = fmt::format("UPDATE `server_config` SET `value` = {} WHERE `world_id` = {} AND `config` = {}", value, g_game().worlds()->getCurrentWorld()->id, db.escapeString(config));
		if (strcasecmp(config.c_str(), "db_version")) {
			query = fmt::format("UPDATE `server_config` SET `value` = {} WHERE `config` = {}", value, db.escapeString(config));
		}
	}

	db.executeQuery(query);
}
