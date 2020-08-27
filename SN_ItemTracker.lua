SN_ItemTracker = {}

local IS_ENABLED = false

function OnItemDistribution(...)
    if IS_ENABLED then
        local targetPlayer, itemName, quality = ...
        if targetPlayer and itemName and quality then

            -- We don't want to register "You" as a potential target, hence we update it to the player name
            if targetPlayer == "You" then
                targetPlayer = UnitName("player")
            end

            if quality >= SN.MinimumItemRarityBeforeProcessing then
                local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

                -- Look up the item if we can't find anything for our own playername.
                -- We most likely looted it so we can distribute it later through a trade.
                -- So if we don't have an item AND we're trading it then we should look it up in the list.
                if not itemId and targetPlayer ~= UnitName("player") then
                    itemId = SN_Item:GetItemByNameWithMyselfAsOwner(itemName)
                end

                if itemId then
                    SN_Item:AssignOwner(itemId, targetPlayer)
                    SN:PrintMsg("Distributed "..itemName.." to "..targetPlayer)
                else
                    SN:PrintMsg("Couldn't find an item in the list for name "..itemName)
                end
            end
        end
    end
end

function SN_ItemTracker:Start()
    if not IS_ENABLED then
        SN:PrintMsg("Started tracker")
        SN_ChatReader:Start()
        SN_TradeTracker:SubscribeSuccessCallback(OnItemDistribution)
        SN_MasterLoot:SubscribeCallback(OnItemDistribution)

        IS_ENABLED = true
    else
        SN:PrintMsg("Already tracking")
    end
end

function SN_ItemTracker:Stop()
    IS_ENABLED = false
    SN:PrintMsg("Stopped tracker")
end

function SN_ItemTracker:Reset()
    SN_Item:Reset()
end