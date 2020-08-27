SN_ItemTracker = {}

local IS_ENABLED = false

function OnTradeSuccess(...)
    if IS_ENABLED then
        local targetPlayer, itemName, quality = ...

        if targetPlayer and itemName and quality then
            if quality >= SN.MinimumItemRarityBeforeProcessing then
                local itemId = SN_Item:GetItemByNameWithoutOwner(itemName)

                if itemId then
                    SN_Item:AssignOwner(itemId, targetPlayer)
                    SN:PrintMsg("Traded "..itemName.." to "..targetPlayer)
                else
                    SN:PrintMsg("Couldn't find an ownerless item with name "..itemName)
                end
            end
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
    IS_ENABLED = false
    SN:PrintMsg("Stopped tracker")
end

function SN_ItemTracker:Reset()
    SN_Item:Reset()
end