local mType = Game.createMonsterType("Iks Ahpututu")
local monster = {}

monster.description = "an iks ahpututu"
monster.experience = 1700
monster.outfit = {
	lookType = 1590,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2349
monster.Bestiary = {
	class = "Iks",
	race = BESTY_RACE_UNDEAD,
	toKill = 5,
	FirstUnlock = 1,
	SecondUnlock = 2,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Iksupan"
	}

monster.health = 1630
monster.maxHealth = 1630
monster.race = "blood"
monster.corpse = 42065
monster.speed = 110
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 477},
	{id = 281, chance = 710}, -- giant shimmering pearl (green)
	{name = "tiger Eye", chance = 710},
	{name = "strong mana potion", chance = 638, maxCount = 4},
	{name = "small sapphire", chance = 437, maxCount = 5},
	{name = "daedal chisel", chance = 291},
	{name = "opal", chance = 164, maxCount = 2},
	{name = "ritual tooth", chance = 146},
	{name = "spellbook of enlightenment", chance = 109},
	{name = "gold ingot", chance = 73},
	{name = "rotten feather", chance = 73},
	{name = "broken iks faulds", chance = 36},
	{name = "gold-brocaded cloth", chance = 36},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -235},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -250, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = false},
}

monster.defenses = {
	defense = 35,
	armor = 34,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 25},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
