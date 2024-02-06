/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class ValueWrapper;

#ifndef USE_PRECOMPILED_HEADERS
	#include <string>
	#include <optional>
	#include <vector>
	#include <memory>
	#include <phmap.h>
#endif

using MapType = phmap::flat_hash_map<std::string, std::shared_ptr<ValueWrapper>>;

struct lua_State;

class KVFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "kv");
		registerMethod(L, "kv", "scoped", KVFunctions::luaKVScoped);
		registerMethod(L, "kv", "set", KVFunctions::luaKVSet);
		registerMethod(L, "kv", "get", KVFunctions::luaKVGet);
		registerMethod(L, "kv", "keys", KVFunctions::luaKVKeys);
		registerMethod(L, "kv", "remove", KVFunctions::luaKVRemove);

		registerClass(L, "KV", "");
		registerMethod(L, "KV", "scoped", KVFunctions::luaKVScoped);
		registerMethod(L, "KV", "set", KVFunctions::luaKVSet);
		registerMethod(L, "KV", "get", KVFunctions::luaKVGet);
		registerMethod(L, "KV", "keys", KVFunctions::luaKVKeys);
		registerMethod(L, "KV", "remove", KVFunctions::luaKVRemove);
	}

private:
	static int luaKVScoped(lua_State* L);
	static int luaKVSet(lua_State* L);
	static int luaKVGet(lua_State* L);
	static int luaKVKeys(lua_State* L);
	static int luaKVRemove(lua_State* L);

	static std::optional<ValueWrapper> getValueWrapper(lua_State* L);
	static void pushStringValue(lua_State* L, const std::string &value);
	static void pushIntValue(lua_State* L, const int &value);
	static void pushDoubleValue(lua_State* L, const double &value);
	static void pushArrayValue(lua_State* L, const std::vector<ValueWrapper> &value);
	static void pushMapValue(lua_State* L, const MapType &value);
	static void pushValueWrapper(lua_State* L, const ValueWrapper &valueWrapper);
};
