local internalNpcName = "Muhad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 116,
	lookBody = 116,
	lookLegs = 78,
	lookFeet = 114,
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

keywordHandler:addKeyword({ "here" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am the leader of the true sons of {Daraman}."
})
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am the leader of the true sons of {Daraman}."
})
keywordHandler:addKeyword({ "daraman" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "This is our home - the land of the desert."
})
keywordHandler:addKeyword({ "ankrahmun" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We will fight that city until we get back what belongs to us."
})
keywordHandler:addKeyword({ "darashia" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We avoid these places you call cities."
})
keywordHandler:addKeyword({ "city" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I would go crazy living in a cage like that."
})
keywordHandler:addKeyword({ "offer" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We have nothing that would be of value for you."
})
keywordHandler:addKeyword({ "undead" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "That is the curse for not following the rules of the desert. No son of the desert has ever come back from the dead."
})
keywordHandler:addKeyword({ "daraman" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We have nothing that would be of value for you."
})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local AritosTask = player:getStorageValue(Storage.TibiaTales.AritosTask)

	-- AritosTask
	if MsgContains(message, "arito") then
		if player:getStorageValue(Storage.TibiaTales.AritosTask) == 1 then
			npcHandler:say(
				{
					"I don't know how something like this ever could be possible. He met a girl from {Ankrahmun} and she must have twisted his head. Arito started to tell stories about the Pharaoh and about Ankrahmun. ...",
					"In the wink of an eye he left us and was never seen again. I think he feared revenge for leaving us - which partially is not without reason. Why are you asking me about him? Did he send you to me?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say(
				{
					"Ahh, I know that some of my people fear that Arito tells the old secrets of our race and want to see him dead but I don't bear him a grudge. I will have to have a serious word with my people. ...",
					"Tell him that he can consider himself as acquitted. He is not the reason for our attacks towards {Ankrahmun}."
				},
				npc,
				creature
			)
			player:setStorageValue(Storage.TibiaTales.AritosTask, 2)
			player:setStorageValue(Storage.TibiaTales.AritosTaskDoor, 1)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, foreigner under the sun of Darama. What brings you {here}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "May Daraman be with you on your travels.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May Daraman be with you on your travels.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
