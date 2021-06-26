local SN_AutoStarterEvents = CreateFrame("frame")
local CombatLogEnabled = false

function SN_AutoStarterEvents.PLAYER_ENTERING_WORLD(...)
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == "raid" then
        local instanceName, _, _, _, _ = GetInstanceInfo()
        SN_ItemTracker:Start()
        SN:PrintMsg("Player entered "..instanceName)
        
        if (-not CombatLogEnabled) then
            SN:PrintMsg("Combat logging started.")
            LoggingCombat(true)
            CombatLogEnabled = true
        end
    else
        SN_ItemTracker:Stop()

        if (CombatLogEnabled) then
            SN:PrintMsg("Combat logging stopped.")
            LoggingCombat(false)
        end
    end
end

-- https://wowwiki.fandom.com/wiki/Events/Loot
SN_AutoStarterEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SN_AutoStarterEvents:SetScript("OnEvent", function(self, event, ...) self[event](...) end)