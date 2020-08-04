function addonCommand(command)
    if      command == "show"   then SN_ItemList:Show()
    elseif  command == "reset"  then SN_ItemList:Reset()
    elseif  command == "start"  then SN_ChatReader:Start()
    elseif  command == "stop"   then SN_ChatReader:Stop()
    else                             SN:PrintMsg("Unrecognized command '"..command.."'.")
    end
end

SLASH_SN1 = "/sn"
SlashCmdList.SN = addonCommand