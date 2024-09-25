local experienceMultiplier = configManager.getFloat(configKeys.LIVESTREAM_EXPERIENCE_MULTIPLIER)
local bonusPercent = (experienceMultiplier - 1.0) * 100

local playersStreaming = {}

local helpMessages = {
	"Available commands:\n",
	"!livestream on - enables the stream",
	"!livestream off - disables the stream",
	"!livestream desc, description (or empty for remove) - sets description about your livestream",
	"!livestream desc, remove/delete - removes description",
	"!livestream desc - removes description",
	"!livestream password, password - sets a password on the stream",
	"!livestream password off - disables the password protection",
	"!livestream kick, name - kick a spectator from your stream",
	"!livestream ban, name - locks spectator IP from joining your stream",
	"!livestream unban, name - removes banishment lock",
	"!livestream bans - shows banished spectators list",
	"!livestream mute, name - mutes selected spectator from chat",
	"!livestream unmute, name - removes mute",
	"!livestream mutes - shows muted spectators list",
	"!livestream show - displays the amount and nicknames of current spectators",
	"!livestream status - displays stream status",
}

local talkaction = TalkAction("!livestream")

function talkaction.onSay(player, words, param)
	if FEATURE_LIVESTREAM == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Livestream system is disabled.")
		return false
	end

	local minLevelToLivestream = configManager.getNumber(configKeys.LIVESTREAM_CASTER_MIN_LEVEL)
	if player:getLevel() < minLevelToLivestream then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. minLevelToLivestream .. " to use this command.")
		return false
	end

	local maximumViewers = configManager.getNumber(configKeys.LIVESTREAM_MAXIMUM_VIEWERS)
	if maximumViewers == 0 and not player:isPremium() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be a premium account to use this command.")
		return false
	end

	local split = param:splitTrimmed(",")
	local data = player:getLivestreamViewers()

	if table.contains({ "help" }, split[1]) then
		player:popupFYI(table.concat(helpMessages, "\n"))
	elseif table.contains({ "off", "no", "disable" }, split[1]) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You already have the live stream closed.")
			return true
		end
		data.mutes = {}
		data.broadcast = false
		db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 0, `livestream_viewers` = 0 WHERE `caster_id` = " .. player:getGuid())
		player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently disabled.")
		if experienceMultiplier > 1.0 then
			player:sendTextMessage(MESSAGE_LOOK, "Experience bonus deactivated: -" .. bonusPercent .. "%")
			player:kv():scoped("livestream-system"):remove("experience-bonus")
		end
		playersStreaming[player:getGuid()] = nil
	elseif table.contains({ "on", "yes", "enable" }, split[1]) then
		if data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You already have the live stream open.")
			return true
		end
		data.broadcast = true
		player:sendTextMessage(MESSAGE_STATUS, "You have started live broadcast.")
		db.query("INSERT INTO `active_livestream_casters` (`caster_id`, `livestream_status`) VALUES (" .. player:getGuid() .. ", 1) ON DUPLICATE KEY UPDATE `livestream_status` = 1")
		if experienceMultiplier and experienceMultiplier > 1.0 then
			player:sendTextMessage(MESSAGE_LOOK, "Experience bonus activated: +" .. bonusPercent .. "%")
			player:kv():scoped("livestream-system"):set("experience-bonus", true)
		end
		playersStreaming[player:getGuid()] = true
	elseif table.contains({ "show", "count", "see" }, split[1]) then
		if data.broadcast then
			local count = table.maxn(data.names)
			if count > 0 then
				player:sendTextMessage(MESSAGE_STATUS, "You are currently watched by " .. count .. " people.")
				local str = ""
				for _, name in ipairs(data.names) do
					str = str .. (str:len() > 0 and ", " or "") .. name
				end

				player:sendTextMessage(MESSAGE_STATUS, str .. ".")
			else
				player:sendTextMessage(MESSAGE_STATUS, "None is watching your stream right now.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "kick", "remove" }, split[1]) then
		if data.broadcast then
			if split[2] then
				if split[2]:lower() ~= "all" then
					local found = false
					for _, name in ipairs(data.names) do
						if split[2]:lower() == name:lower() then
							found = true
							break
						end
					end

					if found then
						table.insert(data.kick, split[2])
						player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " has been kicked.")
					else
						player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " not found.")
					end
				else
					data.kick = data.names
					player:sendTextMessage(MESSAGE_STATUS, "All players have been kicked.")
				end
			else
				player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "ban", "block" }, split[1]) then
		if data.broadcast then
			if split[2] then
				local found = false
				for _, name in ipairs(data.names) do
					if split[2]:lower() == name:lower() then
						found = true
						break
					end
				end

				if found then
					table.insert(data.bans, split[2])
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " has been banned.")
				else
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " not found.")
				end
			else
				player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "unban", "unblock" }, split[1]) then
		if data.broadcast then
			if split[2] then
				local found, i = 0, 1
				for _, name in ipairs(data.bans) do
					if split[2]:lower() == name:lower() then
						found = i
						break
					end

					i = i + 1
				end

				if found > 0 then
					table.remove(data.bans, found)
					player:kv():scoped("livestream-system"):remove("ban")
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " has been unbanned.")
				else
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " not found.")
				end
			else
				player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "bans", "banlist" }, split[1]) then
		if table.maxn(data.bans) then
			local str = ""
			for _, name in ipairs(data.bans) do
				str = str .. (str:len() > 0 and ", " or "") .. name
			end

			player:sendTextMessage(MESSAGE_STATUS, "Currently banned spectators: " .. str .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Your ban list is empty.")
		end
	elseif table.contains({ "mute", "squelch" }, split[1]) then
		if data.broadcast then
			if split[2] then
				local found = false
				for _, name in ipairs(data.names) do
					if split[2]:lower() == name:lower() then
						found = true
						break
					end
				end

				if found then
					table.insert(data.mutes, split[2])
					player:kv():scoped("livestream-system"):set("mute", split[2])
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " has been muted.")
				else
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " not found.")
				end
			else
				player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "unmute", "unsquelch" }, split[1]) then
		if data.broadcast then
			if split[2] then
				local found, i = 0, 1
				for _, name in ipairs(data.mutes) do
					if split[2]:lower() == name:lower() then
						found = i
						break
					end

					i = i + 1
				end

				if found > 0 then
					table.remove(data.mutes, found)
					player:kv():scoped("livestream-system"):remove("mute")
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " has been unmuted.")
				else
					player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. split[2] .. " not found.")
				end
			else
				player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		end
	elseif table.contains({ "mutes", "mutelist" }, split[1]) then
		if table.maxn(data.mutes) then
			local str = ""
			for _, name in ipairs(data.mutes) do
				str = str .. (str:len() > 0 and ", " or "") .. name
			end

			player:sendTextMessage(MESSAGE_STATUS, "Currently muted spectators: " .. str .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Your mute list is empty.")
		end
	elseif table.contains({ "password", "guard" }, split[1]) then
		if not split[2] or split[2]:trim() == "" or table.contains({ "off", "no", "disable" }, split[2]) then
			if data.password:len() ~= 0 then
				db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 1 WHERE `caster_id` = " .. player:getGuid())
			end

			data.password = ""
			player:kv():scoped("livestream-system"):remove("password")
			player:sendTextMessage(MESSAGE_STATUS, "You have removed password for your stream.")
			if experienceMultiplier > 1.0 then
				player:sendTextMessage(MESSAGE_LOOK, "Your experience bonus of : " .. experienceMultiplier .. "% was reactivated.")
				player:kv():scoped("livestream-system"):set("experience-bonus", true)
			end
		else
			data.password = string.trim(split[2])
			if data.password:len() ~= 0 then
				db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 3 WHERE `caster_id` = " .. player:getGuid())
			end
			player:sendTextMessage(MESSAGE_STATUS, "You have set new password for your stream.")
			if experienceMultiplier > 1.0 then
				player:sendTextMessage(MESSAGE_LOOK, "Your experience bonus of : " .. bonusPercent .. "% was deactivated.")
				player:kv():scoped("livestream-system"):remove("experience-bonus")
			end
			player:kv():scoped("livestream-system"):set("password", data.password)
		end

		if data.password ~= "" then
			player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently protected with password: " .. data.password .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently not protected.")
		end
	elseif table.contains({ "desc", "description" }, split[1]) then
		if not split[2] or split[2]:trim() == "" or table.contains({ "remove", "delete" }, split[2]) then
			data.description = ""
			player:kv():scoped("livestream-system"):remove("description")
			player:sendTextMessage(MESSAGE_STATUS, "You have removed description for your stream.")
		else
			if split[2]:match("[%a%d%s%u%l]+") ~= split[2] then
				player:sendTextMessage(MESSAGE_STATUS, "Please only A-Z 0-9.")
				return false
			end
			if split[2]:len() > 0 and split[2]:len() <= 50 then
				data.description = split[2]
				player:kv():scoped("livestream-system"):set("description", split[2])
			else
				player:sendTextMessage(MESSAGE_STATUS, "Your description max length 50 characters.")
				return false
			end
			player:sendTextMessage(MESSAGE_STATUS, "Livestream description was set to: " .. split[2] .. ".")
		end
	elseif table.contains({ "status", "info" }, split[1]) then
		player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently " .. (data.broadcast and "enabled" or "disabled") .. ".")
	else
		player:popupFYI(table.concat(helpMessages, "\n"))
	end
	player:setLivestreamViewers(data)

	return true
