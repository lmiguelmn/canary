local config = {
	activationMessage = 'You have received %s VIP days.',
	activationMessageType = MESSAGE_EVENT_ADVANCE,

	expirationMessage = 'Your VIP days ran out.',
	expirationMessageType = MESSAGE_STATUS_WARNING,

	outfits = {},
	mounts = {},
}

function Player.onRemoveVip(self)
	self:sendTextMessage(config.expirationMessageType, config.expirationMessage)

	for _, outfit in ipairs(config.outfits) do
		self:removeOutfit(outfit)
	end

	for _, mount in ipairs(config.mounts) do
		self:removeMount(mount)
	end

	local playerOutfit = self:getOutfit()
	if table.contains(config.outfits, self:getOutfit().lookType) then
		if self:getSex() == PLAYERSEX_FEMALE then
			playerOutfit.lookType = 136
		else
			playerOutfit.lookType = 128
		end
		playerOutfit.lookAddons = 0
		self:setOutfit(playerOutfit)
	end

	self:setStorageValue(Storage.VipSystem.IsVip, 0)
end

function Player.onAddVip(self, days)
	self:sendTextMessage(config.activationMessageType, string.format(config.activationMessage, days))

	for _, outfit in ipairs(config.outfits) do
		self:addOutfitAddon(outfit, 3)
	end

	for _, mount in ipairs(config.mounts) do
		self:addMount(mount)
	end

	self:setStorageValue(Storage.VipSystem.IsVip, 1)
end

function CheckPremiumAndPrint(player, msgType)
	if player:getVipDays() == 0xFFFF then
		player:sendTextMessage(msgType, 'You have infinite amount of VIP days left.')
		return true
	end

	local playerVipTime = player:getVipTime()
	if playerVipTime < os.time() then
		local msg = 'You do not have VIP on your account.'
		player:sendTextMessage(msgType, msg)
		return true
	end

	local timeRemaining = playerVipTime - os.time()
	local days = math.floor(timeRemaining / 86400)
	if days > 1 then
		player:sendTextMessage(msgType, string.format("You have %d VIP days left.", days))
		return true
	end

	local hours = math.floor((timeRemaining % 86400) / 3600)
	local minutes = math.floor((timeRemaining % 3600) / 60)
	local seconds = timeRemaining % 60
	player:sendTextMessage(msgType, string.format("You have %d hours, %d minutes and %d seconds VIP days left.", hours, minutes, seconds))
end

