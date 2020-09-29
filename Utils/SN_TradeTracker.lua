SN_TradeTracker = {}

local SN_TradeWindow = CreateFrame("frame")

local targetCancelled = false
local targetAccepted = false
local playerAccepted = false
local TRADE_CLOSED_EVENT_TRIGGERED = false
local TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = false
local TRADE_SUCCESS_CALLBACK = {}

local TARGET_PLAYER = nil
local ITEM_NAME = nil
local ITEM_QUALITY = nil

-- Fired when the status of the player and target accept buttons has changed. 
-- Target agree status only shown when he has done it first. 
-- By this, player and target agree status is only shown together (arg1 == 1 and arg2 == 1), when player agreed after target.
function SN_TradeWindow.TRADE_ACCEPT_UPDATE(player, target)
    if (targetAccepted == false and target == 1 or player == 1) then -- success
        targetAccepted = true
    end

    if (player == 1) then
        playerAccepted = true
    end

    ITEM_NAME, _, _, ITEM_QUALITY, _, _ = GetTradePlayerItemInfo(1) -- first
end

-- Fired when the Trade window appears after a trade request has been accepted or auto-accepted
function SN_TradeWindow.TRADE_SHOW()
    -- initialize variables
    payment = {}
    targetAccepted = false
    targetCancelled = false
    playerAccepted = false
    TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = false
    TRADE_CLOSED_EVENT_TRIGGERED = false

    TARGET_PLAYER = UnitName("npc")
end

-- Fired when the trade window is closed by the trade being accepted, or the player or target closes the window.
function SN_TradeWindow.TRADE_CLOSED()
    if (not TRADE_REQUEST_CANCEL_EVENT_TRIGGERED and TRADE_CLOSED_EVENT_TRIGGERED == false and playerAccepted and targetAccepted) then
        TRADE_CLOSED_EVENT_TRIGGERED = true

        --SN:PrintMsg("Successful trade detected with "..TARGET_PLAYER)
        for key, callback in pairs(TRADE_SUCCESS_CALLBACK) do
            callback(TARGET_PLAYER, ITEM_NAME, ITEM_QUALITY)
        end 
    end
end

-- Fired when a trade attempt is cancelled. Fired after TRADE_CLOSE when aborted by player, before TRADE_CLOSE when done by target.
function SN_TradeWindow.TRADE_REQUEST_CANCEL()
    TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = true
end

function SN_TradeTracker:SubscribeCallback(callback)
    tinsert(TRADE_SUCCESS_CALLBACK, callback)
end

-- Register all events we wish to hook
SN_TradeWindow:RegisterEvent("TRADE_REQUEST_CANCEL")
SN_TradeWindow:RegisterEvent("TRADE_ACCEPT_UPDATE")
SN_TradeWindow:RegisterEvent("TRADE_CLOSED")
SN_TradeWindow:RegisterEvent("TRADE_SHOW")
SN_TradeWindow:SetScript("OnEvent", function(self, event, ...) self[event](...) end)