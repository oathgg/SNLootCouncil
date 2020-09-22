SN_ItemTracker = {}

local IS_ENABLED = false
local PREV_ITEM = ""

local function IsValidDistribution(...)
    local targetPlayer, itemName, quality = ...

    return IS_ENABLED and targetPlayer and itemName and quality and itemName ~= "Nexus Crystal" and itemName ~= "Elementium Ore" and quality >= SN.MinimumItemRarityBeforeProcessing
end

local function Distribute(itemId, itemName, targetPlayer)
    SN_Item:AssignOwner(itemId, targetPlayer)
    SN:PrintMsg("Distributed '"..itemName.."' to "..targetPlayer)
end

-- When we trade the item to someone else this function will trigger.
-- We check if we have an item in our already created list with our own name, if not then we quickly add this item to our list and assign the owner.
function OnItemTradeDistribution(...)
    if IsValidDistribution(...) then
        local targetPlayer, itemName, quality = ...

        local itemId = SN_Item:GetItemByNameWithMyselfAsOwner(itemName)

        -- BUG:: Fallback, if we haven't found an item with ourselves as owner then we try to go with an ownerless item.
        -- However, how is this possible, because the item should've been distributed through ML first, did the ML action not catch the item?
        if not itemId then
            itemId = SN_Item:GetItemByNameWithoutOwner(itemName)
        end

        if itemId then
            Distribute(itemId, itemName, targetPlayer)
        else
            SN:PrintMsg("Couldn't find the traded item in the list.")
        end
    end
end

function OnItemMLDistribution(...)
    if IsValidDistribution(...) then
        local targetPlayer, itemName, quality = ...

        local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

        -- BUG:: In case we somehow didn't catch the raid warning we will create it again.
        if not itemId then
            SN:PrintMsg("Couldn't find '"..itemName.."', creating item.")
            SN_ItemList:Add(itemName)
            itemId = SN_Item:GetItemByNameWithoutOwner(itemName)
        end

        Distribute(itemId, itemName, targetPlayer)
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
        IS_ENABLED = true
    else
        SN:PrintMsg("Already tracking")
    end
end

function SN_ItemTracker:Stop()
    if IS_ENABLED then
        SN:PrintMsg("Stopped tracker")
        SN_ChatReader:Stop()
        IS_ENABLED = false
    end
end

function SN_ItemTracker:Reset()
    PREV_ITEM = ""
    SN_Item:Reset()
end

SN_TradeTracker:SubscribeSuccessCallback(OnItemTradeDistribution)
SN_MasterLoot:SubscribeCallback(OnItemMLDistribution)
SN_ChatReader:SubscribeCallback(OnChatDistribution)