local voices = {
	[23708] = "Au au!",
	[23443] = "Grooaarr!"
}

local transformItems = {
	[2062] = 2063,
	[2063] = 2062, -- sacred statue
	[2064] = 2065,
	[2065] = 2064, -- sacred statue
	[2108] = 2109,
	[2109] = 2108, -- street lamp
	[2334] = 2335,
	[2335] = 2334, -- table
	[2336] = 2337,
	[2337] = 2336, -- table
	[2338] = 2339,
	[2339] = 2338, -- table
	[2340] = 2341,
	[2341] = 2340, -- table
	[2535] = 2536,
	[2536] = 2535, -- oven
	[2537] = 2538,
	[2538] = 2537, -- oven
	[2539] = 2540,
	[2540] = 2539, -- oven
	[2541] = 2542,
	[2542] = 2541, -- oven
	[2660] = 2661,
	[2661] = 2660, -- cuckoo clock
	[2662] = 2663,
	[2663] = 2662, -- cuckoo clock
	[2772] = 2773,
	[2773] = 2772, -- lever
	[2907] = 2908,
	[2908] = 2907, -- wall lamp
	[2909] = 2910,
	[2910] = 2909, -- wall lamp
	[2911] = 2912,
	[2912] = 2911, -- candelabrum
	[2914] = 2915,
	[2915] = 2914, -- lamp
	[2917] = 2918,
	[2918] = 2917, -- candlestick
	[2920] = 2921,
	[2921] = 2920, -- torch
	[2922] = 2923,
	[2923] = 2922, -- torch
	[2924] = 2925,
	[2925] = 2924, -- torch
	[2928] = 2929,
	[2929] = 2928, -- torch bearer
	[2930] = 2931,
	[2931] = 2930, -- torch bearer
	[2934] = 2935,
	[2935] = 2934, -- table lamp
	[2936] = 2937,
	[2937] = 2936, -- wall lamp
	[2938] = 2939,
	[2939] = 2938, -- wall lamp
	[2944] = 2945,
	[2945] = 2944, -- wall lamp
	[2977] = 2978,
	[2978] = 2977, -- pumpkinhead
	[3046] = 3047,
	[3047] = 3046, -- magic light wand
	[3481] = 3482, -- closed trap
	[5812] = 5813,
	[5813] = 5812, -- skull candle
	[6488] = 6489,
	[6489] = 6488, -- christmas branch
	[7058] = 7059,
	[7059] = 7058, -- skull pillar
	[7856] = 7857,
	[7857] = 7856, -- chimney
	[7858] = 7859,
	[7859] = 7858, -- chimney
	[7860] = 7861,
	[7861] = 7860, -- chimney
	[7862] = 7863,
	[7863] = 7862, -- chimney
	[8659] = 8660,
	[8660] = 8659, -- street lamp
	[8661] = 8662,
	[8662] = 8661, -- street lamp
	[8663] = 8664,
	[8664] = 8663, -- street lamp
	[8665] = 8666,
	[8666] = 8665, -- street lamp
	[8832] = 8833,
	[8833] = 8832, -- wall lamp
	[8834] = 8835,
	[8835] = 8834, -- wall lamp
	[17411] = 17412,
	[17412] = 17411, -- street lamp
	[20280] = 20281,
	[20281] = 20280, -- beacon
	[20498] = 20497,
	[20497] = 20498, -- street lamp
	[20500] = 20499,
	[20499] = 20500, -- street lamp
	[20501] = 20502,
	[20502] = 20501, -- candle
	[20503] = 20504,
	[20504] = 20503, -- candle
	[22153] = 22154,
	[22154] = 22153, -- skull
	[22764] = 22765,
	[22765] = 22764, -- ferumbras staff
	[23434] = 23436,
	[23436] = 23434, -- predador lamp
	[23435] = 23437,
	[23437] = 23435, -- predador lamp
	[23438] = 23440,
	[23440] = 23438, -- protectress lamp
	[23439] = 23441,
	[23441] = 23439, -- protectress lamp
	[23442] = 23443,
	[23443] = 23442, -- baby dragon
	[23444] = 23445,
	[23445] = 23444, -- hamster wheel
	[23451] = 23452,
	[23452] = 23451, -- cat in a basket
	[23485] = 23486,
	[23486] = 23485, -- barrel
	[23708] = 23709,
	[23709] = 23708, -- dog house
	[24432] = 24433,
	[24433] = 24432, -- parrot
	[24434] = 24436,
	[24435] = 24434, -- skull lamp
	[25212] = 25210,
	[25211] = 25212, -- vengothic lamp
	[26078] = 26079, -- spider terrarium
	[26081] = 26083,
	[26083] = 26081, -- hrodmiran weapons rack
	[26084] = 26082,
	[26082] = 26084, -- hrodmiran weapons rack side
	[26171] = 26169,
	[26172] = 26170, -- snake terrarium
	[26173] = 26175,
	[26174] = 26176, -- demon pet
	[27667] = 27668, -- light of change empty to red
	[27668] = 27669, -- light of change red to green
	[27669] = 27670, -- light of change green to blue
	[27670] = 27667, -- light of change blue to empty
	[27671] = 27673, -- torch of change empty to red
	[27673] = 27674, -- torch of change red to green
	[27674] = 27675, -- torch of change green to blue
	[27675] = 27671, -- torch of change blue to empty
	[27683] = 27685,
	[27684] = 27686, -- alchemistic scales
	[27687] = 27688,
	[27688] = 27687, -- pile of alchemistic books
	[27691] = 27692,
	[27692] = 27691, -- ferumbras bust
	[27693] = 27694,
	[27694] = 27693, -- ferumbras bust
	[27986] = 27988,
	[27988] = 27986, -- bonelord statue
	[27987] = 27989,
	[27989] = 27987, -- bonelord statue
	[27996] = 27998,
	[27998] = 27996, -- scholar bust
	[27997] = 27999,
	[27999] = 27997, -- scholar bust
	[28000] = 28002,
	[28002] = 28000, -- scholar bust
	[28001] = 28003,
	[28003] = 28001, -- scholar bust
	[28674] = 28675,
	[28675] = 28674, -- anglerfish lamp
	[28690] = 28691,
	[28692] = 28693, -- baby rotworm
	[28694] = 28695, --fennec
	[28915] = 28916,
	[28917] = 28918, -- adamant shield
	[28920] = 28921,
	[28921] = 28920, -- fluorescent fungi
	[28922] = 28923,
	[28923] = 28922, -- luminescent fungi
	[28924] = 28925,
	[28925] = 28924, -- glowing sulphur fungi
	[28926] = 28927,
	[28927] = 28926, -- gloomy poisonous fungi
	[30229] = 30230,
	[30230] = 30231, -- festive table
	[30231] = 30229, -- festive table
	[30233] = 30234,
	[30234] = 30233, -- festive fireplace
	[30235] = 30236,
	[30236] = 30235, -- festive fireplace
	[30237] = 30238,
	[30238] = 30237, -- festive tree
	[30248] = 30249,
	[30249] = 30248, -- festive pyramid
	[30362] = 30365, -- Badbara
	[30363] = 30366, -- Tearesa
	[30364] = 30367, -- Cryana
	[31196] = 31197,
	[31197] = 31196, -- crystal lamp
	[31213] = 31215,
	[31215] = 31213, -- idol lamp
	[31214] = 31216,
	[31216] = 31214, -- idol lamp side
	[31462] = 31463,
	[31464] = 31465, -- jousting eagle baby
	[31674] = 31675, -- omniscient owl
	[31681] = 31682, -- hedgehog
	[31683] = 31684,
	[31684] = 31683, -- exalted sarcophagus
	[31695] = 31696,
	[31696] = 31695, -- curly hortensis lamp
	[31697] = 31698,
	[31698] = 31697, -- little big flower lamp
	[31703] = 31704, -- baby unicorn
	[32760] = 32758,
	[32761] = 32759, -- mini NaBbot
	[32784] = 32785,
	[32785] = 32784, -- ice chandelier
	[32788] = 32789, -- baby seal
	[32790] = 32791,
	[32792] = 32793, -- baby polar bear
	[32897] = 32899,
	[32899] = 32897, -- wall lamp
	[32900] = 32901,
	[32901] = 32900, -- torch bearer
	[32902] = 32903,
	[32903] = 32902, -- bamboo wall lamp
	[32904] = 32905,
	[32905] = 32904, -- wall candle
	[32907] = 32910, -- guzzlemaw grub
	[32908] = 32911, -- baby vulcongra
	[32909] = 32912, -- baby brain squid
	[33026] = 33047,
	[33027] = 33026, -- heart lamp
	[33028] = 33048,
	[33029] = 33028, -- heart lamp (flower)
	[33030] = 33049,
	[33031] = 33030, -- heart lamp (small flower)
	[33040] = 33042, -- bat
	[33331] = 33332,
	[33333] = 33334, -- bard doll
	[34026] = 34027, -- baby bonelord
	[34030] = 34031,
	[34031] = 34030, -- artist shelf
	[34032] = 34033,
	[34033] = 34032, -- artist shelf
	[34034] = 34035,
	[34035] = 34034, -- artist table
	[34044] = 34045,
	[34045] = 34044, -- sculptor shelf
	[34046] = 34047,
	[34047] = 34046, -- sculptor shelf
	[34048] = 34049,
	[34049] = 34048, -- sculptor table
	[34064] = 34065,
	[34065] = 34066, -- sculpture of a noblewoman
	[34066] = 34067,
	[34067] = 34064, -- sculpture of a noblewoman
	[34068] = 34069,
	[34069] = 34070, -- sculpture of a noblewoman
	[34070] = 34071,
	[34071] = 34068, -- sculpture of a noblewoman
	[34264] = 34265,
	[34266] = 34267, -- Tibiapedia
	[34268] = 34269,
	[34269] = 34268, -- Baby Munster
	[34270] = 34271,
	[34271] = 34270, -- glowworms
	[34272] = 34273,
	[34273] = 34272, -- oven
	[34274] = 34275,
	[34275] = 34274, -- oven
	[34284] = 34285,
	[34285] = 34284, -- kitchen table (empty)
	[34287] = 34288,
	[34288] = 34287, -- kitchen table (empty)
	[34286] = 34290,
	[34290] = 34286, -- kitchen table
	[34289] = 34291,
	[34291] = 34289, -- kitchen table
	[34300] = 34301,
	[34301] = 34300, -- barrel
	[34304] = 34305,
	[34305] = 34304, -- kitchen lamp
	[34326] = 34327, -- wicked witch
	[35153] = 35154, -- baby elephant
	[35155] = 35157,
	[35157] = 35159, -- forge
	[35159] = 35155,
	[35156] = 35158, -- forge
	[35158] = 35160,
	[35160] = 35156, -- forge
	[35161] = 35162,
	[35162] = 35161, -- metal wall lamp
	[35163] = 35165,
	[35165] = 35163, -- workbench
	[35164] = 35166,
	[35166] = 35164, -- workbench
	[35177] = 35180,
	[35180] = 35177, -- grinding wheel
	[35178] = 35179,
	[35179] = 35178, -- grinding wheel
	[35181] = 35183,
	[35183] = 35181, -- pair of bellows
	[35182] = 35184,
	[35184] = 35182, -- pair of bellows
	[35185] = 35186,
	[35186] = 35185, -- anvil
	[35187] = 35188,
	[35188] = 35187, -- water bucket
	[35909] = 35910, -- chaos critical dice
	[36019] = 36020, -- white lion doll
	[36478] = 36479,
	[36480] = 36481, -- banor doll
	[36618] = 36619,
	[36619] = 36618, -- volcanic basin
	[36620] = 36621,
	[36621] = 36620, -- volcanic sphere
	[36622] = 36623,
	[36623] = 36622, -- volcanic spire
	[36624] = 36625,
	[36625] = 36624, -- volcanic bulb
	[36626] = 36628,
	[36628] = 36626, -- volcanic mirror
	[36627] = 36629,
	[36629] = 36627, -- volcanic mirror
	[36638] = 36639,
	[36639] = 36638, -- volcanic table
	[36640] = 36642,
	[36642] = 36644, -- volcanic shelf
	[36644] = 36640,
	[36641] = 36643, -- volcanic shelf
	[36643] = 36645,
	[36645] = 36641, -- volcanic shelf
	[36646] = 36649,
	[36647] = 36650, -- demon baller
	[36648] = 36651,
	[36653] = 36652, -- demon baller
	[36654] = 36646, -- demon baller
	[36750] = 36751,
	[36754] = 36752, -- falcon pet
	[36756] = 36753, -- falcon pet
	[36959] = 36960, -- megasylvan plant
	[36978] = 36979,
	[36979] = 36978, -- magic hat
	[36996] = 36997,
	[36998] = 36999, -- Luna
	[37015] = 37016,
	[37016] = 37015, -- yellow shroom lamp
	[37017] = 37018,
	[37018] = 37017, -- pink shroom lamp
	[37021] = 37022, -- dragon plant
	[37052] = 37053,
	[37053] = 37052, -- bonelord tome
	[37054] = 37055,
	[37056] = 37057, -- Bella Bonecrusher's doll
	[37061] = 37062,
	[37063] = 37064, -- Evora
	[37111] = 37112,
	[37113] = 37114, -- armillary sphere
	[37185] = 37186,
	[37186] = 37700, -- kraken watcher lamp
	[37700] = 37185, -- kraken watcher lamp
	[37187] = 37519,
	[37519] = 37187, -- kraken buoy lamp
	[37188] = 37520,
	[37520] = 37188, -- kraken tentacle lamp
	[37189] = 37191,
	[37191] = 37189, -- kraken shelf
	[37190] = 37192,
	[37192] = 37190, -- kraken shelf
	[37205] = 37206,
	[37206] = 37207, -- sculpture of an octoputz
	[37207] = 37205,
	[37208] = 37209, -- sculpture of an octoputz
	[37209] = 37210,
	[37210] = 37208, -- sculpture of an octoputz
	[37211] = 37212,
	[37212] = 37211, -- octoputz
	[37543] = 37580,
	[37580] = 37543, -- string of fairy lights RYG
	[37544] = 37581,
	[37581] = 37544, -- string of fairy lights BRG
	[37545] = 37582,
	[37582] = 37545, -- string of fairy lights BGY
	[37557] = 37558,
	[37559] = 37560, -- dragon pinata
	[37743] = 37744,
	[37745] = 37746, -- draptor doll
	[37749] = 37750,
	[37750] = 37749, -- dark oracle
	[37806] = 37807,
	[37807] = 37806, -- zaoan wall lamp
	[37808] = 37809,
	[37809] = 37808, -- zaoan wall lamps
	[37811] = 37813,
	[37812] = 37814, -- sculpture of a fox
	[38522] = 38524,
	[38524] = 38522, -- naga lamp
	[38523] = 38525,
	[38525] = 38523, -- naga lamp
	[38526] = 38528,
	[38528] = 38526, -- basin with a glowing flower
	[38529] = 38530,
	[38530] = 38529, -- wall lamp
	[38531] = 38532,
	[38532] = 38531, -- wall lamp
	[38533] = 38534,
	[38534] = 38533, -- wall lamp
	[38535] = 38536,
	[38536] = 38535, -- wall lamp
	[38623] = 38624,
	[38624] = 38623, -- wall lamp
	[38625] = 38626,
	[38626] = 38625, -- wall lamp
	[38677] = 38680,
	[38704] = 38705, -- beaver of wisdom
	[38827] = 38828,
	[38828] = 38827, -- wall lamp
	[39423] = 39425,
	[39425] = 39423, -- knightly table
	[39424] = 39426,
	[39426] = 39424, -- knightly table
	[39427] = 39428,
	[39428] = 39427, -- knightly chess table
	[39443] = 39444,
	[39444] = 39445, -- knightly fire bowl
	[39445] = 39443, -- knightly fire bowl
	[39446] = 39447,
	[39447] = 39446, -- knightly wall lamp
	[39496] = 39497,
	[39497] = 39496, -- knightly sword lamp
	[39498] = 39499,
	[39499] = 39498, -- knightly candelabra
	[39500] = 39501,
	[39501] = 39500, -- knightly candle holder
	[39508] = 39509,
	[39668] = 39510, -- knightly guard
	[39694] = 39696, -- lucky dragon
	[39697] = 39698,
	[39698] = 39697, -- rainbow torch
	[39699] = 39700,
	[39700] = 39699, -- rainbow torch
	[39701] = 39702,
	[39702] = 39701, -- rainbow torch
	[39757] = 39758, -- yeti doll
	[39759] = 39760,
	[39761] = 39762, -- the gods' twilight doll
	[39772] = 39773,
	[39773] = 39774, -- flower table
	[39774] = 39772, -- flower table
	[39793] = 39794,
	[39794] = 39793, -- turquoise flower lamp
	[39795] = 39796,
	[39796] = 39795, -- purple flower lamp
	[39801] = 39802,
	[39802] = 39801, -- wall leaves
	[39803] = 39804,
	[39804] = 39803, -- tendrils
	[39805] = 39806,
	[39807] = 39808, -- water nymph
	[39810] = 39809, -- water nymph
	[42271] = 42272,
	[42272] = 42271, -- seafarer table
	[42291] = 42292,
	[42292] = 42291, -- seashell lamp
	[42293] = 42294,
	[42294] = 42293, -- seashell lamp
	[42295] = 42296,
	[42296] = 42295, -- tentacle lamp
	[42297] = 42298,
	[42298] = 42297, -- tentacle lamp
	[42299] = 42300,
	[42300] = 42299, -- sea-devil wall lamp
	[42301] = 42302,
	[42302] = 42301, -- seafood bucket
	[42324] = 42326,
	[42326] = 42324, -- opulent table
	[42325] = 42327,
	[42327] = 42325, -- opulent table
	[42346] = 42347,
	[42347] = 42346, -- opulent floor lamp
	[42348] = 42349,
	[42349] = 42348, -- opulent floor lamp
	[42363] = 42364, -- djinn lamp
	[42365] = 42366 -- djinn lamp
}

local transformTo = Action()

function transformTo.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if voices[item:getId()] then
		local spectators = Game.getSpectators(fromPosition, false, true, 3, 3)
		for i = 1, #spectators do
			player:say(voices[item:getId()], TALKTYPE_MONSTER_SAY, false, spectators[i], fromPosition)
		end
	end

	item:transform(transformItems[item.itemid])
	item:decay()
	return true
end

for index, value in pairs(transformItems) do
	transformTo:id(index)
end

transformTo:register()
