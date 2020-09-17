SN_ItemList = {}

local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil
local scroll = nil
local tableContent = nil
local selectedLine = nil
local previousColumnSortIdx = 0

local function BuildTableContent()
    tableContent = {}

    for internalItemId, values in pairs(SN_Item:GetAllItems()) do
        table.insert(tableContent, { internalItemId, values.Name, values.Owner })
    end
end

local function SN_ITEMLIST_DROPDOWN_CALLBACK(self, arg1, arg2, checked)
    if self.value.Key == "Assign Owner" then
        SN_ItemOwner:New(selectedLine.InternalItemId)
    elseif self.value.Key == "Delete" then
        SN:PrintMsg("Removing "..selectedLine.ItemName)
        SN_Item:Delete(selectedLine.InternalItemId)
        SN_ItemList:ForceUpdate()
    else
        SN_Item:AssignOwner(selectedLine.InternalItemId, self.value.Key)
        SN_ItemList:ForceUpdate()
    end
end

local function Update()
    local buttons = HybridScrollFrame_GetButtons(scroll)
    local maxRecords = table.getn(buttons)
    local rowCount = table.getn(tableContent)
    local scrollOffset = HybridScrollFrame_GetOffset(scroll)

    for index = 1, maxRecords do
        local curRowIndex = index + scrollOffset
        if curRowIndex > rowCount then
            local b = buttons[index]
            if b then
                b.Name:SetText(nil)
                b.Owner:SetText(nil)
            end
            break
        end

        local internalItemId, itemName, owner = unpack(tableContent[curRowIndex])
        local button = buttons[index]
        button.Name:SetText(itemName)
        button.Owner:SetText(owner)

        -- https://wowwiki.fandom.com/wiki/UIHANDLER_OnClick
        button:RegisterForClicks("AnyUp")
        button:SetScript("OnClick", function (self, button)
            local dropDown = CreateFrame("Frame", "DropDownValues", UIParent, "UIDropDownMenuTemplate")
            dropDown:Hide()

            selectedLine = { InternalItemId = internalItemId, ItemName = itemName }

            -- Check if we don't exceed our bounds before applying button functionality
            if curRowIndex <= table.getn(tableContent) then
                if button == "RightButton" then
                    UIDropDownMenu_Initialize(dropDown, function(...)
                        local s, level = ... 

                        local options = {
                            ["Assign Owner"] = {},
                            ["Disenchant"] = {},
                            ["Guild bank"] = {},
                        }

                        UIHelper:CreateDropdownMenu(s, level, options, SN_ITEMLIST_DROPDOWN_CALLBACK) 
                    end, "MENU")
                    ToggleDropDownMenu(1, nil, dropDown, "cursor")
                end
            end
        end)
        button:Show()
    end
    
    local buttonHeight = scroll.buttonHeight;
	local totalHeight = rowCount * buttonHeight;
	local shownHeight = maxRecords * buttonHeight;

	HybridScrollFrame_Update(scroll, totalHeight, shownHeight);
end

local function CreateTableHeader()
    local header = TableHelper:CreateHeader(mainFrame)

    TableHelper:CreateColumns(header, { 
        { "Name", 200 }, 
        { "Owner", 250 },
    }, nil)

    return header
end

local function CreateTable()
    local tableHeader = CreateTableHeader()
    tableContentGroup = AceGUI:Create("SimpleGroup")
	tableContentGroup:SetFullWidth(true)
	tableContentGroup:SetHeight(390)
	tableContentGroup:SetLayout("Fill")
	mainFrame:AddChild(tableContentGroup)
	tableContentGroup:ClearAllPoints()
	tableContentGroup.frame:SetPoint("TOP", tableHeader.frame, "BOTTOM", 0, -5)
    tableContentGroup.frame:SetPoint("BOTTOM", 0, 20)
    scroll = TableHelper:AddScroll(tableContentGroup, "SN_ItemListFrameHistory", "SN_ItemListFrameTemplate", function() 
        SN_ItemList:ForceUpdate() 
    end)
end

local function CreateGUI()
    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["AAAA_ItemList"] = mainFrame
    tinsert(UISpecialFrames, "AAAA_ItemList")	-- allow ESC close
    mainFrame:SetWidth(500)
    mainFrame:SetTitle("Item List")
    mainFrame:EnableResize(false)

    local reportBtn = AceGUI:Create("Button")
    reportBtn:SetText("Report")
    reportBtn:SetRelativeWidth(0.30)
    reportBtn:SetCallback("OnClick", function() SN_ItemList:Report() end)
    mainFrame:AddChild(reportBtn)

    CreateTable()
end

function SN_ItemList:ForceUpdate()
    if mainFrame then
        BuildTableContent()
        Update()
    end
end

function SN_ItemList:IsShown()
    if (mainFrame ~= nil) then
        return mainFrame:IsShown()
    else
        return false
    end
end

function SN_ItemList:Show()
    if (not SN_ItemList:IsShown()) then
        BuildTableContent()
        previousColumnSortIdx = 0
        CreateGUI()
        mainFrame:Show()
        Update()
    else
        mainFrame:Hide()
        mainFrame = nil
    end
end

function SN_ItemList:Add(itemName)
    SN_Item:New(itemName)
    SN_ItemList:ForceUpdate()
end

function SN_ItemList:Reset()
    StaticPopupDialogs["RESET"] = {
        text = "Do you want to perform a reset?", button1 = "Yes", button2 = "No",
        OnAccept = function()
            SN_Item:Reset()

            -- Fast way of reloading the entire UI without much hassle, shit code, but whatever.
            mainFrame:Hide()
            mainFrame = nil
        end,
    }
    StaticPopup_Show("RESET");
end

function SN_ItemList:Report()
    SN:PrintMsg("Generating report...")
    SN_Report:Show()
end