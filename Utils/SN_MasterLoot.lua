local SN_MasterLootEvent = CreateFrame("frame")
SN_MasterLoot = {}
local CALLBACK = {}

function SN_MasterLootEvent.CHAT_MSG_LOOT(...)
    local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
    local chatMsg, chatLineId = ...

    if lootmethod == "master" then
        -- <Target> receives loot: <item>
        -- You receive loot: <item>
        if string.find(chatMsg, "receive") then
            local receiver, _, _, item = strsplit(" ", chatMsg, 4)

            if receiver and item then
                local itemName, itemLink, itemRarity = GetItemInfo(item)

                if itemName and itemRarity then
                    for key, callback in pairs(CALLBACK) do
                        callback(receiver, itemName, itemRarity)
                    end 
                end
            end
        end
    end
end

function SN_MasterLoot:SubscribeCallback(callback)
    tinsert(CALLBACK, callback)
end

-- https://wowwiki.fandom.com/wiki/Events/Loot
SN_MasterLootEvent:RegisterEvent("CHAT_MSG_LOOT")
SN_MasterLootEvent:SetScript("OnEvent", function(self, event, ...) self[event](...) end)