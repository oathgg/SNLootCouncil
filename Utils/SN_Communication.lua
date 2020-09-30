SN_Communication = {}
local EVENTS = CreateFrame("frame")
local ADDON_MESSAGE_PREFIX = 'SN_LOOTCOUNCIL'
local ADDON_MESSAGE_DISTRIBUTION = 'DISTRIBUTION'

local function AddBroadcastMessage(prefix, msg)
    local fullMsg = prefix

    if msg then
        fullMsg = fullMsg.."\t"..msg
    end

    Communication:Broadcast(fullMsg)
end

function SN_Communication:Broadcast(msg)
    local chatType = nil

    if IsInGroup() then
        chatType = "PARTY"
    elseif IsInRaid() then
		chatType = "RAID"
    end
    
    if chatType then
        C_ChatInfo.SendAddonMessage(ADDON_MESSAGE_PREFIX, msg, chatType)
    end
end

function SN_Communication:BroadcastDistribution(targetPlayer, itemName, quality)
    AddBroadcastMessage(ADDON_MESSAGE_DISTRIBUTION, targetPlayer..'\t'..itemName..'\t'..quality)
end

function EVENTS.CHAT_MSG_ADDON(prefix, msg, channel, sender)
    -- Don't listen to our own messages
    local senderWithoutRealm = strsplit("-", sender)
    if prefix == ADDON_MESSAGE_PREFIX and senderWithoutRealm ~= IT_CONST_UNIT_NAME_PLAYER then
        if string.find(msg, ADDON_MESSAGE_DISTRIBUTION) then
            local _, targetPlayer, itemName, quality = strsplit("\t", msg)
            SN_ItemTracker:OnBroadcastDistribution(targetPlayer, itemName, quality)
        end
    end
end

EVENTS:RegisterEvent("CHAT_MSG_ADDON")
EVENTS:SetScript("OnEvent", function(self, event, ...) self[event](...) end)