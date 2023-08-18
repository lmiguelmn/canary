/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/webhook/webhook.h"
#include "config/configmanager.h"

Webhook::Webhook(ThreadPool &threadPool) :
	threadPool(threadPool) {
	if (curl_global_init(CURL_GLOBAL_ALL) != 0) {
		g_logger().error("Failed to init curl, no webhook messages may be sent");
		return;
	}

	headers = curl_slist_append(headers, "content-type: application/json");
	headers = curl_slist_append(headers, "accept: application/json");

	if (headers == NULL) {
		g_logger().error("Failed to init curl, appending request headers failed");
		return;
	}
}

Webhook &Webhook::getInstance() {
	return inject<Webhook>();
}

void Webhook::requeueMessage(const std::string payload, std::string url) {
	threadPool.addLoad([this, &payload, &url] {
		std::this_thread::sleep_for(std::chrono::seconds(2));
		sendMessage(payload, url);
	});
}

void Webhook::sendMessage(const std::string payload, std::string url) {
	threadPool.addLoad([this, &payload, &url] {
		std::string response_body;
		auto response_code = sendRequest(url.c_str(), payload.c_str(), &response_body);

		if (response_code == 204 || response_code == 504) {
			g_logger().debug("Webhook encountered error code {}. Re-queueing task and sleeping for two seconds.", response_code);
			requeueMessage(payload, url);

			return;
		}

		if (response_code > 300) {
			g_logger().error(
				"Failed to send webhook message, error code: {} response body: {} request body: {}",
				response_code,
				response_body,
				payload
			);

			return;
		}

		g_logger().info("Webhook successfully sent to {}", url);
	});
}

void Webhook::sendMessage(const std::string title, const std::string message, int color) {
	sendMessage(title, message, color, g_configManager().getString(DISCORD_WEBHOOK_URL));
}

void Webhook::sendMessage(const std::string title, const std::string message, int color, std::string url) {
	if (url.empty() || title.empty() || message.empty()) {
		return;
	}

	sendMessage(getPayload(title, message, color), url);
}

int Webhook::sendRequest(const char* url, const char* payload, std::string* response_body) {
	CURL* curl = curl_easy_init();
	if (!curl) {
		g_logger().error("Failed to send webhook message; curl_easy_init failed");
		return -1;
	}

	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);
	curl_easy_setopt(curl, CURLOPT_POST, 1L);
	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &Webhook::writeCallback);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, reinterpret_cast<void*>(response_body));
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
	curl_easy_setopt(curl, CURLOPT_USERAGENT, "canary (https://github.com/Hydractify/canary)");

	CURLcode res = curl_easy_perform(curl);

	if (res != CURLE_OK) {
		g_logger().error("Failed to send webhook message with the error: {}", curl_easy_strerror(res));
		curl_easy_cleanup(curl);

		return 500;
	}

	int response_code;

	curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
	curl_easy_cleanup(curl);

	return response_code;
}

size_t Webhook::writeCallback(void* contents, size_t size, size_t nmemb, void* userp) {
	size_t real_size = size * nmemb;
	std::string* str = reinterpret_cast<std::string*>(userp);
	str->append(reinterpret_cast<char*>(contents), real_size);
	return real_size;
}

std::string Webhook::getPayload(const std::string title, const std::string message, int color) {
	time_t now;
	time(&now);
	struct tm tm;

#ifdef _MSC_VER
	gmtime_s(&tm, &now);
#else
	gmtime_r(&now, &tm);
#endif

	char time_buf[sizeof "00:00"];
	strftime(time_buf, sizeof time_buf, "%R", &tm);

	std::stringstream footer_text;
	footer_text
		<< g_configManager().getString(IP) << ":"
		<< g_configManager().getNumber(GAME_PORT) << " | "
		<< time_buf << " UTC";

	std::stringstream payload;
	payload << "{ \"embeds\": [{ ";
	payload << "\"title\": \"" << title << "\", ";
	payload << "\"description\": \"" << message << "\", ";
	payload << "\"footer\": { \"text\": \"" << footer_text.str() << "\" }, ";
	if (color >= 0) {
		payload << "\"color\": " << color;
	}
	payload << " }] }";

	return payload.str();
}
