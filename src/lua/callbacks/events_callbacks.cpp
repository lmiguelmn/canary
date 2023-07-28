/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/callbacks/events_callbacks.hpp"

#include "lua/callbacks/event_callback.hpp"

/**
 * @class EventsCallbacks
 * @brief Class managing all event callbacks.
 *
 * @note This class is a singleton that holds all registered event callbacks.
 * @details It provides functions to add new callbacks and retrieve callbacks by type.
 */
EventsCallbacks::EventsCallbacks() {
	spdlog_dev(info, "Constructing singleton for class {}", __func__);
}

EventsCallbacks::~EventsCallbacks() {
	spdlog_dev(info, "Destructing singleton for class {}", __func__);
}

EventsCallbacks &EventsCallbacks::getInstance() {
	// Guaranteed to be destroyed
	static EventsCallbacks instance;
	// Instantiated on first use
	return instance;
}

void EventsCallbacks::addCallback(EventCallback* callback) {
	callbacks.push_back(callback);
}

std::vector<EventCallback*> EventsCallbacks::getCallbacks() {
	return callbacks;
}

std::vector<EventCallback*> EventsCallbacks::getCallbacksByType(EventCallback_t type) {
	std::vector<EventCallback*> eventCallbacks;
	for (auto callback : getCallbacks()) {
		if (callback->getType() != type) {
			continue;
		}

		eventCallbacks.push_back(callback);
	}

	return eventCallbacks;
}
