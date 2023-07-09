local mType = Game.createMonsterType("Crape Man")
local monster = {}

monster.description = "a crape man"
monster.experience = 5040
monster.outfit = {
	lookType = 1601,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2337
monster.Bestiary = {
	class = "Hybrids",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol"
	}

monster.health = 9150
monster.maxHealth = 9150
monster.race = "blood"
monster.corpse = 42210
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ungh! Ungh!", yell = false},
	{text = "Klack klack!", yell = false},
	{text = "Hugah!", yell = false},
}

monster.loot = {
	{name = "platinum coin", chance = 7154, maxCount = 26},
	{name = "guardian halberd", chance = 531},
	{name = "crab man claws", chance = 521, maxCount = 2},
	{name = "green gem", chance = 301},
	{name = "great health potion", chance = 200, maxCount = 5},
	{id = 281, chance = 170}, -- giant shimmering pearl (green)
	{name = "lightning legs", chance = 120},
	{name = "warrior's shield", chance = 120},
	{name = "glacier kilt", chance = 100},
	{name = "noble axe", chance = 90},
	{name = "hammer of wrath", chance = 60},
	{name = "ring of the sky", chance = 30},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = 386, maxDamage = -480, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = true},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -360, maxDamage = -420, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -311, maxDamage = -400, length = 3, spread = 3, effect = CONST_ME_ENERGYHIT, target = false},
}

monster.defenses = {
	defense = 50,
	armor = 80,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
