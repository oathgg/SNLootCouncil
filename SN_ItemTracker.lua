SN_ItemTracker = {}

local IS_ENABLED = false

function OnTradeSuccess(...)
    local targetPlayer, itemName, quality = ...

    if targetPlayer and itemName and quality then
        local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

        if itemId then
            SN_Item:AssignOwner(itemId, targetPlayer)
            SN:PrintMsg("Traded "..itemName.." to "..targetPlayer)
        end
    end
end

function SN_ItemTracker:Start()
    if not IS_ENABLED then
        SN:PrintMsg("Started tracker")
        SN_ChatReader:Start()
        SN_TradeTracker:SubscribeSuccessCallback(OnTradeSuccess)

        IS_ENABLED = true
    else
        SN:PrintMsg("Already tracking")
    end
end

function SN_ItemTracker:Stop()
    --SN:PrintMsg("Stopped tracker")
end

function SN_ItemTracker:Reset()
    SN_Item:Reset()
end