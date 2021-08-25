/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_CONFIG_CONFIG_DEFINITIONS_HPP_
#define SRC_CONFIG_CONFIG_DEFINITIONS_HPP_

// Enum
enum booleanConfig_t {
	ALLOW_CHANGEOUTFIT,
	ONE_PLAYER_ON_ACCOUNT,
	AIMBOT_HOTKEY_ENABLED,
	REMOVE_RUNE_CHARGES,
	EXPERIENCE_FROM_PLAYERS,
	FREE_PREMIUM,
	REPLACE_KICK_ON_LOGIN,
	ALLOW_CLONES,
	BIND_ONLY_GLOBAL_ADDRESS,
	OPTIMIZE_DATABASE,
	MARKET_PREMIUM,
	EMOTE_SPELLS,
	STAMINA_SYSTEM,
	WARN_UNSAFE_SCRIPTS,
	CONVERT_UNSAFE_SCRIPTS,
	CLASSIC_EQUIPMENT_SLOTS,
	CLASSIC_ATTACK_SPEED,
	SCRIPTS_CONSOLE_LOGS,
	REMOVE_WEAPON_AMMO,
	REMOVE_WEAPON_CHARGES,
	REMOVE_POTION_CHARGES,
	SERVER_SAVE_NOTIFY_MESSAGE,
	SERVER_SAVE_CLEAN_MAP,
	SERVER_SAVE_CLOSE,
	SERVER_SAVE_SHUTDOWN,
	FORCE_MONSTERTYPE_LOAD,
	HOUSE_OWNED_BY_ACCOUNT,
	CLEAN_PROTECTION_ZONES,
	STOREMODULES,
	ALLOW_BLOCK_SPAWN,
	ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS,
	WEATHER_RAIN,
	WEATHER_THUNDER,
	FREE_QUESTS,
	ONLY_PREMIUM_ACCOUNT,
	MAP_CUSTOM_ENABLED,
	ALL_CONSOLE_LOG,
	STAMINA_TRAINER,
	STAMINA_PZ,
	PUSH_WHEN_ATTACKING,
	SORT_LOOT_BY_CHANCE,
	SAVE_INTERVAL,
	SAVE_INTERVAL_CLEAN_MAP,

	LAST_BOOLEAN_CONFIG
	};

enum stringConfig_t {
	MAP_NAME,
	HOUSE_RENT_PERIOD,
	SERVER_NAME,
	OWNER_NAME,
	OWNER_EMAIL,
	URL,
	LOCATION,
	IP,
	MOTD,
	WORLD_TYPE,
	MYSQL_HOST,
	MYSQL_USER,
	MYSQL_PASS,
	MYSQL_DB,
	MYSQL_SOCK,
	DEFAULT_PRIORITY,
	MAP_AUTHOR,
	STORE_IMAGES_URL,
	CLIENT_VERSION_STR,
	MAP_CUSTOM_NAME,
	MAP_CUSTOM_FILE,
	MAP_CUSTOM_SPAWN,
	MAP_CUSTOM_AUTHOR,
	DISCORD_WEBHOOK_URL,
	SAVE_INTERVAL_TIME,

	LAST_STRING_CONFIG
	};

enum integerConfig_t {
	SQL_PORT,
	MAX_PLAYERS,
	PZ_LOCKED,
	DEFAULT_DESPAWNRANGE,
	DEFAULT_DESPAWNRADIUS,
	RATE_EXPERIENCE,
	RATE_SKILL,
	RATE_LOOT,
	RATE_MAGIC,
	RATE_SPAWN,
	HOUSE_PRICE,
	MAX_MESSAGEBUFFER,
	ACTIONS_DELAY_INTERVAL,
	EX_ACTIONS_DELAY_INTERVAL,
	KICK_AFTER_MINUTES,
	PROTECTION_LEVEL,
	DEATH_LOSE_PERCENT,
	STATUSQUERY_TIMEOUT,
	FRAG_TIME,
	WHITE_SKULL_TIME,
	GAME_PORT,
	LOGIN_PORT,
	STATUS_PORT,
	STAIRHOP_DELAY,
	MAX_CONTAINER,
	MAX_ITEM,
	MARKET_OFFER_DURATION,
	CLIENT_VERSION,
	DEPOT_BOXES,
	FREE_DEPOT_LIMIT,
	PREMIUM_DEPOT_LIMIT,
	CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES,
	MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER,
	EXP_FROM_PLAYERS_LEVEL_RANGE,
	MAX_PACKETS_PER_SECOND,
	STORE_COIN_PACKET,
	DAY_KILLS_TO_RED,
	WEEK_KILLS_TO_RED,
	MONTH_KILLS_TO_RED,
	RED_SKULL_DURATION,
	BLACK_SKULL_DURATION,
	ORANGE_SKULL_DURATION,
	SERVER_SAVE_NOTIFY_DURATION,
	PUSH_DELAY,
	PUSH_DISTANCE_DELAY,
	STASH_ITEMS,
	PARTY_LIST_MAX_DISTANCE,
	STAMINA_ORANGE_DELAY,
	STAMINA_GREEN_DELAY,
	STAMINA_TRAINER_DELAY,
	STAMINA_PZ_GAIN,
	STAMINA_TRAINER_GAIN,

	LAST_INTEGER_CONFIG
};

enum floatingConfig_t {
	RATE_MONSTER_HEALTH,
	RATE_MONSTER_ATTACK,
	RATE_MONSTER_DEFENSE,

	RATE_NPC_HEALTH,
	RATE_NPC_ATTACK,
	RATE_NPC_DEFENSE,

	LAST_FLOATING_CONFIG
};

#endif  // SRC_CONFIG_CONFIG_DEFINITIONS_HPP_
