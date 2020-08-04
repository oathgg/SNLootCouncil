local AceGUI = LibStub("AceGUI-3.0")
TableHelper = {}

--[[ 
    header = Object the column will be added to (Table),
    listOfColumns = {
        columnName = Name of the column (String),
        width = Width of the column (int)
    }
}]]
function TableHelper:CreateColumns(header, listOfColumns, onClickCallback)

    local columns = {}
    local columnIdx = 0
    local maxRecords = table.getn(listOfColumns)
    
    for index = 1, maxRecords do
        local columnName, width = unpack(listOfColumns[index])
        width = width or 150

        columnIdx = columnIdx + 1
        columns[columnName] = columnIdx

        local btn = AceGUI:Create("InteractiveLabel")
        if onClickCallback then
            btn:SetCallback("OnClick", function() onClickCallback(columns[columnName]) end)
        end
        btn:SetWidth(width)
        btn:SetText(LuaHelper:ColorizeStr(columnName, "CYAN"))
        header:AddChild(btn)
    end

    return columns
end

function TableHelper:CreateHeader(mainFrame)
    local header = AceGUI:Create("SimpleGroup")
	header:SetFullWidth(true)
	header:SetLayout("Flow")
	mainFrame:AddChild(header)

    return header
end

function TableHelper:AddScroll(tableContentGroup, xmlFrameTemplate, xmlItemTemplate, callback)
    local scroll = CreateFrame("ScrollFrame", nil, tableContentGroup.frame, xmlFrameTemplate)--"HybridScrollFrameHistory")
    HybridScrollFrame_CreateButtons(scroll, xmlItemTemplate)--"HybridScrollFrameHistoryItemTemplate");
    HybridScrollFrame_SetDoNotHideScrollBar(scroll, true)
    scroll.update = callback

    return scroll
end