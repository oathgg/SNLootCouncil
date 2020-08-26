function addonCommand(command)
    if      command == "start"  then SN_ItemTracker:Start()
    elseif  command == "stop"   then SN_ItemTracker:Stop()
    elseif  command == "show"   then SN_ItemList:Show()
    elseif  command == "reset"  then SN_ItemTracker:Reset()
    else                             SN:PrintMsg("Available commands are:"
        .."\n/sn show - Starts tracking and shows loot being distributed."
        .."\n/sn reset - Resets the list of loot being distributed.")
    end
end

SLASH_SN1 = "/sn"
SlashCmdList.SN = addonCommand