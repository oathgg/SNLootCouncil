function addonCommand(command)
    if      command == "show"   then SN_ItemList:Show()
    elseif  command == "reset"  then SN_ItemList:Reset()
    else                             SN:PrintMsg("Available commands are:"
        .."\n/sn show - Starts tracking and shows loot being distributed."
        .."\n/sn reset - Resets the list of loot being distributed.")
    end
end

SLASH_SN1 = "/sn"
SlashCmdList.SN = addonCommand