SN = {}

function SN:PrintMsg(msg)
    local colorCodeStr = "|cff00CB72"
    local prefix = colorCodeStr.."SNLootCouncil: |r"
    
    print(prefix..msg)
end

function string.StartsWith(str, start)
    return str:sub(1, #start) == start
end
 
function string.EndsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end