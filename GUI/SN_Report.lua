SN_Report = {}

local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil

local function GenerateText()
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
        if values.Owner ~= "Disenchant" then
            lines = lines.."@"
        end

        lines = lines..values.Owner
    end

    return lines
end

local function GenerateMultiLineEditBox()
    local widget = AceGUI:Create("MultiLineEditBox")
    widget:DisableButton(true)
    widget:SetLabel("Items")
    widget:SetText(GenerateText())
    widget:SetFocus()
    widget:SetFullWidth(true)
    widget:SetHeight(mainFrame.frame.height - 70)
    widget:HighlightText()
    mainFrame:AddChild(widget)
end

local function CreateGUI()
    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["AAA_Report"] = mainFrame
    tinsert(UISpecialFrames, "AAA_Report")	-- allow ESC close
    mainFrame:SetWidth(500)
    mainFrame:SetHeight(500)
    mainFrame:SetTitle("Generated report list")
    mainFrame:EnableResize(false)

    GenerateMultiLineEditBox()
end

function SN_Report:Show()
    if mainFrame == nil or not mainFrame:IsShown() then
        CreateGUI()
        mainFrame:Show()
    else
        mainFrame:Hide()
        mainFrame = nil
    end
end