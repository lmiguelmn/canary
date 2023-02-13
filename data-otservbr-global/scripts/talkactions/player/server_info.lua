local serverInfo = TalkAction("!serverinfo")
function serverInfo.onSay(player, words, param)
	local configRateSkill =  configManager.getNumber(configKeys.RATE_SKILL)
	local text = "Server Info Rates: \n"
	.. "\nExp rate: " .. configManager.getNumber(configKeys.RATE_EXPERIENCE)
	.. "\nSword Skill rate: " .. getRateFromTable(skills, player:getSkillLevel(SKILL_SWORD), configRateSkill) .. "x"
	.. "\nClub Skill rate: " .. getRateFromTable(skills, player:getSkillLevel(SKILL_CLUB), configRateSkill) .. "x"
	.. "\nAxe Skill rate: "  .. getRateFromTable(skills, player:getSkillLevel(SKILL_AXE), configRateSkill) .. "x"
	.. "\nDistance Skill rate: " .. getRateFromTable(skills, player:getSkillLevel(SKILL_DISTANCE), configRateSkill) .. "x"
	.. "\nShield Skill rate: " .. getRateFromTable(skills, player:getSkillLevel(SKILL_SHIELD), configRateSkill) .. "x"
	.. "\nFist Skill rate: " .. getRateFromTable(skills, player:getSkillLevel(SKILL_FIST), configRateSkill) .. "x"
	.. "\nMagic rate: " .. getRateFromTable(magicLevel, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC)) .. "x"
	.. "\nLoot rate: "  .. configManager.getNumber(configKeys.RATE_LOOT) .. "x"
	.. "\nSpawns rate: " .. configManager.getNumber(configKeys.RATE_SPAWN) .. "x"
	text = text .. "\n"
	text = text .. "\n\nServer Info Stages Rates: \n"
	.. "\nExp rate stages: " ..  getRateFromTable(experienceStages, player:getLevel(), expstagesrate) .. "x"
	.. "\nSword Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SWORD), configRateSkill) .. "x"
	.. "\nClub Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_CLUB), configRateSkill) .. "x"
	.. "\nAxe Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_AXE), configRateSkill) .. "x"
	.. "\nDistance Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_DISTANCE), configRateSkill) .. "x"
	.. "\nShield Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SHIELD), configRateSkill) .. "x"
	.. "\nFist Skill Stages rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_FIST), configRateSkill) .. "x"
	.. "\nMagic rate: " .. getRateFromTable(magicLevelStages, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC)) .. "x"
	.. "\nLoot rate: " .. configManager.getNumber(configKeys.RATE_LOOT) .. "x"
	.. "\nSpawns rate: " .. configManager.getNumber(configKeys.RATE_SPAWN) .. "x"
	text = text .. "\n"
	text = text .. "\n\nMore Server Info: \n"
	.. "\nLevel to buy house: " .. configManager.getNumber(configKeys.HOUSE_BUY_LEVEL) 
  	.. "\nProtection level: " .. configManager.getNumber(configKeys.PROTECTION_LEVEL)
	.. "\nWorldType: " .. configManager.getString(configKeys.WORLD_TYPE)
	.. "\nKills/day to red skull: " .. configManager.getNumber(configKeys.DAY_KILLS_TO_RED)
	.. "\nKills/week to red skull: " .. configManager.getNumber(configKeys.WEEK_KILLS_TO_RED)
	.. "\nKills/month to red skull: " .. configManager.getNumber(configKeys.MONTH_KILLS_TO_RED)
	.. "\nServer Save: " .. configManager.getString(configKeys.GLOBAL_SERVER_SAVE_TIME)
	player:showTextDialog(34266, text)
	return false
end

serverInfo:separator(" ")
serverInfo:register()
