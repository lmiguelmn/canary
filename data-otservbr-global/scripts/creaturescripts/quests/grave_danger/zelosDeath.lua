local config = {
    centerPosition = Position(33443, 31545, 13),
    rangeX = 11,
    rangeY = 11,
}

local KingzelosDeath = CreatureEvent("zelosDeath")

function KingzelosDeath.onPrepareDeath(creature)
    local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
    for _, cid in pairs(spectators) do
        if cid:isPlayer() then
            if cid:getStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.InquisitionOutfitReceived) == -1 then
                cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Hand of the Inquisition Outfit.")
                cid:addOutfit(1244, 0)
                cid:addOutfit(1243, 0)
                cid:setStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.InquisitionOutfitReceived, 1)
            end
        end
    end

    return true
end

KingzelosDeath:register()
