local config = {
	items = {
		{ id = 35284, charges = 64000 },
		{ id = 35279, charges = 64000 },
		{ id = 35281, charges = 64000 },
		{ id = 35283, charges = 64000 },
		{ id = 35282, charges = 64000 },
		{ id = 35280, charges = 64000 },
	},
	storage = tonumber(Storage.PlayerWeaponReward), -- storage key, player can only win once
}

local function sendExerciseRewardModal(player)
	local window = ModalWindow {
		title = "Exercise Reward",
		message = 'choose a item'
	}
	for _, it in pairs(config.items) do
		local iType = ItemType(it.id)
		if iType then
			window:addChoice(iType:getName(), function(player, button, choice)
				if button.name ~= "Select" then
					return true
				end

				local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
				if inbox and inbox:getEmptySlots() > 0 then
					local item = inbox:addItem(it.id, it.charges)
					if item then
						item:setActionId(IMMOVABLE_ACTION_ID)
					else
						player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
						return
					end
					player:sendTextMessage(MESSAGE_LOOK, string.format("Congratulations, you received a %s with %i charges in your store inbox.", iType:getName(), it.charges))
					player:setStorageValue(config.storage, 1)
				else
					player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
				end
			end)
		end
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

local exercise_reward_modal = TalkAction("!reward")
function exercise_reward_modal.onSay(player, words, param)
	if player:getStorageValue(config.storage) > 0 then
		player:sendTextMessage(MESSAGE_LOOK, "You already received your exercise weapon reward!")
		return true
	end
	sendExerciseRewardModal(player)
	return true
end

exercise_reward_modal:separator(" ")
exercise_reward_modal:groupType("normal")
exercise_reward_modal:register()
