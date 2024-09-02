local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4541 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission73) == 1 then
		player:teleportTo(Position(33015, 32422, 11))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

sacrificeTeleport:type("stepin")
sacrificeTeleport:aid(4536)
sacrificeTeleport:register()