end

talkaction:separator(" ")
talkaction:groupType("normal")
talkaction:register()

local creaturescript = CreatureEvent("LivestreamLogout")

function creaturescript.onLogout(player)
	db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 0, `livestream_viewers` = 0 WHERE `caster_id` = " .. player:getGuid())
	return true
end

creaturescript:register()

creaturescript = CreatureEvent("LivestreamLogin")

function creaturescript.onLogin(player)
	player:registerEvent("LivestreamLogout")
	db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 0, `livestream_viewers` = 0 WHERE `caster_id` = " .. player:getGuid())
	player:kv():scoped("livestream-system"):remove("experience-bonus")
	return true
end

creaturescript:register()

local globalevent = GlobalEvent("LivestreamThink")

function globalevent.onThink(interval)
	for playerGuid in pairs(playersStreaming) do
		local player = Player(playerGuid)
		if player then
			db.query("UPDATE `active_livestream_casters` SET `livestream_viewers` = " .. player:getLivestreamViewersCount() .. " WHERE `caster_id` = " .. player:getGuid())
		else
			playersStreaming[playerGuid] = nil
		end
	end
	return true
end

globalevent:interval(10000)
globalevent:register()

local livestreamOnStartup = GlobalEvent("LivestreamOnStartup")

function livestreamOnStartup.onStartup()
	db.query("UPDATE `active_livestream_casters` SET `livestream_status` = 0, `livestream_viewers` = 0")
	return true
end

livestreamOnStartup:register()

local gainExperience = EventCallback("LivestreamSystemGainExperience")

function gainExperience.playerOnGainExperience(player, target, exp, rawExp)
	local livestreamStatus = player:kv():scoped("livestream-system"):get("experience-bonus") and 1 or 0
	if experienceMultiplier > 1.0 and livestreamStatus > 0 then
		exp = math.floor(exp * experienceMultiplier + 0.5)
		logger.debug("Original exp: {}, livestream exp: {} for creature {}", rawExp, exp, target:getName())
	end

	return exp
end

gainExperience:register()
