local function SN_MINIMAPBUTTON_DROPDOWN_CALLBACK(self, arg1, arg2, checked)
    local command = strupper(self.value.Key)
    if      command == "START"  then SN_ItemTracker:Start()
    elseif  command == "STOP"   then SN_ItemTracker:Stop()
    elseif  command == "SHOW"   then SN_ItemList:Show()
    elseif  command == "RESET"  then SN_ItemTracker:Reset()
    end
end

local function CreateDropDownMenu(...)
    local s, level = ... 

    local options = {}
    options["Show"] = {}
    options["Reset"] = {}

    if SN_ItemTracker:IsRunning() then
        options["Stop"] = {}
    else
        options["Start"] = {}
    end

    UIHelper:CreateSimpleDropdownMenu(s, level, options, SN_MINIMAPBUTTON_DROPDOWN_CALLBACK, false) 
end

local function OnRightClick(...)
    local dropDown = CreateFrame("Frame", "DropDownValues", UIParent, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(dropDown, CreateDropDownMenu, "MENU")
    ToggleDropDownMenu(1, nil, dropDown, "cursor")
end

local function OnMinimapButtonClick(...)
    if ... then
        local s, button = ...
        if strupper(button) == "LEFTBUTTON" then
            SN_ItemList:Show() 
        else
            OnRightClick(...)
        end
    end 
end

local addon = LibStub("AceAddon-3.0"):NewAddon("SNLootCouncil", "AceConsole-3.0")
local SNLootCouncilLDB = LibStub("LibDataBroker-1.1"):NewDataObject("SNLootCouncil", {
    type = "data source",
    text = "SNLootCouncil",
    icon = "Interface\\Icons\\INV_Chest_Cloth_17",
    OnClick = function(...) OnMinimapButtonClick(...) end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: SNLootCouncilDB line in your TOC, duh! 
    self.db = LibStub("AceDB-3.0"):New("SNLootCouncilDB", { profile = { minimap = { hide = false, }, }, }) 
    icon:Register("SNLootCouncil", SNLootCouncilLDB, self.db.profile.minimap) 
end