SN_ItemTracker = {}

local IS_ENABLED = false

function OnItemDistribution(...)
    if IS_ENABLED then
        local targetPlayer, itemName, quality = ...
        if targetPlayer and itemName and quality then
            if quality >= SN.MinimumItemRarityBeforeProcessing then
                -- We will find something if it's being distributed through the master loot function
                local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

                -- We most likely looted it ourself so we can distribute it later through a trade.
                -- If we don't have an item AND we're trading it then we should look it up in the list with ourselves as owner.
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

function OnChatDistribution(...)
    if IS_ENABLED then
        local itemName = ...

        SN:PrintMsg("Detected item "..itemName)
        SN_ItemList:Add(itemName)
    end
end

function SN_ItemTracker:Start()
    if not IS_ENABLED then
        SN:PrintMsg("Started tracker")
        SN_ChatReader:Start()
        SN_TradeTracker:SubscribeSuccessCallback(OnItemDistribution)
        SN_MasterLoot:SubscribeCallback(OnItemDistribution)
        SN_ChatReader:SubscribeCallback(OnChatDistribution)

        IS_ENABLED = true
    else
        SN:PrintMsg("Already tracking")
    end
end

function SN_ItemTracker:Stop()
    if IS_ENABLED then
        IS_ENABLED = false
        SN:PrintMsg("Stopped tracker")
    end
end

function SN_ItemTracker:Reset()
    SN_Item:Reset()
end