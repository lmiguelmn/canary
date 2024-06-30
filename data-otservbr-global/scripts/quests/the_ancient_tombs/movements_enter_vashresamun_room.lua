local movements_enter_omruc_room = MoveEvent()

function movements_enter_omruc_room.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(33129, 32657, 15)
	if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DefaultStart) ~= 1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.VashresamunsTreasure) <= 2 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.VashresamunsTreasure, 3)
		end
	end

	return true
end


movements_enter_omruc_room:type("stepin")
movements_enter_omruc_room:uid(40091)
movements_enter_omruc_room:register()
