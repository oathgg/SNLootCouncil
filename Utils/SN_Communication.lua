SN_Communication = {}
local SN_COMMS_EVENTS = CreateFrame("frame")
local ADDON_MESSAGE_PREFIX = 'SNLOOTCOUNCIL'
local ADDON_MESSAGE_DISTRIBUTION = 'DISTRIBUTION'

local function Broadcast(msg)
    local chatType = nil

    if IsInRaid() then
        chatType = "RAID"
    elseif IsInGroup() then
		chatType = "PARTY"
    end
    
    if chatType then
        -- SN:PrintMsg("-> "..ADDON_MESSAGE_PREFIX..", "..msg..", "..chatType)
        C_ChatInfo.SendAddonMessage(ADDON_MESSAGE_PREFIX, msg, chatType)
    end
end

local function CreateBroadcastMessage(subject, msg)
    local fullMsg = subject

    if msg then
        fullMsg = fullMsg.."\t"..msg
    end

    Broadcast(fullMsg)
end

-- /run SN_Communication:BroadcastDistribution("Ruljih", "Item Name", "1")
function SN_Communication:BroadcastDistribution(targetPlayer, itemName, quality)
    CreateBroadcastMessage(ADDON_MESSAGE_DISTRIBUTION, targetPlayer..'\t'..itemName..'\t'..quality)
end

function SN_COMMS_EVENTS.CHAT_MSG_ADDON(...)
    local prefix, msg, channel, sender = ...
    -- Don't listen to our own broadcasts.
    local senderWithoutRealm = strsplit("-", sender)
    if senderWithoutRealm == UnitName("player") then
        return
    end

    if prefix == ADDON_MESSAGE_PREFIX then
        -- SN:PrintMsg("<- "..ADDON_MESSAGE_PREFIX..", "..msg..", "..chatType)

        if string.find(msg, ADDON_MESSAGE_DISTRIBUTION) then
            local _, targetPlayer, itemName, quality = strsplit("\t", msg)
            SN_ItemTracker:OnBroadcastDistribution(targetPlayer, itemName, quality)
        end
    end
end

SN_COMMS_EVENTS:RegisterEvent("CHAT_MSG_ADDON")
SN_COMMS_EVENTS:SetScript("OnEvent", function(self, event, ...) self[event](...) end)