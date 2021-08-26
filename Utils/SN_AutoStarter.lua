local SN_AutoStarterEvents = CreateFrame("frame")

function SN_AutoStarterEvents.PLAYER_ENTERING_WORLD(...)
    C_Timer.After(20, function () 
        local inInstance, instanceType = IsInInstance()
        if inInstance and instanceType == "raid" then
            local instanceName, _, _, _, _ = GetInstanceInfo()
            SN:PrintMsg("Player entered "..instanceName)
            SN_ItemTracker:Start()
                SN:PrintMsg("Combat logging started.")
                if not LoggingCombat() then
                    LoggingCombat(true)
                end
        else
            SN_ItemTracker:Stop()

            if LoggingCombat() then
                LoggingCombat(false)
            end
        end
    end)
end

-- https://wowwiki.fandom.com/wiki/Events/Loot
SN_AutoStarterEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SN_AutoStarterEvents:SetScript("OnEvent", function(self, event, ...) self[event](...) end)