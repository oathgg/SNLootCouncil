local SN_AutoStarterEvents = CreateFrame("frame")

function SN_AutoStarterEvents.PLAYER_ENTERING_WORLD(...)
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == "raid" then
        local instanceName, _, _, _, maxPlayers = GetInstanceInfo()
        if maxPlayers == 40 then
            SN:PrintMsg("Player entered "..instanceName)
            SN_ItemTracker:Start()

            SN:PrintMsg("Combat logging started.")
            LoggingCombat(true)
        end
    else
        SN_ItemTracker:Stop()

        if LoggingCombat() then
            SN:PrintMsg("Combat logging stopped.")
            LoggingCombat(false)
        end
    end
end

-- https://wowwiki.fandom.com/wiki/Events/Loot
SN_AutoStarterEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SN_AutoStarterEvents:SetScript("OnEvent", function(self, event, ...) self[event](...) end)