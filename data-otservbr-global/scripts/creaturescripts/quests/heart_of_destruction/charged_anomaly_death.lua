local config = {
	bossName = "Anomaly",
	bossPosition = Position(32271, 31249, 14),
}

local monsterTable = {
	[1] = 72500,
	[2] = 145000,
	[3] = 217500,
	[4] = 275500,
}


local chargedAnomalyDeath = CreatureEvent("ChargedAnomalyDeath")

function chargedAnomalyDeath.onDeath(creature)
	local healthRemove = monsterTable[Game.getStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly)]
	if not healthRemove then
		return true
	end

	local boss = Game.createMonster(config.bossName, bossPosition, false, true)
	if boss then
		boss:addHealth(-healthRemove)
	end

	return true
end

chargedAnomalyDeath:register()