local SN_AutoStarterEvents = CreateFrame("frame")
SN_AutoStarter = {}

function SN_AutoStarterEvents.PLAYER_ENTERING_WORLD(...)
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == "raid" then
        local instanceName, _, _, _, maxPlayers = GetInstanceInfo()
        if maxPlayers == 40 then
            SN:PrintMsg("Player entered "..instanceName)
            SN_ItemTracker:Start()
        end
    else
        SN_ItemTracker:Stop()
    end
end

-- https://wowwiki.fandom.com/wiki/Events/Loot
SN_AutoStarterEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SN_AutoStarterEvents:SetScript("OnEvent", function(self, event, ...) self[event](...) end)