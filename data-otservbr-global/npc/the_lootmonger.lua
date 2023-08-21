local internalNpcName = "The Lootmonger"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1575,
	lookHead = 96,
	lookBody = 101,
	lookLegs = 120,
	lookFeet = 120,
	lookAddons = 2
}

npcConfig.flags = { floorchange = false }

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = { {
	itemName = "abyss hammer",
	clientId = 7414,
	sell = 20000
}, {
	itemName = "acorn",
	clientId = 10296,
	sell = 10
}, {
	itemName = "albino plate",
	clientId = 19358,
	sell = 1500
}, {
	itemName = "alloy legs",
	clientId = 21168,
	sell = 11000
}, {
	itemName = "alptramun's toothbrush",
	clientId = 29943,
	sell = 270000
}, {
	itemName = "amber staff",
	clientId = 7426,
	sell = 8000
}, {
	itemName = "amber with a bug",
	clientId = 32624,
	sell = 41000
}, {
	itemName = "amber with a dragonfly",
	clientId = 32625,
	sell = 56000
}, {
	itemName = "amber",
	clientId = 32626,
	sell = 20000
}, {
	itemName = "ancient amulet",
	clientId = 3025,
	sell = 200
}, {
	itemName = "ancient belt buckle",
	clientId = 24384,
	sell = 260
}, {
	itemName = "ancient coin",
	clientId = 24390,
	sell = 350
}, {
	itemName = "ancient liche bone",
	clientId = 31588,
	sell = 28000
}, {
	itemName = "ancient shield",
	clientId = 3432,
	sell = 900
}, {
	itemName = "ancient stone",
	clientId = 9632,
	sell = 200
}, {
	itemName = "angel figurine",
	clientId = 32589,
	sell = 36000
}, {
	itemName = "angelic axe",
	clientId = 7436,
	sell = 5000
}, {
	itemName = "ankh",
	clientId = 3077,
	sell = 100
}, {
	itemName = "antlers",
	clientId = 10297,
	sell = 50
}, {
	itemName = "ape fur",
	clientId = 5883,
	sell = 120
}, {
	itemName = "apron",
	clientId = 33933,
	sell = 1300
}, {
	itemName = "arbalest",
	clientId = 5803,
	sell = 42000
}, {
	itemName = "arcane staff",
	clientId = 3341,
	sell = 42000
}, {
	itemName = "assassin dagger",
	clientId = 7404,
	sell = 20000
}, {
	itemName = "axe ring",
	clientId = 3092,
	sell = 100
}, {
	itemName = "axe",
	clientId = 3274,
	sell = 7
}, {
	itemName = "baby seal doll",
	clientId = 7183,
	sell = 20000
}, {
	itemName = "badger boots",
	clientId = 22086,
	sell = 7500
}, {
	itemName = "badger fur",
	clientId = 903,
	sell = 15
}, {
	itemName = "bamboo stick",
	clientId = 11445,
	sell = 30
}, {
	itemName = "banana sash",
	clientId = 11511,
	sell = 55
}, {
	itemName = "bandana",
	clientId = 5917,
	sell = 150
}, {
	itemName = "bar of gold",
	clientId = 14112,
	sell = 10000
}, {
	itemName = "basalt fetish",
	clientId = 17856,
	sell = 210
}, {
	itemName = "basalt figurine",
	clientId = 17857,
	sell = 160
}, {
	itemName = "bat decoration",
	clientId = 6491,
	sell = 2000
}, {
	itemName = "bat wing",
	clientId = 5894,
	sell = 50
}, {
	itemName = "battle axe",
	clientId = 3266,
	sell = 80
}, {
	itemName = "battle hammer",
	clientId = 3305,
	sell = 120
}, {
	itemName = "battle shield",
	clientId = 3413,
	sell = 95
}, {
	itemName = "battle stone",
	clientId = 11447,
	sell = 290
}, {
	itemName = "batwing hat",
	clientId = 9103,
	sell = 8000
}, {
	itemName = "bear paw",
	clientId = 5896,
	sell = 100
}, {
	itemName = "beast's nightmare-cushion",
	clientId = 29946,
	sell = 630000
}, {
	itemName = "beastslayer axe",
	clientId = 3344,
	sell = 1500
}, {
	itemName = "bed of nails",
	clientId = 25743,
	sell = 500
}, {
	itemName = "beer tap",
	clientId = 32114,
	sell = 50
}, {
	itemName = "beetle carapace",
	clientId = 24381,
	sell = 200
}, {
	itemName = "beetle necklace",
	clientId = 10457,
	sell = 1500
}, {
	itemName = "behemoth claw",
	clientId = 5930,
	sell = 2000
}, {
	itemName = "behemoth trophy",
	clientId = 7396,
	sell = 20000
}, {
	itemName = "bejeweled ship's telescope",
	clientId = 9616,
	sell = 20000
}, {
	itemName = "belted cape",
	clientId = 8044,
	sell = 500
}, {
	itemName = "berserk potion",
	clientId = 7439,
	sell = 500
}, {
	itemName = "berserker",
	clientId = 7403,
	sell = 40000
}, {
	itemName = "black hood",
	clientId = 9645,
	sell = 190
}, {
	itemName = "black pearl",
	clientId = 3027,
	sell = 280
}, {
	itemName = "black shield",
	clientId = 3429,
	sell = 800
}, {
	itemName = "black skull",
	clientId = 9056,
	sell = 4000
}, {
	itemName = "black wool",
	clientId = 11448,
	sell = 300
}, {
	itemName = "blacksteel sword",
	clientId = 7406,
	sell = 6000
}, {
	itemName = "blade of corruption",
	clientId = 11693,
	sell = 60000
}, {
	itemName = "blazing bone",
	clientId = 16131,
	sell = 610
}, {
	itemName = "blessed sceptre",
	clientId = 7429,
	sell = 40000
}, {
	itemName = "blood goblet",
	clientId = 8531,
	sell = 10000
}, {
	itemName = "blood herb",
	clientId = 3734,
	sell = 500
}, {
	itemName = "blood preservation",
	clientId = 11449,
	sell = 320
}, {
	itemName = "blood tincture in a vial",
	clientId = 18928,
	sell = 360
}, {
	itemName = "bloody dwarven beard",
	clientId = 17827,
	sell = 110
}, {
	itemName = "bloody edge",
	clientId = 7416,
	sell = 30000
}, {
	itemName = "bloody pincers",
	clientId = 9633,
	sell = 100
}, {
	itemName = "bloody tears",
	clientId = 32594,
	sell = 70000
}, {
	itemName = "blue crystal shard",
	clientId = 16119,
	sell = 1500
}, {
	itemName = "blue crystal splinter",
	clientId = 16124,
	sell = 400
}, {
	itemName = "blue gem",
	clientId = 3041,
	sell = 5000
}, {
	itemName = "blue glass plate",
	clientId = 29345,
	sell = 60
}, {
	itemName = "blue goanna scale",
	clientId = 31559,
	sell = 230
}, {
	itemName = "blue legs",
	clientId = 645,
	sell = 15000
}, {
	itemName = "blue piece of cloth",
	clientId = 5912,
	sell = 200
}, {
	itemName = "blue robe",
	clientId = 3567,
	sell = 10000
}, {
	itemName = "blue rose",
	clientId = 3659,
	sell = 250
}, {
	itemName = "boar man hoof",
	clientId = 40584,
	sell = 600
}, {
	itemName = "boggy dreads",
	clientId = 9667,
	sell = 200
}, {
	itemName = "bola",
	clientId = 17809,
	sell = 35
}, {
	itemName = "bone club",
	clientId = 3337,
	sell = 5
}, {
	itemName = "bone fetish",
	clientId = 17831,
	sell = 150
}, {
	itemName = "bone shield",
	clientId = 3441,
	sell = 80
}, {
	itemName = "bone shoulderplate",
	clientId = 10404,
	sell = 150
}, {
	itemName = "bone sword",
	clientId = 3338,
	sell = 20
}, {
	itemName = "bone toothpick",
	clientId = 24380,
	sell = 150
}, {
	itemName = "bonebeast trophy",
	clientId = 10244,
	sell = 6000
}, {
	itemName = "bonebreaker",
	clientId = 7428,
	sell = 10000
}, {
	itemName = "bonecarving knife",
	clientId = 17830,
	sell = 190
}, {
	itemName = "bonelord eye",
	clientId = 5898,
	sell = 80
}, {
	itemName = "bonelord helmet",
	clientId = 3408,
	sell = 7500
}, {
	itemName = "bonelord shield",
	clientId = 3418,
	sell = 1200
}, {
	itemName = "bones of zorvorax",
	clientId = 24942,
	sell = 10000
}, {
	itemName = "bony tail",
	clientId = 10277,
	sell = 210
}, {
	itemName = "book of necromantic rituals",
	clientId = 10320,
	sell = 180
}, {
	itemName = "book of prayers",
	clientId = 9646,
	sell = 120
}, {
	itemName = "book page",
	clientId = 28569,
	sell = 640
}, {
	itemName = "boots of haste",
	clientId = 3079,
	sell = 30000
}, {
	itemName = "bowl of terror sweat",
	clientId = 20204,
	sell = 500
}, {
	itemName = "brain head's giant neuron",
	clientId = 32578,
	sell = 100000
}, {
	itemName = "brain head's left hemisphere",
	clientId = 32579,
	sell = 90000
}, {
	itemName = "brain head's right hemisphere",
	clientId = 32580,
	sell = 50000
}, {
	itemName = "brass armor",
	clientId = 3359,
	sell = 150
}, {
	itemName = "brass helmet",
	clientId = 3354,
	sell = 30
}, {
	itemName = "brass legs",
	clientId = 3372,
	sell = 49
}, {
	itemName = "brass shield",
	clientId = 3411,
	sell = 25
}, {
	itemName = "bright bell",
	clientId = 30324,
	sell = 220
}, {
	itemName = "bright sword",
	clientId = 3295,
	sell = 6000
}, {
	itemName = "brimstone fangs",
	clientId = 11702,
	sell = 380
}, {
	itemName = "brimstone shell",
	clientId = 11703,
	sell = 210
}, {
	itemName = "broadsword",
	clientId = 3301,
	sell = 500
}, {
	itemName = "broken bell",
	clientId = 30185,
	sell = 150
}, {
	itemName = "broken crossbow",
	clientId = 11451,
	sell = 30
}, {
	itemName = "broken draken mail",
	clientId = 11660,
	sell = 340
}, {
	itemName = "broken gladiator shield",
	clientId = 9656,
	sell = 190
}, {
	itemName = "broken halberd",
	clientId = 10418,
	sell = 100
}, {
	itemName = "broken helmet",
	clientId = 11453,
	sell = 20
}, {
	itemName = "broken iks faulds",
	clientId = 40531,
	sell = 530
}, {
	itemName = "broken key ring",
	clientId = 11652,
	sell = 8000
}, {
	itemName = "broken longbow",
	clientId = 34161,
	sell = 130
}, {
	itemName = "broken ring of ending",
	clientId = 12737,
	sell = 4000
}, {
	itemName = "broken shamanic staff",
	clientId = 11452,
	sell = 35
}, {
	itemName = "broken slicer",
	clientId = 11661,
	sell = 120
}, {
	itemName = "broken throwing axe",
	clientId = 17851,
	sell = 230
}, {
	itemName = "broken visor",
	clientId = 20184,
	sell = 1900
}, {
	itemName = "bronze amulet",
	clientId = 3056,
	sell = 50,
	count = 200
}, {
	itemName = "brooch of embracement",
	clientId = 34023,
	sell = 14000
}, {
	itemName = "brown crystal splinter",
	clientId = 16123,
	sell = 400
}, {
	itemName = "brown giant shimmering pearl",
	clientId = 282,
	sell = 3000
}, {
	itemName = "brown piece of cloth",
	clientId = 5913,
	sell = 100
}, {
	itemName = "brutetamer's staff",
	clientId = 7379,
	sell = 1500
}, {
	itemName = "buckle",
	clientId = 17829,
	sell = 7000
}, {
	itemName = "bullseye potion",
	clientId = 7443,
	sell = 500
}, {
	itemName = "bunch of ripe rice",
	clientId = 10328,
	sell = 75
}, {
	itemName = "bunch of troll hair",
	clientId = 9689,
	sell = 30
}, {
	itemName = "bundle of cursed straw",
	clientId = 9688,
	sell = 800
}, {
	itemName = "butcher's axe",
	clientId = 7412,
	sell = 18000
}, {
	itemName = "butterfly ring",
	clientId = 25698,
	sell = 2000
}, {
	itemName = "calopteryx cape",
	clientId = 14086,
	sell = 15000
}, {
	itemName = "capricious heart",
	clientId = 34138,
	sell = 2100
}, {
	itemName = "capricious robe",
	clientId = 34145,
	sell = 1200
}, {
	itemName = "carapace shield",
	clientId = 14088,
	sell = 32000
}, {
	itemName = "carlin sword",
	clientId = 3283,
	sell = 118
}, {
	itemName = "carniphila seeds",
	clientId = 10300,
	sell = 50
}, {
	itemName = "carnivostrich feathers",
	clientId = 40586,
	sell = 550
}, {
	itemName = "carrion worm fang",
	clientId = 10275,
	sell = 35
}, {
	itemName = "castle shield",
	clientId = 3435,
	sell = 5000
}, {
	itemName = "cat's paw",
	clientId = 5479,
	sell = 2000
}, {
	itemName = "cave devourer eyes",
	clientId = 27599,
	sell = 550
}, {
	itemName = "cave devourer legs",
	clientId = 27601,
	sell = 350
}, {
	itemName = "cave devourer maw",
	clientId = 27600,
	sell = 600
}, {
	itemName = "cavebear skull",
	clientId = 12316,
	sell = 550
}, {
	itemName = "centipede leg",
	clientId = 10301,
	sell = 28
}, {
	itemName = "ceremonial ankh",
	clientId = 6561,
	sell = 20000
}, {
	itemName = "chain armor",
	clientId = 3358,
	sell = 70
}, {
	itemName = "chain bolter",
	clientId = 8022,
	sell = 40000
}, {
	itemName = "chain helmet",
	clientId = 3352,
	sell = 17
}, {
	itemName = "chain legs",
	clientId = 3558,
	sell = 25
}, {
	itemName = "chaos mace",
	clientId = 7427,
	sell = 9000
}, {
	itemName = "chasm spawn abdomen",
	clientId = 27603,
	sell = 240
}, {
	itemName = "chasm spawn head",
	clientId = 27602,
	sell = 850
}, {
	itemName = "chasm spawn tail",
	clientId = 27604,
	sell = 120
}, {
	itemName = "cheese cutter",
	clientId = 17817,
	sell = 50
}, {
	itemName = "cheesy figurine",
	clientId = 17818,
	sell = 150
}, {
	itemName = "cheesy membership card",
	clientId = 35614,
	sell = 120000
}, {
	itemName = "chicken feather",
	clientId = 5890,
	sell = 30
}, {
	itemName = "chitinous mouth",
	clientId = 27626,
	sell = 10000
}, {
	itemName = "claw of 'the noxious spawn'",
	clientId = 9392,
	sell = 15000
}, {
	itemName = "cliff strider claw",
	clientId = 16134,
	sell = 800
}, {
	itemName = "closed trap",
	clientId = 3481,
	sell = 75
}, {
	itemName = "club ring",
	clientId = 3093,
	sell = 100
}, {
	itemName = "club",
	clientId = 3270,
	sell = 1
}, {
	itemName = "cluster of solace",
	clientId = 20062,
	sell = 500
}, {
	itemName = "coal",
	clientId = 12600,
	sell = 20
}, {
	itemName = "coat",
	clientId = 3562,
	sell = 1
}, {
	itemName = "cobra crest",
	clientId = 31678,
	sell = 650
}, {
	itemName = "cobra crown",
	clientId = 11674,
	sell = 50000
}, {
	itemName = "cobra tongue",
	clientId = 9634,
	sell = 15
}, {
	itemName = "coconut shoes",
	clientId = 9017,
	sell = 500
}, {
	itemName = "collar of blue plasma",
	clientId = 23542,
	sell = 6000
}, {
	itemName = "collar of green plasma",
	clientId = 23543,
	sell = 6000
}, {
	itemName = "collar of red plasma",
	clientId = 23544,
	sell = 6000
}, {
	itemName = "colourful feather",
	clientId = 11514,
	sell = 110
}, {
	itemName = "colourful feathers",
	clientId = 25089,
	sell = 400
}, {
	itemName = "compass",
	clientId = 10302,
	sell = 45
}, {
	itemName = "composite hornbow",
	clientId = 8027,
	sell = 25000
}, {
	itemName = "compound eye",
	clientId = 14083,
	sell = 150
}, {
	itemName = "condensed energy",
	clientId = 23501,
	sell = 260
}, {
	itemName = "copper shield",
	clientId = 3430,
	sell = 50
}, {
	itemName = "coral branch",
	clientId = 39406,
	sell = 360
}, {
	itemName = "coral brooch",
	clientId = 24391,
	sell = 750
}, {
	itemName = "corrupt naga scales",
	clientId = 39415,
	sell = 570
}, {
	itemName = "corrupted flag",
	clientId = 10409,
	sell = 700
}, {
	itemName = "countess sorrow's frozen tear",
	clientId = 6536,
	sell = 50000
}, {
	itemName = "cow bell",
	clientId = 32012,
	sell = 120
}, {
	itemName = "cowbell",
	clientId = 21204,
	sell = 210
}, {
	itemName = "cowtana",
	clientId = 21177,
	sell = 2500
}, {
	itemName = "crab man claw",
	clientId = 40582,
	sell = 550
}, {
	itemName = "crab pincers",
	clientId = 10272,
	sell = 35
}, {
	itemName = "cracked alabaster vase",
	clientId = 24385,
	sell = 180
}, {
	itemName = "cranial basher",
	clientId = 7415,
	sell = 30000
}, {
	itemName = "crawler head plating",
	clientId = 14079,
	sell = 210
}, {
	itemName = "crawler's essence",
	clientId = 33982,
	sell = 3700
}, {
	itemName = "crest of the deep seas",
	clientId = 21892,
	sell = 10000
}, {
	itemName = "crocodile boots",
	clientId = 3556,
	sell = 1000
}, {
	itemName = "crowbar",
	clientId = 3304,
	sell = 50
}, {
	itemName = "crown armor",
	clientId = 3381,
	sell = 12000
}, {
	itemName = "crown helmet",
	clientId = 3385,
	sell = 2500
}, {
	itemName = "crown legs",
	clientId = 3382,
	sell = 12000
}, {
	itemName = "crown shield",
	clientId = 3419,
	sell = 8000
}, {
	itemName = "crown",
	clientId = 33935,
	sell = 2700
}, {
	itemName = "cruelty's chest",
	clientId = 33923,
	sell = 720000
}, {
	itemName = "cruelty's claw",
	clientId = 33922,
	sell = 640000
}, {
	itemName = "crunor idol",
	clientId = 30055,
	sell = 30000
}, {
	itemName = "crusader helmet",
	clientId = 3391,
	sell = 6000
}, {
	itemName = "cry-stal",
	clientId = 39394,
	sell = 3200
}, {
	itemName = "crystal ball",
	clientId = 3076,
	sell = 190
}, {
	itemName = "crystal bone",
	clientId = 23521,
	sell = 250
}, {
	itemName = "crystal crossbow",
	clientId = 16163,
	sell = 35000
}, {
	itemName = "crystal mace",
	clientId = 3333,
	sell = 12000
}, {
	itemName = "crystal necklace",
	clientId = 3008,
	sell = 400
}, {
	itemName = "crystal of balance",
	clientId = 9028,
	sell = 1000
}, {
	itemName = "crystal of focus",
	clientId = 9027,
	sell = 2000
}, {
	itemName = "crystal of power",
	clientId = 9067,
	sell = 3000
}, {
	itemName = "crystal pedestal",
	clientId = 9063,
	sell = 500
}, {
	itemName = "crystal ring",
	clientId = 3007,
	sell = 250
}, {
	itemName = "crystal sword",
	clientId = 7449,
	sell = 600
}, {
	itemName = "crystal wand",
	clientId = 3068,
	sell = 10000
}, {
	itemName = "crystalline armor",
	clientId = 8050,
	sell = 16000
}, {
	itemName = "crystalline spikes",
	clientId = 16138,
	sell = 440
}, {
	itemName = "crystalline sword",
	clientId = 16160,
	sell = 2000
}, {
	itemName = "crystallized anger",
	clientId = 23507,
	sell = 400
}, {
	itemName = "cultish mask",
	clientId = 9638,
	sell = 280
}, {
	itemName = "cultish robe",
	clientId = 9639,
	sell = 150
}, {
	itemName = "cultish symbol",
	clientId = 11455,
	sell = 500
}, {
	itemName = "curious matter",
	clientId = 23511,
	sell = 430
}, {
	itemName = "cursed bone",
	clientId = 32774,
	sell = 6000
}, {
	itemName = "cursed shoulder spikes",
	clientId = 10410,
	sell = 320
}, {
	itemName = "cyan crystal fragment",
	clientId = 16125,
	sell = 800
}, {
	itemName = "cyclops toe",
	clientId = 9657,
	sell = 55
}, {
	itemName = "cyclops trophy",
	clientId = 7398,
	sell = 500
}, {
	itemName = "daedal chisel",
	clientId = 40522,
	sell = 480
}, {
	itemName = "dagger",
	clientId = 3267,
	sell = 2
}, {
	itemName = "damaged armor plates",
	clientId = 28822,
	sell = 280
}, {
	itemName = "damaged worm head",
	clientId = 27620,
	sell = 8000
}, {
	itemName = "damselfly eye",
	clientId = 17463,
	sell = 25
}, {
	itemName = "damselfly wing",
	clientId = 17458,
	sell = 20
}, {
	itemName = "dandelion seeds",
	clientId = 25695,
	sell = 200
}, {
	itemName = "dangerous proto matter",
	clientId = 23515,
	sell = 300
}, {
	itemName = "daramian mace",
	clientId = 3327,
	sell = 110
}, {
	itemName = "daramian waraxe",
	clientId = 3328,
	sell = 1000
}, {
	itemName = "dark armor",
	clientId = 3383,
	sell = 400
}, {
	itemName = "dark bell",
	clientId = 32596,
	sell = 310000
}, {
	itemName = "dark helmet",
	clientId = 3384,
	sell = 250
}, {
	itemName = "dark mushroom",
	clientId = 3728,
	sell = 100
}, {
	itemName = "dark rosary",
	clientId = 10303,
	sell = 48
}, {
	itemName = "dark shield",
	clientId = 3421,
	sell = 400
}, {
	itemName = "dead weight",
	clientId = 20202,
	sell = 450
}, {
	itemName = "death ring",
	clientId = 6299,
	sell = 1000
}, {
	itemName = "death toll",
	clientId = 32703,
	sell = 1000
}, {
	itemName = "deepling axe",
	clientId = 13991,
	sell = 40000
}, {
	itemName = "deepling breaktime snack",
	clientId = 14011,
	sell = 90
}, {
	itemName = "deepling claw",
	clientId = 14044,
	sell = 430
}, {
	itemName = "deepling guard belt buckle",
	clientId = 14010,
	sell = 230
}, {
	itemName = "deepling ridge",
	clientId = 14041,
	sell = 360
}, {
	itemName = "deepling scales",
	clientId = 14017,
	sell = 80
}, {
	itemName = "deepling squelcher",
	clientId = 14250,
	sell = 7000
}, {
	itemName = "deepling staff",
	clientId = 13987,
	sell = 4000
}, {
	itemName = "deepling warts",
	clientId = 14012,
	sell = 180
}, {
	itemName = "deeptags",
	clientId = 14013,
	sell = 290
}, {
	itemName = "deepworm jaws",
	clientId = 27594,
	sell = 500
}, {
	itemName = "deepworm spike roots",
	clientId = 27593,
	sell = 650
}, {
	itemName = "deepworm spikes",
	clientId = 27592,
	sell = 800
}, {
	itemName = "deer trophy",
	clientId = 7397,
	sell = 3000
}, {
	itemName = "demon dust",
	clientId = 5526,
	sell = 300
}, {
	itemName = "demon dust",
	clientId = 5906,
	sell = 300
}, {
	itemName = "demon helmet",
	clientId = 3387,
	sell = 40000
}, {
	itemName = "demon horn",
	clientId = 5954,
	sell = 1000
}, {
	itemName = "demon shield",
	clientId = 3420,
	sell = 30000
}, {
	itemName = "demon trophy",
	clientId = 7393,
	sell = 40000
}, {
	itemName = "demonbone amulet",
	clientId = 3019,
	sell = 32000
}, {
	itemName = "demonic essence",
	clientId = 6499,
	sell = 1000
}, {
	itemName = "demonic finger",
	clientId = 12541,
	sell = 1000
}, {
	itemName = "demonic skeletal hand",
	clientId = 9647,
	sell = 80
}, {
	itemName = "demonrage sword",
	clientId = 7382,
	sell = 36000
}, {
	itemName = "depth calcei",
	clientId = 13997,
	sell = 25000
}, {
	itemName = "depth galea",
	clientId = 13995,
	sell = 35000
}, {
	itemName = "depth lorica",
	clientId = 13994,
	sell = 30000
}, {
	itemName = "depth ocrea",
	clientId = 13996,
	sell = 16000
}, {
	itemName = "depth scutum",
	clientId = 13998,
	sell = 36000
}, {
	itemName = "devil helmet",
	clientId = 3356,
	sell = 1000
}, {
	itemName = "diabolic skull",
	clientId = 34025,
	sell = 19000
}, {
	itemName = "diamond sceptre",
	clientId = 7387,
	sell = 3000
}, {
	itemName = "diamond",
	clientId = 32770,
	sell = 15000
}, {
	itemName = "diremaw brainpan",
	clientId = 27597,
	sell = 350
}, {
	itemName = "diremaw legs",
	clientId = 27598,
	sell = 270
}, {
	itemName = "dirty turban",
	clientId = 11456,
	sell = 120
}, {
	itemName = "disgusting trophy",
	clientId = 10421,
	sell = 3000
}, {
	itemName = "distorted heart",
	clientId = 34142,
	sell = 2100
}, {
	itemName = "distorted robe",
	clientId = 34149,
	sell = 1200
}, {
	itemName = "divine plate",
	clientId = 8057,
	sell = 55000
}, {
	itemName = "djinn blade",
	clientId = 3339,
	sell = 15000
}, {
	itemName = "doll",
	clientId = 2991,
	sell = 200
}, {
	itemName = "double axe",
	clientId = 3275,
	sell = 260
}, {
	itemName = "doublet",
	clientId = 3379,
	sell = 3
}, {
	itemName = "downy feather",
	clientId = 11684,
	sell = 20
}, {
	itemName = "dowser",
	clientId = 19110,
	sell = 35
}, {
	itemName = "drachaku",
	clientId = 10391,
	sell = 10000
}, {
	itemName = "dracola's eye",
	clientId = 6546,
	sell = 50000
}, {
	itemName = "dracoyle statue",
	clientId = 9034,
	sell = 5000
}, {
	itemName = "dragon blood",
	clientId = 24937,
	sell = 700
}, {
	itemName = "dragon claw",
	clientId = 5919,
	sell = 8000
}, {
	itemName = "dragon figurine",
	clientId = 30053,
	sell = 45000
}, {
	itemName = "dragon hammer",
	clientId = 3322,
	sell = 2000
}, {
	itemName = "dragon lance",
	clientId = 3302,
	sell = 9000
}, {
	itemName = "dragon lord trophy",
	clientId = 7399,
	sell = 10000
}, {
	itemName = "dragon necklace",
	clientId = 3085,
	sell = 100,
	count = 200
}, {
	itemName = "dragon priest's wandtip",
	clientId = 10444,
	sell = 175
}, {
	itemName = "dragon robe",
	clientId = 8039,
	sell = 50000
}, {
	itemName = "dragon scale mail",
	clientId = 3386,
	sell = 40000
}, {
	itemName = "dragon shield",
	clientId = 3416,
	sell = 4000
}, {
	itemName = "dragon slayer",
	clientId = 7402,
	sell = 15000
}, {
	itemName = "dragon tongue",
	clientId = 24938,
	sell = 550
}, {
	itemName = "dragon's tail",
	clientId = 11457,
	sell = 100
}, {
	itemName = "dragonbone staff",
	clientId = 7430,
	sell = 3000
}, {
	itemName = "draken boots",
	clientId = 4033,
	sell = 40000
}, {
	itemName = "draken sulphur",
	clientId = 11658,
	sell = 550
}, {
	itemName = "draken trophy",
	clientId = 10398,
	sell = 15000
}, {
	itemName = "draken wristbands",
	clientId = 11659,
	sell = 430
}, {
	itemName = "drakinata",
	clientId = 10388,
	sell = 10000
}, {
	itemName = "draptor scales",
	clientId = 12309,
	sell = 800
}, {
	itemName = "dreaded cleaver",
	clientId = 7419,
	sell = 15000
}, {
	itemName = "dream blossom staff",
	clientId = 25700,
	sell = 5000
}, {
	itemName = "dream essence egg",
	clientId = 30005,
	sell = 205
}, {
	itemName = "dung ball",
	clientId = 14225,
	sell = 130
}, {
	itemName = "dwarven armor",
	clientId = 3397,
	sell = 30000
}, {
	itemName = "dwarven axe",
	clientId = 3323,
	sell = 1500
}, {
	itemName = "dwarven legs",
	clientId = 3398,
	sell = 40000
}, {
	itemName = "dwarven ring",
	clientId = 3097,
	sell = 100
}, {
	itemName = "dwarven shield",
	clientId = 3425,
	sell = 100
}, {
	itemName = "earflap",
	clientId = 17819,
	sell = 40
}, {
	itemName = "ectoplasmic sushi",
	clientId = 11681,
	sell = 300
}, {
	itemName = "egg of the many",
	clientId = 9606,
	sell = 15000
}, {
	itemName = "elder bonelord tentacle",
	clientId = 10276,
	sell = 150
}, {
	itemName = "eldritch crystal",
	clientId = 36835,
	sell = 48000
}, {
	itemName = "elite draken mail",
	clientId = 11651,
	sell = 50000
}, {
	itemName = "elven amulet",
	clientId = 3082,
	sell = 100,
	count = 50
}, {
	itemName = "elven astral observer",
	clientId = 11465,
	sell = 90
}, {
	itemName = "elven hoof",
	clientId = 18994,
	sell = 115
}, {
	itemName = "elven scouting glass",
	clientId = 11464,
	sell = 50
}, {
	itemName = "elvish bow",
	clientId = 7438,
	sell = 2000
}, {
	itemName = "elvish talisman",
	clientId = 9635,
	sell = 45
}, {
	itemName = "emerald bangle",
	clientId = 3010,
	sell = 800
}, {
	itemName = "emerald tortoise shell",
	clientId = 39379,
	sell = 2150
}, {
	itemName = "empty honey glass",
	clientId = 31331,
	sell = 270
}, {
	itemName = "empty potion flask",
	clientId = 283,
	sell = 5
}, {
	itemName = "empty potion flask",
	clientId = 284,
	sell = 5
}, {
	itemName = "empty potion flask",
	clientId = 285,
	sell = 5
}, {
	itemName = "enchanted chicken wing",
	clientId = 5891,
	sell = 20000
}, {
	itemName = "energy ball",
	clientId = 23523,
	sell = 300
}, {
	itemName = "energy ring",
	clientId = 3051,
	sell = 100
}, {
	itemName = "energy vein",
	clientId = 23508,
	sell = 270
}, {
	itemName = "enigmatic voodoo skull",
	clientId = 5669,
	sell = 4000
}, {
	itemName = "ensouled essence",
	clientId = 32698,
	sell = 820
}, {
	itemName = "epee",
	clientId = 3326,
	sell = 8000
}, {
	itemName = "essence of a bad dream",
	clientId = 10306,
	sell = 360
}, {
	itemName = "ethno coat",
	clientId = 8064,
	sell = 200
}, {
	itemName = "execowtioner axe",
	clientId = 21176,
	sell = 12000
}, {
	itemName = "execowtioner mask",
	clientId = 21201,
	sell = 240
}, {
	itemName = "executioner",
	clientId = 7453,
	sell = 55000
}, {
	itemName = "explorer brooch",
	clientId = 4871,
	sell = 50
}, {
	itemName = "eye of a deepling",
	clientId = 12730,
	sell = 150
}, {
	itemName = "eye of a weeper",
	clientId = 16132,
	sell = 650
}, {
	itemName = "eye of corruption",
	clientId = 11671,
	sell = 390
}, {
	itemName = "fafnar symbol",
	clientId = 31443,
	sell = 950
}, {
	itemName = "fairy wings",
	clientId = 25694,
	sell = 200
}, {
	itemName = "falcon crest",
	clientId = 28823,
	sell = 650
}, {
	itemName = "fern",
	clientId = 3737,
	sell = 20
}, {
	itemName = "fiery heart",
	clientId = 9636,
	sell = 375
}, {
	itemName = "fiery tear",
	clientId = 39040,
	sell = 1070000
}, {
	itemName = "fig leaf",
	clientId = 25742,
	sell = 200
}, {
	itemName = "figurine of cruelty",
	clientId = 34019,
	sell = 3100000
}, {
	itemName = "figurine of greed",
	clientId = 34021,
	sell = 2900000
}, {
	itemName = "figurine of hatred",
	clientId = 34020,
	sell = 2700000
}, {
	itemName = "figurine of malice",
	clientId = 34018,
	sell = 2800000
}, {
	itemName = "figurine of megalomania",
	clientId = 33953,
	sell = 5000000
}, {
	itemName = "figurine of spite",
	clientId = 33952,
	sell = 3000000
}, {
	itemName = "fir cone",
	clientId = 19111,
	sell = 25
}, {
	itemName = "fire axe",
	clientId = 3320,
	sell = 8000
}, {
	itemName = "fire mushroom",
	clientId = 3731,
	sell = 200
}, {
	itemName = "fire sword",
	clientId = 3280,
	sell = 4000
}, {
	itemName = "first verse of the hymn",
	clientId = 6087,
	sell = 100
}, {
	itemName = "fish fin",
	clientId = 5895,
	sell = 150
}, {
	itemName = "fishing rod",
	clientId = 3483,
	sell = 40
}, {
	itemName = "flask of embalming fluid",
	clientId = 11466,
	sell = 30
}, {
	itemName = "flask of warrior's sweat",
	clientId = 5885,
	sell = 10000
}, {
	itemName = "flintstone",
	clientId = 12806,
	sell = 800
}, {
	itemName = "flotsam",
	clientId = 39407,
	sell = 330
}, {
	itemName = "flower dress",
	clientId = 9015,
	sell = 1000
}, {
	itemName = "flower wreath",
	clientId = 9013,
	sell = 500
}, {
	itemName = "focus cape",
	clientId = 8043,
	sell = 6000
}, {
	itemName = "fourth verse of the hymn",
	clientId = 6090,
	sell = 800
}, {
	itemName = "fox paw",
	clientId = 27462,
	sell = 100
}, {
	itemName = "frazzle skin",
	clientId = 20199,
	sell = 400
}, {
	itemName = "frazzle tongue",
	clientId = 20198,
	sell = 700
}, {
	itemName = "frost giant pelt",
	clientId = 9658,
	sell = 160
}, {
	itemName = "frosty ear of a troll",
	clientId = 9648,
	sell = 30
}, {
	itemName = "frosty heart",
	clientId = 9661,
	sell = 280
}, {
	itemName = "frozen lightning",
	clientId = 23519,
	sell = 270
}, {
	itemName = "frozen starlight",
	clientId = 3249,
	sell = 20000
}, {
	itemName = "fur armor",
	clientId = 22085,
	sell = 5000
}, {
	itemName = "fur boots",
	clientId = 7457,
	sell = 2000
}, {
	itemName = "fur shred",
	clientId = 34164,
	sell = 200
}, {
	itemName = "furry club",
	clientId = 7432,
	sell = 1000
}, {
	itemName = "garlic necklace",
	clientId = 3083,
	sell = 50
}, {
	itemName = "gauze bandage",
	clientId = 9649,
	sell = 90
}, {
	itemName = "gear crystal",
	clientId = 9655,
	sell = 200
}, {
	itemName = "gear wheel",
	clientId = 8775,
	sell = 500
}, {
	itemName = "gearwheel chain",
	clientId = 21170,
	sell = 5000
}, {
	itemName = "gemmed figurine",
	clientId = 24392,
	sell = 3500
}, {
	itemName = "geomancer's robe",
	clientId = 11458,
	sell = 80
}, {
	itemName = "geomancer's staff",
	clientId = 11463,
	sell = 120
}, {
	itemName = "ghastly dragon head",
	clientId = 10449,
	sell = 700
}, {
	itemName = "ghostly tissue",
	clientId = 9690,
	sell = 90
}, {
	itemName = "ghoul snack",
	clientId = 11467,
	sell = 60
}, {
	itemName = "giant amethyst",
	clientId = 32622,
	sell = 60000
}, {
	itemName = "giant crab pincer",
	clientId = 12317,
	sell = 950
}, {
	itemName = "giant emerald",
	clientId = 30060,
	sell = 90000
}, {
	itemName = "giant eye",
	clientId = 10280,
	sell = 380
}, {
	itemName = "giant pacifier",
	clientId = 21199,
	sell = 170
}, {
	itemName = "giant ruby",
	clientId = 30059,
	sell = 70000
}, {
	itemName = "giant sapphire",
	clientId = 30061,
	sell = 50000
}, {
	itemName = "giant sword",
	clientId = 3281,
	sell = 17000
}, {
	itemName = "giant tentacle",
	clientId = 27619,
	sell = 10000
}, {
	itemName = "giant topaz",
	clientId = 32623,
	sell = 80000
}, {
	itemName = "girlish hair decoration",
	clientId = 11443,
	sell = 30
}, {
	itemName = "glacial rod",
	clientId = 16118,
	sell = 6500
}, {
	itemName = "glacier amulet",
	clientId = 815,
	sell = 1500
}, {
	itemName = "glacier kilt",
	clientId = 823,
	sell = 11000
}, {
	itemName = "glacier mask",
	clientId = 829,
	sell = 2500
}, {
	itemName = "glacier robe",
	clientId = 824,
	sell = 11000
}, {
	itemName = "glacier shoes",
	clientId = 819,
	sell = 2500
}, {
	itemName = "gland",
	clientId = 8143,
	sell = 500
}, {
	itemName = "glistening bone",
	clientId = 23522,
	sell = 250
}, {
	itemName = "glob of acid slime",
	clientId = 9054,
	sell = 25
}, {
	itemName = "glob of glooth",
	clientId = 21182,
	sell = 125
}, {
	itemName = "glob of mercury",
	clientId = 9053,
	sell = 20
}, {
	itemName = "glob of tar",
	clientId = 9055,
	sell = 30
}, {
	itemName = "gloom wolf fur",
	clientId = 22007,
	sell = 70
}, {
	itemName = "glooth amulet",
	clientId = 21183,
	sell = 2000
}, {
	itemName = "glooth axe",
	clientId = 21180,
	sell = 1500
}, {
	itemName = "glooth blade",
	clientId = 21179,
	sell = 1500
}, {
	itemName = "glooth cap",
	clientId = 21164,
	sell = 7000
}, {
	itemName = "glooth club",
	clientId = 21178,
	sell = 1500
}, {
	itemName = "glooth injection tube",
	clientId = 21103,
	sell = 350
}, {
	itemName = "glooth whip",
	clientId = 21172,
	sell = 2500
}, {
	itemName = "glorious axe",
	clientId = 7454,
	sell = 3000
}, {
	itemName = "glowing rune",
	clientId = 28570,
	sell = 350
}, {
	itemName = "goanna claw",
	clientId = 31561,
	sell = 260
}, {
	itemName = "goanna meat",
	clientId = 31560,
	sell = 190
}, {
	itemName = "goat grass",
	clientId = 3674,
	sell = 50
}, {
	itemName = "goblet of gloom",
	clientId = 34022,
	sell = 12000
}, {
	itemName = "goblin ear",
	clientId = 11539,
	sell = 20
}, {
	itemName = "gold ingot",
	clientId = 9058,
	sell = 5000
}, {
	itemName = "gold nugget",
	clientId = 3040,
	sell = 850
}, {
	itemName = "gold ring",
	clientId = 3063,
	sell = 8000
}, {
	itemName = "gold-brocaded cloth",
	clientId = 40529,
	sell = 175
}, {
	itemName = "golden amulet",
	clientId = 3013,
	sell = 2000
}, {
	itemName = "golden armor",
	clientId = 3360,
	sell = 20000
}, {
	itemName = "golden brush",
	clientId = 25689,
	sell = 250
}, {
	itemName = "golden cheese wedge",
	clientId = 35581,
	sell = 6000
}, {
	itemName = "golden dustbin",
	clientId = 35579,
	sell = 7000
}, {
	itemName = "golden fafnar trophy",
	clientId = 9626,
	sell = 10000
}, {
	itemName = "golden figurine",
	clientId = 5799,
	sell = 3000
}, {
	itemName = "golden legs",
	clientId = 3364,
	sell = 30000
}, {
	itemName = "golden lotus brooch",
	clientId = 21974,
	sell = 270
}, {
	itemName = "golden mask",
	clientId = 31324,
	sell = 38000
}, {
	itemName = "golden mug",
	clientId = 2903,
	sell = 250
}, {
	itemName = "golden sickle",
	clientId = 3306,
	sell = 1000
}, {
	itemName = "golden skull",
	clientId = 35580,
	sell = 9000
}, {
	itemName = "goo shell",
	clientId = 19372,
	sell = 4000
}, {
	itemName = "goosebump leather",
	clientId = 20205,
	sell = 650
}, {
	itemName = "gore horn",
	clientId = 39377,
	sell = 2900
}, {
	itemName = "gorerilla mane",
	clientId = 39392,
	sell = 2750
}, {
	itemName = "gorerilla tail",
	clientId = 39393,
	sell = 2650
}, {
	itemName = "grant of arms",
	clientId = 28824,
	sell = 950
}, {
	itemName = "grappling hook",
	clientId = 35588,
	sell = 150
}, {
	itemName = "grasshopper legs",
	clientId = 14087,
	sell = 15000
}, {
	itemName = "grave flower",
	clientId = 3661,
	sell = 25
}, {
	itemName = "greed's arm",
	clientId = 33924,
	sell = 950000
}, {
	itemName = "green bandage",
	clientId = 25697,
	sell = 180
}, {
	itemName = "green crystal fragment",
	clientId = 16127,
	sell = 800
}, {
	itemName = "green crystal shard",
	clientId = 16121,
	sell = 1500
}, {
	itemName = "green crystal splinter",
	clientId = 16122,
	sell = 400
}, {
	itemName = "green dragon leather",
	clientId = 5877,
	sell = 100
}, {
	itemName = "green dragon scale",
	clientId = 5920,
	sell = 100
}, {
	itemName = "green gem",
	clientId = 3038,
	sell = 5000
}, {
	itemName = "green giant shimmering pearl",
	clientId = 281,
	sell = 3000
}, {
	itemName = "green glass plate",
	clientId = 29346,
	sell = 180
}, {
	itemName = "green mushroom",
	clientId = 3732,
	sell = 100
}, {
	itemName = "green piece of cloth",
	clientId = 5910,
	sell = 200
}, {
	itemName = "greenwood coat",
	clientId = 8041,
	sell = 50000
}, {
	itemName = "griffin shield",
	clientId = 3433,
	sell = 3000
}, {
	itemName = "grimace",
	clientId = 32593,
	sell = 120000
}, {
	itemName = "gruesome fan",
	clientId = 34024,
	sell = 15000
}, {
	itemName = "guardian axe",
	clientId = 14043,
	sell = 9000
}, {
	itemName = "guardian boots",
	clientId = 10323,
	sell = 35000
}, {
	itemName = "guardian halberd",
	clientId = 3315,
	sell = 11000
}, {
	itemName = "guardian shield",
	clientId = 3415,
	sell = 2000
}, {
	itemName = "guidebook",
	clientId = 25745,
	sell = 200
}, {
	itemName = "hailstorm rod",
	clientId = 3067,
	sell = 3000
}, {
	itemName = "hair of a banshee",
	clientId = 11446,
	sell = 350
}, {
	itemName = "halberd",
	clientId = 3269,
	sell = 400
}, {
	itemName = "half-digested piece of meat",
	clientId = 10283,
	sell = 55
}, {
	itemName = "half-digested stones",
	clientId = 27369,
	sell = 40
}, {
	itemName = "half-eaten brain",
	clientId = 9659,
	sell = 85
}, {
	itemName = "hammer of wrath",
	clientId = 3332,
	sell = 30000
}, {
	itemName = "hand axe",
	clientId = 3268,
	sell = 4
}, {
	itemName = "hand",
	clientId = 33936,
	sell = 1450
}, {
	itemName = "hardened bone",
	clientId = 5925,
	sell = 70
}, {
	itemName = "harpoon of a giant snail",
	clientId = 27625,
	sell = 15000
}, {
	itemName = "harpy feather",
	clientId = 40585,
	sell = 730
}, {
	itemName = "hatched rorc egg",
	clientId = 18997,
	sell = 30
}, {
	itemName = "hatchet",
	clientId = 3276,
	sell = 25
}, {
	itemName = "haunted blade",
	clientId = 7407,
	sell = 8000
}, {
	itemName = "haunted piece of wood",
	clientId = 9683,
	sell = 115
}, {
	itemName = "hazardous heart",
	clientId = 34140,
	sell = 5000
}, {
	itemName = "hazardous robe",
	clientId = 34147,
	sell = 3000
}, {
	itemName = "head",
	clientId = 33937,
	sell = 3500
}, {
	itemName = "headchopper",
	clientId = 7380,
	sell = 6000
}, {
	itemName = "headpecker beak",
	clientId = 39387,
	sell = 2800
}, {
	itemName = "headpecker feather",
	clientId = 39388,
	sell = 1300
}, {
	itemName = "heat core",
	clientId = 21167,
	sell = 10000
}, {
	itemName = "heaven blossom",
	clientId = 3657,
	sell = 50
}, {
	itemName = "heaven blossom",
	clientId = 5921,
	sell = 50
}, {
	itemName = "heavy mace",
	clientId = 3340,
	sell = 50000
}, {
	itemName = "heavy machete",
	clientId = 3330,
	sell = 90
}, {
	itemName = "heavy old tome",
	clientId = 23986,
	sell = 30
}, {
	itemName = "heavy trident",
	clientId = 12683,
	sell = 2000
}, {
	itemName = "hellhound slobber",
	clientId = 9637,
	sell = 500
}, {
	itemName = "hellspawn tail",
	clientId = 10304,
	sell = 475
}, {
	itemName = "helmet of the lost",
	clientId = 17852,
	sell = 2000
}, {
	itemName = "hemp rope",
	clientId = 20206,
	sell = 350
}, {
	itemName = "heroic axe",
	clientId = 7389,
	sell = 30000
}, {
	itemName = "hexagonal ruby",
	clientId = 30180,
	sell = 30000
}, {
	itemName = "hibiscus dress",
	clientId = 8045,
	sell = 3000
}, {
	itemName = "hideous chunk",
	clientId = 16140,
	sell = 510
}, {
	itemName = "hieroglyph banner",
	clientId = 12482,
	sell = 500
}, {
	itemName = "high guard flag",
	clientId = 10415,
	sell = 550
}, {
	itemName = "high guard shoulderplates",
	clientId = 10416,
	sell = 130
}, {
	itemName = "hive bow",
	clientId = 14246,
	sell = 28000
}, {
	itemName = "hive scythe",
	clientId = 14089,
	sell = 17000
}, {
	itemName = "hollow stampor hoof",
	clientId = 12314,
	sell = 400
}, {
	itemName = "holy ash",
	clientId = 17850,
	sell = 160
}, {
	itemName = "holy orchid",
	clientId = 5922,
	sell = 90
}, {
	itemName = "honeycomb",
	clientId = 5902,
	sell = 40
}, {
	itemName = "horn of kalyassa",
	clientId = 24941,
	sell = 10000
}, {
	itemName = "horn",
	clientId = 19359,
	sell = 300
}, {
	itemName = "horoscope",
	clientId = 18926,
	sell = 40
}, {
	itemName = "huge chunk of crude iron",
	clientId = 5892,
	sell = 15000
}, {
	itemName = "huge shell",
	clientId = 27621,
	sell = 15000
}, {
	itemName = "huge spiky snail shell",
	clientId = 27627,
	sell = 8000
}, {
	itemName = "humongous chunk",
	clientId = 16139,
	sell = 540
}, {
	itemName = "hunter's quiver",
	clientId = 11469,
	sell = 80
}, {
	itemName = "hydra egg",
	clientId = 4839,
	sell = 500
}, {
	itemName = "hydra head",
	clientId = 10282,
	sell = 600
}, {
	itemName = "hydrophytes",
	clientId = 39410,
	sell = 220
}, {
	itemName = "ice flower",
	clientId = 30058,
	sell = 370
}, {
	itemName = "ice rapier",
	clientId = 3284,
	sell = 1000
}, {
	itemName = "incantation notes",
	clientId = 18929,
	sell = 90
}, {
	itemName = "infernal heart",
	clientId = 34139,
	sell = 2100
}, {
	itemName = "infernal robe",
	clientId = 34146,
	sell = 1200
}, {
	itemName = "inkwell",
	clientId = 28568,
	sell = 720
}, {
	itemName = "instable proto matter",
	clientId = 23516,
	sell = 300
}, {
	itemName = "iron helmet",
	clientId = 3353,
	sell = 150
}, {
	itemName = "iron ore",
	clientId = 5880,
	sell = 500
}, {
	itemName = "ivory carving",
	clientId = 33945,
	sell = 300
}, {
	itemName = "ivory comb",
	clientId = 32773,
	sell = 8000
}, {
	itemName = "izcandar's snow globe",
	clientId = 29944,
	sell = 180000
}, {
	itemName = "izcandar's sundial",
	clientId = 29945,
	sell = 225000
}, {
	itemName = "jacket",
	clientId = 3561,
	sell = 1
}, {
	itemName = "jade hammer",
	clientId = 7422,
	sell = 25000
}, {
	itemName = "jade hat",
	clientId = 10451,
	sell = 9000
}, {
	itemName = "jagged sickle",
	clientId = 32595,
	sell = 150000
}, {
	itemName = "jaws",
	clientId = 34014,
	sell = 3900
}, {
	itemName = "jewelled belt",
	clientId = 11470,
	sell = 180
}, {
	itemName = "jungle moa claw",
	clientId = 39404,
	sell = 160
}, {
	itemName = "jungle moa egg",
	clientId = 39405,
	sell = 250
}, {
	itemName = "jungle moa feather",
	clientId = 39403,
	sell = 140
}, {
	itemName = "katana",
	clientId = 3300,
	sell = 35
}, {
	itemName = "katex' blood",
	clientId = 34100,
	sell = 210
}, {
	itemName = "key to the drowned library",
	clientId = 14009,
	sell = 330
}, {
	itemName = "knight armor",
	clientId = 3370,
	sell = 5000
}, {
	itemName = "knight axe",
	clientId = 3318,
	sell = 2000
}, {
	itemName = "knight legs",
	clientId = 3371,
	sell = 5000
}, {
	itemName = "kollos shell",
	clientId = 14077,
	sell = 420
}, {
	itemName = "kongra's shoulderpad",
	clientId = 11471,
	sell = 100
}, {
	itemName = "krimhorn helmet",
	clientId = 7461,
	sell = 200
}, {
	itemName = "lamassu hoof",
	clientId = 31441,
	sell = 330
}, {
	itemName = "lamassu horn",
	clientId = 31442,
	sell = 240
}, {
	itemName = "lancer beetle shell",
	clientId = 10455,
	sell = 80
}, {
	itemName = "lancet",
	clientId = 18925,
	sell = 90
}, {
	itemName = "lavos armor",
	clientId = 8049,
	sell = 16000
}, {
	itemName = "leaf legs",
	clientId = 9014,
	sell = 500
}, {
	itemName = "leaf star",
	clientId = 25735,
	sell = 50
}, {
	itemName = "leather armor",
	clientId = 3361,
	sell = 12
}, {
	itemName = "leather boots",
	clientId = 3552,
	sell = 2
}, {
	itemName = "leather helmet",
	clientId = 3355,
	sell = 4
}, {
	itemName = "leather legs",
	clientId = 3559,
	sell = 9
}, {
	itemName = "legion helmet",
	clientId = 3374,
	sell = 22
}, {
	itemName = "legionnaire flags",
	clientId = 10417,
	sell = 500
}, {
	itemName = "leopard armor",
	clientId = 3404,
	sell = 1000
}, {
	itemName = "leviathan's amulet",
	clientId = 9303,
	sell = 3000
}, {
	itemName = "life crystal",
	clientId = 3061,
	sell = 85
}, {
	itemName = "life preserver",
	clientId = 17813,
	sell = 300
}, {
	itemName = "life ring",
	clientId = 3052,
	sell = 50
}, {
	itemName = "light shovel",
	clientId = 5710,
	sell = 300
}, {
	itemName = "lightning boots",
	clientId = 820,
	sell = 2500
}, {
	itemName = "lightning headband",
	clientId = 828,
	sell = 2500
}, {
	itemName = "lightning legs",
	clientId = 822,
	sell = 11000
}, {
	itemName = "lightning pendant",
	clientId = 816,
	sell = 1500
}, {
	itemName = "lightning robe",
	clientId = 825,
	sell = 11000
}, {
	itemName = "liodile fang",
	clientId = 40583,
	sell = 480
}, {
	itemName = "lion cloak patch",
	clientId = 34162,
	sell = 190
}, {
	itemName = "lion crest",
	clientId = 34160,
	sell = 270
}, {
	itemName = "lion figurine",
	clientId = 33781,
	sell = 10000
}, {
	itemName = "lion seal",
	clientId = 34163,
	sell = 210
}, {
	itemName = "lion trophy",
	clientId = 7400,
	sell = 3000
}, {
	itemName = "lion's mane",
	clientId = 9691,
	sell = 60
}, {
	itemName = "little bowl of myrrh",
	clientId = 25702,
	sell = 500
}, {
	itemName = "lizard essence",
	clientId = 11680,
	sell = 300
}, {
	itemName = "lizard heart",
	clientId = 31340,
	sell = 530
}, {
	itemName = "lizard leather",
	clientId = 5876,
	sell = 150
}, {
	itemName = "lizard scale",
	clientId = 5881,
	sell = 120
}, {
	itemName = "lizard trophy",
	clientId = 10419,
	sell = 8000
}, {
	itemName = "longing eyes",
	clientId = 27624,
	sell = 8000
}, {
	itemName = "longsword",
	clientId = 3285,
	sell = 51
}, {
	itemName = "lost basher's spike",
	clientId = 17826,
	sell = 280
}, {
	itemName = "lost bracers",
	clientId = 17853,
	sell = 140
}, {
	itemName = "lost husher's staff",
	clientId = 17848,
	sell = 250
}, {
	itemName = "lost soul",
	clientId = 32227,
	sell = 120
}, {
	itemName = "luminescent crystal pickaxe",
	clientId = 32711,
	sell = 50
}, {
	itemName = "luminous orb",
	clientId = 11454,
	sell = 1000
}, {
	itemName = "lump of dirt",
	clientId = 9692,
	sell = 10
}, {
	itemName = "lump of earth",
	clientId = 10305,
	sell = 130
}, {
	itemName = "lunar staff",
	clientId = 7424,
	sell = 5000
}, {
	itemName = "mace",
	clientId = 3286,
	sell = 30
}, {
	itemName = "machete",
	clientId = 3308,
	sell = 6
}, {
	itemName = "mad froth",
	clientId = 17854,
	sell = 80
}, {
	itemName = "magic light wand",
	clientId = 3046,
	sell = 35
}, {
	itemName = "magic plate armor",
	clientId = 3366,
	sell = 90000
}, {
	itemName = "magic sulphur",
	clientId = 5904,
	sell = 8000
}, {
	itemName = "magma amulet",
	clientId = 817,
	sell = 1500
}, {
	itemName = "magma boots",
	clientId = 818,
	sell = 2500
}, {
	itemName = "magma clump",
	clientId = 16130,
	sell = 570
}, {
	itemName = "magma coat",
	clientId = 826,
	sell = 11000
}, {
	itemName = "magma legs",
	clientId = 821,
	sell = 11000
}, {
	itemName = "magma monocle",
	clientId = 827,
	sell = 2500
}, {
	itemName = "makara fin",
	clientId = 39401,
	sell = 350
}, {
	itemName = "makara tongue",
	clientId = 39402,
	sell = 320
}, {
	itemName = "malice's horn",
	clientId = 33920,
	sell = 620000
}, {
	itemName = "malice's spine",
	clientId = 33921,
	sell = 850000
}, {
	itemName = "malofur's lunchbox",
	clientId = 30088,
	sell = 240000
}, {
	itemName = "mammoth fur cape",
	clientId = 7463,
	sell = 6000
}, {
	itemName = "mammoth fur shorts",
	clientId = 7464,
	sell = 850
}, {
	itemName = "mammoth tusk",
	clientId = 10321,
	sell = 100
}, {
	itemName = "mammoth whopper",
	clientId = 7381,
	sell = 300
}, {
	itemName = "mandrake",
	clientId = 5014,
	sell = 5000
}, {
	itemName = "mantassin tail",
	clientId = 11489,
	sell = 280
}, {
	itemName = "manticore ear",
	clientId = 31440,
	sell = 310
}, {
	itemName = "manticore tail",
	clientId = 31439,
	sell = 220
}, {
	itemName = "mantosaurus jaw",
	clientId = 39386,
	sell = 2800
}, {
	itemName = "marlin trophy",
	clientId = 902,
	sell = 5000
}, {
	itemName = "marsh stalker beak",
	clientId = 17461,
	sell = 65
}, {
	itemName = "marsh stalker feather",
	clientId = 17462,
	sell = 50
}, {
	itemName = "mastermind potion",
	clientId = 7440,
	sell = 500
}, {
	itemName = "mastermind shield",
	clientId = 3414,
	sell = 50000
}, {
	itemName = "maxilla",
	clientId = 12315,
	sell = 250
}, {
	itemName = "maxxenius head",
	clientId = 29942,
	sell = 500000
}, {
	itemName = "meat hammer",
	clientId = 32093,
	sell = 60
}, {
	itemName = "medal of valiance",
	clientId = 31591,
	sell = 410000
}, {
	itemName = "medusa shield",
	clientId = 3436,
	sell = 9000
}, {
	itemName = "megalomania's essence",
	clientId = 33928,
	sell = 1900000
}, {
	itemName = "megalomania's skull",
	clientId = 33925,
	sell = 1500000
}, {
	itemName = "mercenary sword",
	clientId = 7386,
	sell = 12000
}, {
	itemName = "mercurial wing",
	clientId = 39395,
	sell = 2500
}, {
	itemName = "metal bat",
	clientId = 21171,
	sell = 9000
}, {
	itemName = "metal jaw",
	clientId = 21193,
	sell = 260
}, {
	itemName = "metal spats",
	clientId = 21169,
	sell = 2000
}, {
	itemName = "metal spike",
	clientId = 10298,
	sell = 320
}, {
	itemName = "metal toe",
	clientId = 21198,
	sell = 430
}, {
	itemName = "might ring",
	clientId = 3048,
	sell = 250,
	count = 20
}, {
	itemName = "milk churn",
	clientId = 32011,
	sell = 100
}, {
	itemName = "mind stone",
	clientId = 3062,
	sell = 100
}, {
	itemName = "mino lance",
	clientId = 21174,
	sell = 7000
}, {
	itemName = "mino shield",
	clientId = 21175,
	sell = 3000
}, {
	itemName = "minotaur horn",
	clientId = 11472,
	sell = 75
}, {
	itemName = "minotaur leather",
	clientId = 5878,
	sell = 80
}, {
	itemName = "minotaur trophy",
	clientId = 7401,
	sell = 500
}, {
	itemName = "miraculum",
	clientId = 11474,
	sell = 60
}, {
	itemName = "model ship",
	clientId = 2994,
	sell = 1000
}, {
	itemName = "modified crossbow",
	clientId = 8021,
	sell = 10000
}, {
	itemName = "mooh'tah plate",
	clientId = 21166,
	sell = 6000
}, {
	itemName = "mooh'tah shell",
	clientId = 21202,
	sell = 110
}, {
	itemName = "moohtant cudgel",
	clientId = 21173,
	sell = 14000
}, {
	itemName = "moohtant horn",
	clientId = 21200,
	sell = 140
}, {
	itemName = "moonlight rod",
	clientId = 3070,
	sell = 200
}, {
	itemName = "moonstone",
	clientId = 32771,
	sell = 13000
}, {
	itemName = "morbid tapestry",
	clientId = 34170,
	sell = 30000
}, {
	itemName = "morning star",
	clientId = 3282,
	sell = 100
}, {
	itemName = "mould heart",
	clientId = 34141,
	sell = 2100
}, {
	itemName = "mould robe",
	clientId = 34148,
	sell = 1200
}, {
	itemName = "mouldy powder",
	clientId = 35596,
	sell = 200
}, {
	itemName = "mr. punish's handcuffs",
	clientId = 6537,
	sell = 50000
}, {
	itemName = "muck rod",
	clientId = 16117,
	sell = 6000
}, {
	itemName = "mucus plug",
	clientId = 16102,
	sell = 500
}, {
	itemName = "mutated bat ear",
	clientId = 9662,
	sell = 420
}, {
	itemName = "mutated flesh",
	clientId = 10308,
	sell = 50
}, {
	itemName = "mutated rat tail",
	clientId = 9668,
	sell = 150
}, {
	itemName = "mycological bow",
	clientId = 16164,
	sell = 35000
}, {
	itemName = "mysterious fetish",
	clientId = 3078,
	sell = 50
}, {
	itemName = "mysterious voodoo skull",
	clientId = 5668,
	sell = 4000
}, {
	itemName = "mystic blade",
	clientId = 7384,
	sell = 30000
}, {
	itemName = "mystic turban",
	clientId = 3574,
	sell = 150
}, {
	itemName = "mystical hourglass",
	clientId = 9660,
	sell = 700
}, {
	itemName = "naginata",
	clientId = 3314,
	sell = 2000
}, {
	itemName = "necklace of the deep",
	clientId = 13990,
	sell = 3000
}, {
	itemName = "necromantic robe",
	clientId = 11475,
	sell = 250
}, {
	itemName = "necromantic rust",
	clientId = 21196,
	sell = 390
}, {
	itemName = "necrotic rod",
	clientId = 3069,
	sell = 1000
}, {
	itemName = "nettle blossom",
	clientId = 10314,
	sell = 75
}, {
	itemName = "nettle spit",
	clientId = 11476,
	sell = 25
}, {
	itemName = "nightmare blade",
	clientId = 7418,
	sell = 35000
}, {
	itemName = "noble amulet",
	clientId = 31595,
	sell = 430000
}, {
	itemName = "noble armor",
	clientId = 3380,
	sell = 900
}, {
	itemName = "noble axe",
	clientId = 7456,
	sell = 10000
}, {
	itemName = "noble cape",
	clientId = 31593,
	sell = 425000
}, {
	itemName = "noble turban",
	clientId = 11486,
	sell = 430
}, {
	itemName = "norse shield",
	clientId = 7460,
	sell = 1500
}, {
	itemName = "northwind rod",
	clientId = 8083,
	sell = 1500
}, {
	itemName = "nose ring",
	clientId = 5804,
	sell = 2000
}, {
	itemName = "obsidian lance",
	clientId = 3313,
	sell = 500
}, {
	itemName = "odd organ",
	clientId = 23510,
	sell = 410
}, {
	itemName = "ogre ear stud",
	clientId = 22188,
	sell = 180
}, {
	itemName = "ogre nose ring",
	clientId = 22189,
	sell = 210
}, {
	itemName = "old parchment",
	clientId = 4831,
	sell = 500
}, {
	itemName = "one of timira's many heads",
	clientId = 39399,
	sell = 215000
}, {
	itemName = "onyx chip",
	clientId = 22193,
	sell = 500
}, {
	itemName = "onyx flail",
	clientId = 7421,
	sell = 22000
}, {
	itemName = "onyx pendant",
	clientId = 22195,
	sell = 3500
}, {
	itemName = "opal",
	clientId = 22194,
	sell = 500
}, {
	itemName = "orange mushroom",
	clientId = 3726,
	sell = 150
}, {
	itemName = "orb",
	clientId = 3060,
	sell = 750
}, {
	itemName = "orc leather",
	clientId = 11479,
	sell = 30
}, {
	itemName = "orc tooth",
	clientId = 10196,
	sell = 150
}, {
	itemName = "orc trophy",
	clientId = 7395,
	sell = 1000
}, {
	itemName = "orcish axe",
	clientId = 3316,
	sell = 350
}, {
	itemName = "orcish gear",
	clientId = 11477,
	sell = 85
}, {
	itemName = "orcish maul",
	clientId = 7392,
	sell = 6000
}, {
	itemName = "orichalcum pearl",
	clientId = 5021,
	sell = 40
}, {
	itemName = "oriental shoes",
	clientId = 21981,
	sell = 15000
}, {
	itemName = "ornamented axe",
	clientId = 7411,
	sell = 20000
}, {
	itemName = "ornamented shield",
	clientId = 3424,
	sell = 1500
}, {
	itemName = "ornate chestplate",
	clientId = 13993,
	sell = 60000
}, {
	itemName = "ornate crossbow",
	clientId = 14247,
	sell = 12000
}, {
	itemName = "ornate legs",
	clientId = 13999,
	sell = 40000
}, {
	itemName = "ornate locket",
	clientId = 30056,
	sell = 18000
}, {
	itemName = "ornate mace",
	clientId = 14001,
	sell = 42000
}, {
	itemName = "ornate shield",
	clientId = 14000,
	sell = 42000
}, {
	itemName = "pair of hellflayer horns",
	clientId = 22729,
	sell = 1300
}, {
	itemName = "pair of iron fists",
	clientId = 17828,
	sell = 4000
}, {
	itemName = "pair of old bracers",
	clientId = 32705,
	sell = 500
}, {
	itemName = "paladin armor",
	clientId = 8063,
	sell = 15000
}, {
	itemName = "pale worm's scalp",
	clientId = 32598,
	sell = 489000
}, {
	itemName = "panda teddy",
	clientId = 5080,
	sell = 30000
}, {
	itemName = "panpipes",
	clientId = 2953,
	sell = 150
}, {
	itemName = "panther head",
	clientId = 12039,
	sell = 750
}, {
	itemName = "panther paw",
	clientId = 12040,
	sell = 300
}, {
	itemName = "parder fur",
	clientId = 39418,
	sell = 150
}, {
	itemName = "parder tooth",
	clientId = 39417,
	sell = 150
}, {
	itemName = "patch of fine cloth",
	clientId = 28821,
	sell = 1350
}, {
	itemName = "patched boots",
	clientId = 3550,
	sell = 2000
}, {
	itemName = "peacock feather fan",
	clientId = 21975,
	sell = 350
}, {
	itemName = "pelvis bone",
	clientId = 11481,
	sell = 30
}, {
	itemName = "percht horns",
	clientId = 30186,
	sell = 200
}, {
	itemName = "perfect behemoth fang",
	clientId = 5893,
	sell = 250
}, {
	itemName = "pet pig",
	clientId = 16165,
	sell = 1500
}, {
	itemName = "petrified scream",
	clientId = 10420,
	sell = 250
}, {
	itemName = "phantasmal hair",
	clientId = 32704,
	sell = 500
}, {
	itemName = "pharaoh banner",
	clientId = 12483,
	sell = 1000
}, {
	itemName = "pharaoh sword",
	clientId = 3334,
	sell = 23000
}, {
	itemName = "phoenix shield",
	clientId = 3439,
	sell = 16000
}, {
	itemName = "pick",
	clientId = 3456,
	sell = 15
}, {
	itemName = "piece of archer armor",
	clientId = 11483,
	sell = 20
}, {
	itemName = "piece of crocodile leather",
	clientId = 10279,
	sell = 15
}, {
	itemName = "piece of dead brain",
	clientId = 9663,
	sell = 420
}, {
	itemName = "piece of draconian steel",
	clientId = 5889,
	sell = 3000
}, {
	itemName = "piece of hell steel",
	clientId = 5888,
	sell = 500
}, {
	itemName = "piece of hellfire armor",
	clientId = 9664,
	sell = 550
}, {
	itemName = "piece of massacre's shell",
	clientId = 6540,
	sell = 50000
}, {
	itemName = "piece of royal steel",
	clientId = 5887,
	sell = 10000
}, {
	itemName = "piece of scarab shell",
	clientId = 9641,
	sell = 45
}, {
	itemName = "piece of swampling wood",
	clientId = 17823,
	sell = 30
}, {
	itemName = "piece of timira's sensors",
	clientId = 39400,
	sell = 150000
}, {
	itemName = "piece of warrior armor",
	clientId = 11482,
	sell = 50
}, {
	itemName = "pieces of magic chalk",
	clientId = 18930,
	sell = 210
}, {
	itemName = "pig foot",
	clientId = 9693,
	sell = 10
}, {
	itemName = "pile of grave earth",
	clientId = 11484,
	sell = 25
}, {
	itemName = "pirat's tail",
	clientId = 35573,
	sell = 180
}, {
	itemName = "pirate boots",
	clientId = 5461,
	sell = 3000
}, {
	itemName = "pirate coin",
	clientId = 35572,
	sell = 110
}, {
	itemName = "pirate hat",
	clientId = 6096,
	sell = 1000
}, {
	itemName = "pirate knee breeches",
	clientId = 5918,
	sell = 200
}, {
	itemName = "pirate shirt",
	clientId = 6095,
	sell = 500
}, {
	itemName = "pirate voodoo doll",
	clientId = 5810,
	sell = 500
}, {
	itemName = "plagueroot offshoot",
	clientId = 30087,
	sell = 280000
}, {
	itemName = "plasma pearls",
	clientId = 23506,
	sell = 250
}, {
	itemName = "plasmatic lightning",
	clientId = 23520,
	sell = 270
}, {
	itemName = "plate armor",
	clientId = 3357,
	sell = 400
}, {
	itemName = "plate legs",
	clientId = 3557,
	sell = 115
}, {
	itemName = "plate shield",
	clientId = 3410,
	sell = 45
}, {
	itemName = "platinum amulet",
	clientId = 3055,
	sell = 2500
}, {
	itemName = "poison dagger",
	clientId = 3299,
	sell = 50
}, {
	itemName = "poison gland",
	clientId = 29348,
	sell = 210
}, {
	itemName = "poison spider shell",
	clientId = 11485,
	sell = 10
}, {
	itemName = "poisoned fang",
	clientId = 21195,
	sell = 130
}, {
	itemName = "poisonous slime",
	clientId = 9640,
	sell = 50
}, {
	itemName = "polar bear paw",
	clientId = 9650,
	sell = 30
}, {
	itemName = "pool of chitinous glue",
	clientId = 20207,
	sell = 480
}, {
	itemName = "porcelain mask",
	clientId = 25088,
	sell = 2000
}, {
	itemName = "powder herb",
	clientId = 3739,
	sell = 10
}, {
	itemName = "power ring",
	clientId = 3050,
	sell = 50
}, {
	itemName = "prehemoth claw",
	clientId = 39383,
	sell = 2300
}, {
	itemName = "prehemoth horns",
	clientId = 39382,
	sell = 3000
}, {
	itemName = "prismatic quartz",
	clientId = 24962,
	sell = 450
}, {
	itemName = "pristine worm head",
	clientId = 27618,
	sell = 15000
}, {
	itemName = "protection amulet",
	clientId = 3084,
	sell = 100,
	count = 250
}, {
	itemName = "protective charm",
	clientId = 11444,
	sell = 60
}, {
	itemName = "pulverized ore",
	clientId = 16133,
	sell = 400
}, {
	itemName = "purified soul",
	clientId = 32228,
	sell = 260
}, {
	itemName = "purple robe",
	clientId = 11473,
	sell = 110
}, {
	itemName = "purple tome",
	clientId = 2848,
	sell = 2000
}, {
	itemName = "quara bone",
	clientId = 11491,
	sell = 500
}, {
	itemName = "quara eye",
	clientId = 11488,
	sell = 350
}, {
	itemName = "quara eye",
	clientId = 11491,
	sell = 350
}, {
	itemName = "quara pincers",
	clientId = 11490,
	sell = 410
}, {
	itemName = "quara tentacle",
	clientId = 11487,
	sell = 140
}, {
	itemName = "queen's sceptre",
	clientId = 7410,
	sell = 20000
}, {
	itemName = "quill",
	clientId = 28567,
	sell = 1100
}, {
	itemName = "rabbit's foot",
	clientId = 12172,
	sell = 50
}, {
	itemName = "ragnir helmet",
	clientId = 7462,
	sell = 400
}, {
	itemName = "rainbow quartz",
	clientId = 25737,
	sell = 800
}, {
	itemName = "rapier",
	clientId = 3272,
	sell = 5
}, {
	itemName = "rare earth",
	clientId = 27301,
	sell = 80
}, {
	itemName = "ratana",
	clientId = 17812,
	sell = 500
}, {
	itemName = "ratmiral's hat",
	clientId = 35613,
	sell = 150000
}, {
	itemName = "ravenous circlet",
	clientId = 32597,
	sell = 220000
}, {
	itemName = "red crystal fragment",
	clientId = 16126,
	sell = 800
}, {
	itemName = "red dragon leather",
	clientId = 5948,
	sell = 200
}, {
	itemName = "red dragon scale",
	clientId = 5882,
	sell = 200
}, {
	itemName = "red gem",
	clientId = 3039,
	sell = 1000
}, {
	itemName = "red goanna scale",
	clientId = 31558,
	sell = 270
}, {
	itemName = "red hair dye",
	clientId = 17855,
	sell = 40
}, {
	itemName = "red lantern",
	clientId = 10289,
	sell = 250
}, {
	itemName = "red piece of cloth",
	clientId = 5911,
	sell = 300
}, {
	itemName = "red tome",
	clientId = 2852,
	sell = 2000
}, {
	itemName = "relic sword",
	clientId = 7383,
	sell = 25000
}, {
	itemName = "rhindeer antler",
	clientId = 40587,
	sell = 680
}, {
	itemName = "rhino hide",
	clientId = 24388,
	sell = 175
}, {
	itemName = "rhino horn carving",
	clientId = 24386,
	sell = 300
}, {
	itemName = "rhino horn",
	clientId = 24389,
	sell = 265
}, {
	itemName = "rift bow",
	clientId = 22866,
	sell = 45000
}, {
	itemName = "rift crossbow",
	clientId = 22867,
	sell = 45000
}, {
	itemName = "rift lance",
	clientId = 22727,
	sell = 30000
}, {
	itemName = "rift shield",
	clientId = 22726,
	sell = 50000
}, {
	itemName = "ring of blue plasma",
	clientId = 23529,
	sell = 8000
}, {
	itemName = "ring of green plasma",
	clientId = 23531,
	sell = 8000
}, {
	itemName = "ring of healing",
	clientId = 3098,
	sell = 100
}, {
	itemName = "ring of red plasma",
	clientId = 23533,
	sell = 8000
}, {
	itemName = "ring of the sky",
	clientId = 3006,
	sell = 30000
}, {
	itemName = "ripptor claw",
	clientId = 39389,
	sell = 2000
}, {
	itemName = "ripptor scales",
	clientId = 39391,
	sell = 1200
}, {
	itemName = "ritual tooth",
	clientId = 40528,
	sell = 135
}, {
	itemName = "rod",
	clientId = 33929,
	sell = 2200
}, {
	itemName = "rogue naga scales",
	clientId = 39416,
	sell = 570
}, {
	itemName = "roots",
	clientId = 33938,
	sell = 1200
}, {
	itemName = "rope belt",
	clientId = 11492,
	sell = 66
}, {
	itemName = "rope",
	clientId = 3003,
	sell = 15
}, {
	itemName = "rorc egg",
	clientId = 18996,
	sell = 120
}, {
	itemName = "rorc feather",
	clientId = 18993,
	sell = 70
}, {
	itemName = "rotten feather",
	clientId = 40527,
	sell = 120
}, {
	itemName = "rotten heart",
	clientId = 31589,
	sell = 74000
}, {
	itemName = "rotten piece of cloth",
	clientId = 10291,
	sell = 30
}, {
	itemName = "royal almandine",
	clientId = 39038,
	sell = 460000
}, {
	itemName = "royal axe",
	clientId = 7434,
	sell = 40000
}, {
	itemName = "royal helmet",
	clientId = 3392,
	sell = 30000
}, {
	itemName = "rubber cap",
	clientId = 21165,
	sell = 11000
}, {
	itemName = "ruby necklace",
	clientId = 3016,
	sell = 2000
}, {
	itemName = "runed sword",
	clientId = 7417,
	sell = 45000
}, {
	itemName = "ruthless axe",
	clientId = 6553,
	sell = 45000
}, {
	itemName = "sabre",
	clientId = 3273,
	sell = 12
}, {
	itemName = "sabretooth fur",
	clientId = 39378,
	sell = 2500
}, {
	itemName = "sabretooth",
	clientId = 10311,
	sell = 400
}, {
	itemName = "sacred tree amulet",
	clientId = 9302,
	sell = 3000
}, {
	itemName = "safety pin",
	clientId = 11493,
	sell = 120
}, {
	itemName = "sai",
	clientId = 10389,
	sell = 16500
}, {
	itemName = "sample of monster blood",
	clientId = 27874,
	sell = 250
}, {
	itemName = "sandcrawler shell",
	clientId = 10456,
	sell = 20
}, {
	itemName = "sapphire hammer",
	clientId = 7437,
	sell = 7000
}, {
	itemName = "scale armor",
	clientId = 3377,
	sell = 75
}, {
	itemName = "scale of corruption",
	clientId = 11673,
	sell = 680
}, {
	itemName = "scale of gelidrazah",
	clientId = 24939,
	sell = 10000
}, {
	itemName = "scarab amulet",
	clientId = 3018,
	sell = 200
}, {
	itemName = "scarab coin",
	clientId = 3042,
	sell = 100
}, {
	itemName = "scarab pincers",
	clientId = 9631,
	sell = 280
}, {
	itemName = "scarab shield",
	clientId = 3440,
	sell = 2000
}, {
	itemName = "scimitar",
	clientId = 3307,
	sell = 150
}, {
	itemName = "scorpion tail",
	clientId = 9651,
	sell = 25
}, {
	itemName = "scroll of heroic deeds",
	clientId = 11510,
	sell = 230
}, {
	itemName = "scythe leg",
	clientId = 10312,
	sell = 450
}, {
	itemName = "scythe",
	clientId = 3453,
	sell = 10
}, {
	itemName = "sea horse figurine",
	clientId = 31323,
	sell = 42000
}, {
	itemName = "sea serpent scale",
	clientId = 9666,
	sell = 520
}, {
	itemName = "sea serpent trophy",
	clientId = 9613,
	sell = 10000
}, {
	itemName = "seacrest hair",
	clientId = 21801,
	sell = 260
}, {
	itemName = "seacrest pearl",
	clientId = 21747,
	sell = 400
}, {
	itemName = "seacrest scale",
	clientId = 21800,
	sell = 150
}, {
	itemName = "second verse of the hymn",
	clientId = 6088,
	sell = 250
}, {
	itemName = "seeds",
	clientId = 647,
	sell = 150
}, {
	itemName = "serpent sword",
	clientId = 3297,
	sell = 900
}, {
	itemName = "shadow herb",
	clientId = 3740,
	sell = 20
}, {
	itemName = "shadow sceptre",
	clientId = 7451,
	sell = 10000
}, {
	itemName = "shaggy tail",
	clientId = 10407,
	sell = 25
}, {
	itemName = "shamanic hood",
	clientId = 11478,
	sell = 45
}, {
	itemName = "shamanic talisman",
	clientId = 22184,
	sell = 200
}, {
	itemName = "shark fins",
	clientId = 35574,
	sell = 250
}, {
	itemName = "shimmering beatles",
	clientId = 25693,
	sell = 150
}, {
	itemName = "shimmering beetles",
	clientId = 25686,
	sell = 150
}, {
	itemName = "shiny stone",
	clientId = 10310,
	sell = 500
}, {
	itemName = "shockwave amulet",
	clientId = 9304,
	sell = 3000
}, {
	itemName = "short sword",
	clientId = 3294,
	sell = 10
}, {
	itemName = "shovel",
	clientId = 3457,
	sell = 8
}, {
	itemName = "sickle",
	clientId = 3293,
	sell = 3
}, {
	itemName = "sight of surrender's eye",
	clientId = 20183,
	sell = 3000
}, {
	itemName = "signet ring",
	clientId = 31592,
	sell = 480000
}, {
	itemName = "silencer claws",
	clientId = 20200,
	sell = 390
}, {
	itemName = "silencer resonating chamber",
	clientId = 20201,
	sell = 600
}, {
	itemName = "silken bookmark",
	clientId = 28566,
	sell = 1300
}, {
	itemName = "silkweaver bow",
	clientId = 8029,
	sell = 12000
}, {
	itemName = "silky fur",
	clientId = 10292,
	sell = 35
}, {
	itemName = "silver amulet",
	clientId = 3054,
	sell = 50,
	count = 200
}, {
	itemName = "silver brooch",
	clientId = 3017,
	sell = 150
}, {
	itemName = "silver dagger",
	clientId = 3290,
	sell = 500
}, {
	itemName = "silver fafnar trophy",
	clientId = 9627,
	sell = 1000
}, {
	itemName = "silver hand mirror",
	clientId = 32772,
	sell = 10000
}, {
	itemName = "silver rune emblem explosion",
	clientId = 11607,
	sell = 5000
}, {
	itemName = "silver rune emblem heavy magic missile",
	clientId = 11605,
	sell = 5000
}, {
	itemName = "silver rune emblem sudden death",
	clientId = 11609,
	sell = 5000
}, {
	itemName = "silver rune emblem ultimate healing",
	clientId = 11603,
	sell = 5000
}, {
	itemName = "single human eye",
	clientId = 25696,
	sell = 1000
}, {
	itemName = "single human eye",
	clientId = 25701,
	sell = 1000
}, {
	itemName = "skeleton decoration",
	clientId = 6525,
	sell = 3000
}, {
	itemName = "skull belt",
	clientId = 11480,
	sell = 80
}, {
	itemName = "skull coin",
	clientId = 32583,
	sell = 12000
}, {
	itemName = "skull fetish",
	clientId = 22191,
	sell = 250
}, {
	itemName = "skull helmet",
	clientId = 5741,
	sell = 40000
}, {
	itemName = "skull shatterer",
	clientId = 17849,
	sell = 170
}, {
	itemName = "skull staff",
	clientId = 3324,
	sell = 6000
}, {
	itemName = "skullcracker armor",
	clientId = 8061,
	sell = 18000
}, {
	itemName = "skunk tail",
	clientId = 10274,
	sell = 50
}, {
	itemName = "slime heart",
	clientId = 21194,
	sell = 160
}, {
	itemName = "slimy leaf tentacle",
	clientId = 21197,
	sell = 320
}, {
	itemName = "slimy leg",
	clientId = 27623,
	sell = 4500
}, {
	itemName = "sling herb",
	clientId = 3738,
	sell = 10
}, {
	itemName = "small amethyst",
	clientId = 3033,
	sell = 200
}, {
	itemName = "small axe",
	clientId = 3462,
	sell = 5
}, {
	itemName = "small diamond",
	clientId = 3028,
	sell = 300
}, {
	itemName = "small emerald",
	clientId = 3032,
	sell = 250
}, {
	itemName = "small enchanted amethyst",
	clientId = 678,
	sell = 200
}, {
	itemName = "small enchanted emerald",
	clientId = 677,
	sell = 250
}, {
	itemName = "small enchanted ruby",
	clientId = 676,
	sell = 250
}, {
	itemName = "small enchanted sapphire",
	clientId = 675,
	sell = 250
}, {
	itemName = "small energy ball",
	clientId = 23524,
	sell = 250
}, {
	itemName = "small flask of eyedrops",
	clientId = 11512,
	sell = 95
}, {
	itemName = "small notebook",
	clientId = 11450,
	sell = 480
}, {
	itemName = "small oil lamp",
	clientId = 2933,
	sell = 150
}, {
	itemName = "small pitchfork",
	clientId = 11513,
	sell = 70
}, {
	itemName = "small ruby",
	clientId = 3030,
	sell = 250
}, {
	itemName = "small sapphire",
	clientId = 3029,
	sell = 250
}, {
	itemName = "small topaz",
	clientId = 9057,
	sell = 200
}, {
	itemName = "small treasure chest",
	clientId = 35571,
	sell = 500
}, {
	itemName = "small tropical fish",
	clientId = 39408,
	sell = 380
}, {
	itemName = "smoldering eye",
	clientId = 39543,
	sell = 470000
}, {
	itemName = "snake skin",
	clientId = 9694,
	sell = 400
}, {
	itemName = "snakebite rod",
	clientId = 3066,
	sell = 100
}, {
	itemName = "sniper gloves",
	clientId = 5875,
	sell = 2000
}, {
	itemName = "soldier helmet",
	clientId = 3375,
	sell = 16
}, {
	itemName = "solid rage",
	clientId = 23517,
	sell = 310
}, {
	itemName = "some grimeleech wings",
	clientId = 22730,
	sell = 1200
}, {
	itemName = "soul stone",
	clientId = 5809,
	sell = 6000
}, {
	itemName = "souleater trophy",
	clientId = 11679,
	sell = 7500
}, {
	itemName = "sparkion claw",
	clientId = 23502,
	sell = 290
}, {
	itemName = "sparkion legs",
	clientId = 23504,
	sell = 310
}, {
	itemName = "sparkion stings",
	clientId = 23505,
	sell = 280
}, {
	itemName = "sparkion tail",
	clientId = 23503,
	sell = 300
}, {
	itemName = "spectral gold nugget",
	clientId = 32724,
	sell = 500
}, {
	itemName = "spectral silver nugget",
	clientId = 32725,
	sell = 250
}, {
	itemName = "spectral stone",
	clientId = 4840,
	sell = 50
}, {
	itemName = "spellbook of enlightenment",
	clientId = 8072,
	sell = 4000
}, {
	itemName = "spellbook of lost souls",
	clientId = 8075,
	sell = 19000
}, {
	itemName = "spellbook of mind control",
	clientId = 8074,
	sell = 13000
}, {
	itemName = "spellbook of warding",
	clientId = 8073,
	sell = 8000
}, {
	itemName = "spellsinger's seal",
	clientId = 14008,
	sell = 280
}, {
	itemName = "spellwand",
	clientId = 651,
	sell = 299
}, {
	itemName = "spellweaver's robe",
	clientId = 10438,
	sell = 12000
}, {
	itemName = "sphinx feather",
	clientId = 31437,
	sell = 470
}, {
	itemName = "sphinx tiara",
	clientId = 31438,
	sell = 360
}, {
	itemName = "spider fangs",
	clientId = 8031,
	sell = 10
}, {
	itemName = "spider silk",
	clientId = 5879,
	sell = 100
}, {
	itemName = "spidris mandible",
	clientId = 14082,
	sell = 450
}, {
	itemName = "spike shield",
	clientId = 17810,
	sell = 250
}, {
	itemName = "spike sword",
	clientId = 3271,
	sell = 1000
}, {
	itemName = "spiked iron ball",
	clientId = 10408,
	sell = 100
}, {
	itemName = "spiked squelcher",
	clientId = 7452,
	sell = 5000
}, {
	itemName = "spiky club",
	clientId = 17859,
	sell = 300
}, {
	itemName = "spirit cloak",
	clientId = 8042,
	sell = 350
}, {
	itemName = "spirit container",
	clientId = 5884,
	sell = 40000
}, {
	itemName = "spite's spirit",
	clientId = 33926,
	sell = 840000
}, {
	itemName = "spitter nose",
	clientId = 14078,
	sell = 340
}, {
	itemName = "spooky blue eye",
	clientId = 9642,
	sell = 95
}, {
	itemName = "springsprout rod",
	clientId = 8084,
	sell = 3600
}, {
	itemName = "srezz' eye",
	clientId = 34103,
	sell = 300
}, {
	itemName = "stalking seeds",
	clientId = 39384,
	sell = 1800
}, {
	itemName = "stampor horn",
	clientId = 12312,
	sell = 280
}, {
	itemName = "stampor talons",
	clientId = 12313,
	sell = 150
}, {
	itemName = "star amulet",
	clientId = 3014,
	sell = 500
}, {
	itemName = "star herb",
	clientId = 3736,
	sell = 15
}, {
	itemName = "statue of abyssador",
	clientId = 16232,
	sell = 4000
}, {
	itemName = "statue of deathstrike",
	clientId = 16236,
	sell = 3000
}, {
	itemName = "statue of devovorga",
	clientId = 4065,
	sell = 1500
}, {
	itemName = "statue of gnomevil",
	clientId = 16240,
	sell = 2000
}, {
	itemName = "stealth ring",
	clientId = 3049,
	sell = 200
}, {
	itemName = "steel boots",
	clientId = 3554,
	sell = 30000
}, {
	itemName = "steel helmet",
	clientId = 3351,
	sell = 293
}, {
	itemName = "steel shield",
	clientId = 3409,
	sell = 80
}, {
	itemName = "stone herb",
	clientId = 3735,
	sell = 20
}, {
	itemName = "stone nose",
	clientId = 16137,
	sell = 590
}, {
	itemName = "stone skin amulet",
	clientId = 3081,
	sell = 500,
	count = 5
}, {
	itemName = "stone wing",
	clientId = 10278,
	sell = 120
}, {
	itemName = "stonerefiner's skull",
	clientId = 27606,
	sell = 100
}, {
	itemName = "strand of medusa hair",
	clientId = 10309,
	sell = 600
}, {
	itemName = "strange helmet",
	clientId = 3373,
	sell = 500
}, {
	itemName = "strange proto matter",
	clientId = 23513,
	sell = 300
}, {
	itemName = "strange symbol",
	clientId = 3058,
	sell = 200
}, {
	itemName = "strange talisman",
	clientId = 3045,
	sell = 30,
	count = 200
}, {
	itemName = "striped fur",
	clientId = 10293,
	sell = 50
}, {
	itemName = "studded armor",
	clientId = 3378,
	sell = 25
}, {
	itemName = "studded club",
	clientId = 3336,
	sell = 10
}, {
	itemName = "studded helmet",
	clientId = 3376,
	sell = 20
}, {
	itemName = "studded legs",
	clientId = 3362,
	sell = 15
}, {
	itemName = "studded shield",
	clientId = 3426,
	sell = 16
}, {
	itemName = "stuffed dragon",
	clientId = 5791,
	sell = 6000
}, {
	itemName = "sulphider shell",
	clientId = 39375,
	sell = 2200
}, {
	itemName = "sulphur powder",
	clientId = 39376,
	sell = 1900
}, {
	itemName = "sulphurous stone",
	clientId = 10315,
	sell = 100
}, {
	itemName = "summer dress",
	clientId = 8046,
	sell = 1500
}, {
	itemName = "swamp grass",
	clientId = 9686,
	sell = 20
}, {
	itemName = "swamplair armor",
	clientId = 8052,
	sell = 16000
}, {
	itemName = "swampling club",
	clientId = 17824,
	sell = 40
}, {
	itemName = "swampling moss",
	clientId = 17822,
	sell = 20
}, {
	itemName = "swarmer antenna",
	clientId = 14076,
	sell = 130
}, {
	itemName = "sword ring",
	clientId = 3091,
	sell = 100
}, {
	itemName = "sword",
	clientId = 3264,
	sell = 25
}, {
	itemName = "tail of corruption",
	clientId = 11672,
	sell = 240
}, {
	itemName = "talon",
	clientId = 3034,
	sell = 320
}, {
	itemName = "tarantula egg",
	clientId = 10281,
	sell = 80
}, {
	itemName = "tarnished rhino figurine",
	clientId = 24387,
	sell = 320
}, {
	itemName = "tattered piece of robe",
	clientId = 9684,
	sell = 120
}, {
	itemName = "taurus mace",
	clientId = 7425,
	sell = 500
}, {
	itemName = "telescope eye",
	clientId = 33934,
	sell = 1600
}, {
	itemName = "tempest shield",
	clientId = 3442,
	sell = 35000
}, {
	itemName = "tentacle of tentugly",
	clientId = 35611,
	sell = 27000
}, {
	itemName = "tentacle piece",
	clientId = 11666,
	sell = 5000
}, {
	itemName = "tentugly's eye",
	clientId = 35610,
	sell = 52000
}, {
	itemName = "tentugly's jaws",
	clientId = 35612,
	sell = 80000
}, {
	itemName = "terra amulet",
	clientId = 814,
	sell = 1500
}, {
	itemName = "terra boots",
	clientId = 813,
	sell = 2500
}, {
	itemName = "terra hood",
	clientId = 830,
	sell = 2500
}, {
	itemName = "terra legs",
	clientId = 812,
	sell = 11000
}, {
	itemName = "terra mantle",
	clientId = 811,
	sell = 11000
}, {
	itemName = "terra rod",
	clientId = 3065,
	sell = 2000
}, {
	itemName = "terramite eggs",
	clientId = 10453,
	sell = 50
}, {
	itemName = "terramite legs",
	clientId = 10454,
	sell = 60
}, {
	itemName = "terramite shell",
	clientId = 10452,
	sell = 170
}, {
	itemName = "terrorbird beak",
	clientId = 10273,
	sell = 95
}, {
	itemName = "thaian sword",
	clientId = 7391,
	sell = 16000
}, {
	itemName = "the avenger",
	clientId = 6527,
	sell = 42000
}, {
	itemName = "the handmaiden's protector",
	clientId = 6539,
	sell = 50000
}, {
	itemName = "the imperor's trident",
	clientId = 6534,
	sell = 50000
}, {
	itemName = "the ironworker",
	clientId = 8025,
	sell = 50000
}, {
	itemName = "the justice seeker",
	clientId = 7390,
	sell = 40000
}, {
	itemName = "the plasmother's remains",
	clientId = 6535,
	sell = 50000
}, {
	itemName = "thick fur",
	clientId = 10307,
	sell = 150
}, {
	itemName = "third verse of the hymn",
	clientId = 6089,
	sell = 400
}, {
	itemName = "thorn",
	clientId = 9643,
	sell = 100
}, {
	itemName = "throwing knife",
	clientId = 3298,
	sell = 2
}, {
	itemName = "tiara",
	clientId = 35578,
	sell = 11000
}, {
	itemName = "tiger eye",
	clientId = 24961,
	sell = 350
}, {
	itemName = "time ring",
	clientId = 3053,
	sell = 100
}, {
	itemName = "titan axe",
	clientId = 7413,
	sell = 4000
}, {
	itemName = "token of love",
	clientId = 31594,
	sell = 440000
}, {
	itemName = "tooth file",
	clientId = 18924,
	sell = 60
}, {
	itemName = "tooth of tazhadur",
	clientId = 24940,
	sell = 10000
}, {
	itemName = "torn shirt",
	clientId = 25744,
	sell = 250
}, {
	itemName = "tortoise shield",
	clientId = 6131,
	sell = 150
}, {
	itemName = "tower shield",
	clientId = 3428,
	sell = 8000
}, {
	itemName = "trapped bad dream monster",
	clientId = 20203,
	sell = 900
}, {
	itemName = "tribal mask",
	clientId = 3403,
	sell = 250
}, {
	itemName = "troll green",
	clientId = 3741,
	sell = 25
}, {
	itemName = "trollroot",
	clientId = 11515,
	sell = 50
}, {
	itemName = "trophy of jaul",
	clientId = 14006,
	sell = 4000
}, {
	itemName = "trophy of obujos",
	clientId = 14002,
	sell = 3000
}, {
	itemName = "trophy of tanjis",
	clientId = 14004,
	sell = 2000
}, {
	itemName = "tunnel tyrant head",
	clientId = 27595,
	sell = 500
}, {
	itemName = "tunnel tyrant shell",
	clientId = 27596,
	sell = 700
}, {
	itemName = "turtle shell",
	clientId = 5899,
	sell = 90
}, {
	itemName = "tusk",
	clientId = 3044,
	sell = 100
}, {
	itemName = "twiceslicer",
	clientId = 11657,
	sell = 28000
}, {
	itemName = "twin hooks",
	clientId = 10392,
	sell = 500
}, {
	itemName = "two handed sword",
	clientId = 3265,
	sell = 450
}, {
	itemName = "two-headed turtle heads",
	clientId = 39409,
	sell = 460
}, {
	itemName = "undead heart",
	clientId = 10450,
	sell = 200
}, {
	itemName = "undertaker fangs",
	clientId = 39380,
	sell = 2700
}, {
	itemName = "underworld rod",
	clientId = 8082,
	sell = 4400
}, {
	itemName = "unholy bone",
	clientId = 10316,
	sell = 480
}, {
	itemName = "unholy book",
	clientId = 6103,
	sell = 30000
}, {
	itemName = "unicorn figurine",
	clientId = 30054,
	sell = 50000
}, {
	itemName = "urmahlullus mane",
	clientId = 31623,
	sell = 490000
}, {
	itemName = "urmahlullus paws",
	clientId = 31624,
	sell = 245000
}, {
	itemName = "urmahlullus tail",
	clientId = 31622,
	sell = 210000
}, {
	itemName = "utua's poison",
	clientId = 34101,
	sell = 230
}, {
	itemName = "vampire dust",
	clientId = 5905,
	sell = 100
}, {
	itemName = "vampire shield",
	clientId = 3434,
	sell = 15000
}, {
	itemName = "vampire teeth",
	clientId = 9685,
	sell = 275
}, {
	itemName = "vampire's cape chain",
	clientId = 18927,
	sell = 150
}, {
	itemName = "veal",
	clientId = 32009,
	sell = 40
}, {
	itemName = "vein of ore",
	clientId = 16135,
	sell = 330
}, {
	itemName = "venison",
	clientId = 18995,
	sell = 55
}, {
	itemName = "vexclaw talon",
	clientId = 22728,
	sell = 1100
}, {
	itemName = "vial of hatred",
	clientId = 33927,
	sell = 737000
}, {
	itemName = "vial",
	clientId = 2874,
	sell = 5
}, {
	itemName = "vibrant heart",
	clientId = 34143,
	sell = 2100
}, {
	itemName = "vibrant robe",
	clientId = 34144,
	sell = 1200
}, {
	itemName = "viking helmet",
	clientId = 3367,
	sell = 66
}, {
	itemName = "viking shield",
	clientId = 3431,
	sell = 85
}, {
	itemName = "vile axe",
	clientId = 7388,
	sell = 30000
}, {
	itemName = "violet crystal shard",
	clientId = 16120,
	sell = 1500
}, {
	itemName = "violet gem",
	clientId = 3036,
	sell = 10000
}, {
	itemName = "violet glass plate",
	clientId = 29347,
	sell = 2150
}, {
	itemName = "volatile proto matter",
	clientId = 23514,
	sell = 300
}, {
	itemName = "voodoo doll",
	clientId = 3002,
	sell = 400
}, {
	itemName = "wailing widow's necklace",
	clientId = 10412,
	sell = 3000
}, {
	itemName = "wand of cosmic energy",
	clientId = 3073,
	sell = 2000
}, {
	itemName = "wand of decay",
	clientId = 3072,
	sell = 1000
}, {
	itemName = "wand of defiance",
	clientId = 16096,
	sell = 6500
}, {
	itemName = "wand of draconia",
	clientId = 8093,
	sell = 1500
}, {
	itemName = "wand of dragonbreath",
	clientId = 3075,
	sell = 200
}, {
	itemName = "wand of everblazing",
	clientId = 16115,
	sell = 6000
}, {
	itemName = "wand of inferno",
	clientId = 3071,
	sell = 3000
}, {
	itemName = "wand of starstorm",
	clientId = 8092,
	sell = 3600
}, {
	itemName = "wand of voodoo",
	clientId = 8094,
	sell = 4400
}, {
	itemName = "wand of vortex",
	clientId = 3074,
	sell = 100
}, {
	itemName = "war axe",
	clientId = 3342,
	sell = 12000
}, {
	itemName = "war crystal",
	clientId = 9654,
	sell = 460
}, {
	itemName = "war hammer",
	clientId = 3279,
	sell = 1200
}, {
	itemName = "war horn",
	clientId = 2958,
	sell = 8000
}, {
	itemName = "warmaster's wristguards",
	clientId = 10405,
	sell = 200
}, {
	itemName = "warrior helmet",
	clientId = 3369,
	sell = 5000
}, {
	itemName = "warrior's axe",
	clientId = 14040,
	sell = 11000
}, {
	itemName = "warrior's shield",
	clientId = 14042,
	sell = 9000
}, {
	itemName = "warwolf fur",
	clientId = 10318,
	sell = 30
}, {
	itemName = "waspoid claw",
	clientId = 14080,
	sell = 320
}, {
	itemName = "waspoid wing",
	clientId = 14081,
	sell = 190
}, {
	itemName = "watch",
	clientId = 2906,
	sell = 6
}, {
	itemName = "watermelon tourmaline (slice)",
	clientId = 33779,
	sell = 30000
}, {
	itemName = "watermelon tourmaline",
	clientId = 33780,
	sell = 230000
}, {
	itemName = "weaver's wandtip",
	clientId = 10397,
	sell = 250
}, {
	itemName = "wedding ring",
	clientId = 3004,
	sell = 100
}, {
	itemName = "werebadger claws",
	clientId = 22051,
	sell = 160
}, {
	itemName = "werebadger skull",
	clientId = 22055,
	sell = 185
}, {
	itemName = "werebadger trophy",
	clientId = 22101,
	sell = 9000
}, {
	itemName = "werebear fur",
	clientId = 22057,
	sell = 185
}, {
	itemName = "werebear skull",
	clientId = 22056,
	sell = 195
}, {
	itemName = "werebear trophy",
	clientId = 22103,
	sell = 11000
}, {
	itemName = "wereboar hooves",
	clientId = 22053,
	sell = 175
}, {
	itemName = "wereboar loincloth",
	clientId = 22087,
	sell = 1500
}, {
	itemName = "wereboar trophy",
	clientId = 22102,
	sell = 10000
}, {
	itemName = "wereboar tusk",
	clientId = 22054,
	sell = 165
}, {
	itemName = "werefox tail",
	clientId = 27463,
	sell = 200
}, {
	itemName = "werefox trophy",
	clientId = 27706,
	sell = 9000
}, {
	itemName = "werehyaena nose",
	clientId = 33943,
	sell = 220
}, {
	itemName = "werehyaena talisman",
	clientId = 33944,
	sell = 350
}, {
	itemName = "werehyaena trophy",
	clientId = 34219,
	sell = 12000
}, {
	itemName = "werewolf amulet",
	clientId = 22060,
	sell = 3000
}, {
	itemName = "werewolf fangs",
	clientId = 22052,
	sell = 180
}, {
	itemName = "werewolf fur",
	clientId = 10317,
	sell = 380
}, {
	itemName = "white gem",
	clientId = 32769,
	sell = 12000
}, {
	itemName = "white pearl",
	clientId = 3026,
	sell = 160
}, {
	itemName = "white piece of cloth",
	clientId = 5909,
	sell = 100
}, {
	itemName = "white silk flower",
	clientId = 34008,
	sell = 9000
}, {
	itemName = "widow's mandibles",
	clientId = 10411,
	sell = 110
}, {
	itemName = "wild flowers",
	clientId = 25691,
	sell = 120
}, {
	itemName = "wimp tooth chain",
	clientId = 17847,
	sell = 120
}, {
	itemName = "windborn colossus armor",
	clientId = 8055,
	sell = 50000
}, {
	itemName = "winged tail",
	clientId = 10313,
	sell = 800
}, {
	itemName = "winter wolf fur",
	clientId = 10295,
	sell = 20
}, {
	itemName = "witch broom",
	clientId = 9652,
	sell = 60
}, {
	itemName = "witch hat",
	clientId = 9653,
	sell = 5000
}, {
	itemName = "withered pauldrons",
	clientId = 27607,
	sell = 850
}, {
	itemName = "withered scalp",
	clientId = 27608,
	sell = 900
}, {
	itemName = "wolf paw",
	clientId = 5897,
	sell = 70
}, {
	itemName = "wolf trophy",
	clientId = 7394,
	sell = 3000
}, {
	itemName = "wood cape",
	clientId = 3575,
	sell = 5000
}, {
	itemName = "wood mushroom",
	clientId = 3727,
	sell = 15
}, {
	itemName = "wood",
	clientId = 5901,
	sell = 5
}, {
	itemName = "wooden hammer",
	clientId = 3459,
	sell = 15
}, {
	itemName = "wooden shield",
	clientId = 3412,
	sell = 5
}, {
	itemName = "wooden spellbook",
	clientId = 25699,
	sell = 12000
}, {
	itemName = "wool",
	clientId = 10319,
	sell = 15
}, {
	itemName = "writhing brain",
	clientId = 32600,
	sell = 370000
}, {
	itemName = "writhing heart",
	clientId = 32599,
	sell = 185000
}, {
	itemName = "wyrm scale",
	clientId = 9665,
	sell = 400
}, {
	itemName = "wyvern fang",
	clientId = 7408,
	sell = 1500
}, {
	itemName = "wyvern talisman",
	clientId = 9644,
	sell = 265
}, {
	itemName = "yellow gem",
	clientId = 3037,
	sell = 1000
}, {
	itemName = "yellow piece of cloth",
	clientId = 5914,
	sell = 150
}, {
	itemName = "yielowax",
	clientId = 12742,
	sell = 600
}, {
	itemName = "yirkas' egg",
	clientId = 34102,
	sell = 280
}, {
	itemName = "young lich worm",
	clientId = 31590,
	sell = 25000
}, {
	itemName = "zaoan armor",
	clientId = 10384,
	sell = 14000
}, {
	itemName = "zaoan halberd",
	clientId = 10406,
	sell = 500
}, {
	itemName = "zaoan helmet",
	clientId = 10385,
	sell = 45000
}, {
	itemName = "zaoan legs",
	clientId = 10387,
	sell = 14000
}, {
	itemName = "zaoan robe",
	clientId = 10439,
	sell = 12000
}, {
	itemName = "zaoan shoes",
	clientId = 10386,
	sell = 5000
}, {
	itemName = "zaoan sword",
	clientId = 10390,
	sell = 30000
}, {
	itemName = "zaogun flag",
	clientId = 10413,
	sell = 600
}, {
	itemName = "zaogun's shoulderplates",
	clientId = 10414,
	sell = 150
}, {
	itemName = "all loot in pouch",
	clientId = ITEM_GOLD_POUCH,
	sell = 1
} }

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
