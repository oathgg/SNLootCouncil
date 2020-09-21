SN_ItemTracker = {}

local IS_ENABLED = false
local PREV_ITEM = ""

local function IsValidDistribution(...)
    local targetPlayer, itemName, quality = ...

    return IS_ENABLED and targetPlayer and itemName and quality and itemName ~= "Nexus Crystal" and quality >= SN.MinimumItemRarityBeforeProcessing
end

-- When we trade the item to someone else this function will trigger.
-- We check if we have an item in our already created list with our own name, if not then we quickly add this item to our list and assign the owner.
function OnItemTradeDistribution(...)
    if IsValidDistribution(...) then
        local targetPlayer, itemName, quality = ...

        local itemId = SN_Item:GetItemByNameWithMyselfAsOwner(itemName)
        if not itemId then
            SN:PrintMsg("Couldn't find the traded item in the list.")
        else
            SN_Item:AssignOwner(itemId, targetPlayer)
            SN:PrintMsg("Distributed "..itemName.." to "..targetPlayer)
        end
    end
end

function OnItemMLDistribution(...)
    if IsValidDistribution(...) then
        local targetPlayer, itemName, quality = ...

        local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

        -- BUG:: In case we somehow didn't catch the raid warning we will create it again.
        if not itemId then
            SN:PrintMsg("Couldn't find an item in the list for name '"..itemName.."', creating item.")
            SN_ItemList:Add(itemName)
            itemId = SN_Item:GetItemByNameWithoutOwner(itemName)
        end

        SN_Item:AssignOwner(itemId, targetPlayer)
        SN:PrintMsg("Distributed "..itemName.." to "..targetPlayer)
    end
end

function OnChatDistribution(...)
    if IS_ENABLED then
        local itemName = ...

        -- In case they also announce the OS in raid warning.
        if itemName ~= PREV_ITEM then
            SN:PrintMsg("Detected item "..itemName)
            SN_ItemList:Add(itemName)

            PREV_ITEM = itemName
        end
    end
end

function SN_ItemTracker:Start()
    if not IS_ENABLED then
        SN:PrintMsg("Started tracker")
        SN_ChatReader:Start()
        SN_TradeTracker:SubscribeSuccessCallback(OnItemTradeDistribution)
        SN_MasterLoot:SubscribeCallback(OnItemMLDistribution)
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