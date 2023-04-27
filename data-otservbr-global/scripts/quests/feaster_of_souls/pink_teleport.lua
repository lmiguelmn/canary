local positions = {
	{pinktpPos = {x = 33572, y = 31459, z = 8}, tpPos = {x = 33886, y = 31785, z = 8}},
	{pinktpPos = {x = 33886, y = 31784, z = 8}, tpPos = {x = 33572, y = 31461, z = 8}},
	{pinktpPos = {x = 33581, y = 31465, z = 9}, tpPos = {x = 31904, y = 32347, z = 9}},
	{pinktpPos = {x = 31904, y = 32346, z = 9}, tpPos = {x = 33580, y = 31467, z = 9}},
	{pinktpPos = {x = 33863, y = 31854, z = 9}, tpPos = {x = 33601, y = 31442, z = 10}},
	{pinktpPos = {x = 33601, y = 31441, z = 10}, tpPos = {x = 33862, y = 31856, z = 9}},
}

local pinktp = MoveEvent()

function pinktp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	local newPos
	for _, info in pairs(positions) do
		if Position(info.pinktpPos) == position then
			newPos = Position(info.tpPos)
			break
		end
	end
	if newPos then
		player:teleportTo(newPos)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		newPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

pinktp:type("stepin")

pinktp:id(25051)

pinktp:register()