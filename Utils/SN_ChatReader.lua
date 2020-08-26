SN_ChatReader = {}
local EVENTS = CreateFrame("frame")
-- https://wow.gamepedia.com/CHAT_MSG_RAID
local CHAT_MSG_RAID = "CHAT_MSG_RAID"
local CHAT_MSG_RAID_LEADER = "CHAT_MSG_RAID_LEADER"
local CHAT_MSG_RAID_WARNING = "CHAT_MSG_RAID_WARNING"
local ENABLED = false

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

        -- https://wowwiki.fandom.com/wiki/API_TYPE_Quality
        if itemName and itemRarity >= 4 then
                SN:PrintMsg("Detected item "..itemName)
            SN_ItemList:Add(itemName)
        end
    else
        -- if string.StartsWith(text, "+") then
        --     SN:PrintMsg(playerName.." has selected need.")
        -- end
    end
end

EVENTS:SetScript("OnEvent", function(self, event, ...) SN_ChatReader:ProcessMessage(event, ...) end)