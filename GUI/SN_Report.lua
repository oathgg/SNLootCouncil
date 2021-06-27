SN_Report = {}

local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil

local function GenerateDiscordText()
    local lines = ""
    local firstLine = true

    for internalItemId, values in pairs(SN_Item:GetAllItems()) do
        if firstLine then
            firstLine = false
        else
            lines = lines.."\n"
        end

        lines = lines..values.Name.." : "

        -- Discord tagging system
        if values.Owner and values.Owner ~= "Disenchant" and values.Owner ~= "Guild bank" then
            lines = lines.."@"
        end

        lines = lines..(values.Owner or "")
    end

    return lines
end

--[[

    First line must contain headers for data (Case sensitive)
    character,date,itemID,itemName,note
    Gurgthock,2020-10-01,18821,Quick Strike Ring,That's my BIS

    Supported header fields: (Case Sensitive)
    player or character (required)
    itemID or item_id (required)
    item or itemName or item_name
    date or dateTime or date_time
    publicNote or public_note (max 140 chars)
    officerNote or officer_note + (note and/or votes and/or response) (max 140 chars)

    if note,response,public note, or officer note are equal to OS, offspec flag will be set to true

]]
local function GenerateThatsMyBisText()
    local lines = "character,date,itemID,itemName,note"

    for internalItemId, values in pairs(SN_Item:GetAllItems()) do
        if not (string.IsEmpty(values.Owner)) then 
            if (values.Owner ~= "Disenchant" and values.Owner ~= "Guild bank") then
                lines = lines.."\n"
                -- Owner
                lines = lines..values.Owner
                -- Date
                lines = lines..','..date("%Y-%m-%d")
                -- ItemId
                lines = lines..','..values.ItemID
                -- Item name
                lines = lines..','..values.Name
                -- Note
                lines = lines..','..(values.Note or "")
            end
        end
    end

    return lines
end

local function GenerateMultiLineEditBox(exportType)
    local widget = AceGUI:Create("MultiLineEditBox")
    widget:DisableButton(true)
    widget:SetLabel("")
    if (exportType == "DISCORD") then
        widget:SetText(GenerateDiscordText())
    elseif (exportType == "THATSMYBIS") then
        widget:SetText(GenerateThatsMyBisText())
    end
    widget:SetFocus()
    widget:SetFullWidth(true)
    widget:SetHeight(mainFrame.frame.height - 70)
    widget:HighlightText()
    mainFrame:AddChild(widget)
end

local function CreateGUI(exportType)
    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["AAA_Report"] = mainFrame
    tinsert(UISpecialFrames, "AAA_Report")	-- allow ESC close
    mainFrame:SetWidth(500)
    mainFrame:SetHeight(500)
    mainFrame:SetTitle("Generated report list")
    mainFrame:EnableResize(false)

    GenerateMultiLineEditBox(exportType)
end

function SN_Report:ShowExport(exportType)
    if mainFrame == nil or not mainFrame:IsShown() then

        if SN_Item:GetAllItems() == nil or getn(SN_Item:GetAllItems()) == 0 then
            SN:PrintMsg("There are no items in the list to report.")
        else
            SN:PrintMsg("Generating report...")
            CreateGUI(exportType)
            mainFrame:Show()
        end
    else
        mainFrame:Hide()
        mainFrame = nil
    end
end