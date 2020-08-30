SN_ChatReader = {}
local EVENTS = CreateFrame("frame")
-- https://wow.gamepedia.com/CHAT_MSG_RAID
local CHAT_MSG_RAID = "CHAT_MSG_RAID"
local CHAT_MSG_RAID_LEADER = "CHAT_MSG_RAID_LEADER"
local CHAT_MSG_RAID_WARNING = "CHAT_MSG_RAID_WARNING"
local ENABLED = false

local CALLBACK = {}

function SN_ChatReader:Start()
    if not ENABLED then
        EVENTS:RegisterEvent(CHAT_MSG_RAID)
        EVENTS:RegisterEvent(CHAT_MSG_RAID_LEADER)
        EVENTS:RegisterEvent(CHAT_MSG_RAID_WARNING)

        ENABLED = true
    end
end

function SN_ChatReader:Stop()
    if ENABLED then
        EVENTS:UnregisterEvent(CHAT_MSG_RAID)
        EVENTS:UnregisterEvent(CHAT_MSG_RAID_LEADER)
        EVENTS:UnregisterEvent(CHAT_MSG_RAID_WARNING)

        ENABLED = false
    end
end

function SN_ChatReader:ProcessMessage(event, ...)
    local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...

    -- Item distribution
    if event == CHAT_MSG_RAID_WARNING then
        local itemName, itemLink, itemRarity = GetItemInfo(text)
        
        if itemName and itemRarity >= SN.MinimumItemRarityBeforeProcessing then
            for key, callback in pairs(CALLBACK) do
                callback(itemName)
            end 
        end
    else
        -- if string.StartsWith(text, "+") then
        --     SN:PrintMsg(playerName.." has selected need.")
        -- end
    end
end

function SN_ChatReader:SubscribeCallback(callback)
    tinsert(CALLBACK, callback)
end

EVENTS:SetScript("OnEvent", function(self, event, ...) SN_ChatReader:ProcessMessage(event, ...) end)