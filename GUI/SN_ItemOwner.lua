local AceGUI = LibStub("AceGUI-3.0")

SN_ItemOwner = {}
SN_ItemOwner["HasFrameActive"] = false
local window = nil

local function Save(internalItemId, text)
    SN_Item:AssignOwner(internalItemId, text)
    SN_ItemList:ForceUpdate()

    window:Hide()
    SN_ItemOwner["HasFrameActive"] = false;
end

function SN_ItemOwner:New(internalItemId)
    if SN_ItemOwner["HasFrameActive"] then
        window:Hide()
    end

    local item = SN_Item:Get(internalItemId)

    if item then
        SN_ItemOwner["HasFrameActive"] = true;
        window = AceGUI:Create("Window", UIParent)
        window:Hide()
        _G["SN_SN_ItemOwner"] = window
        tinsert(UISpecialFrames, "SN_SN_ItemOwner")	-- allow ESC close
        window:SetWidth(400)
        window:SetHeight(110)
        window:SetTitle("Assign owner to "..item.Name)
        window:EnableResize(false)
        
        local editbox = AceGUI:Create("EditBox")
        editbox:SetLabel("Owner")
        editbox:SetFullWidth(true)
        if item.Owner then
            editbox:SetText(item.Owner)
        end
        editbox:SetFocus()
        editbox:HighlightText()
        editbox:SetCallback("OnEnterPressed", function(text) 
            Save(internalItemId, editbox.lasttext)
        end)
        window:AddChild(editbox)

        local saveBtn = AceGUI:Create("Button")
        saveBtn:SetText("Save")
        saveBtn:SetRelativeWidth(0.20)
        saveBtn:SetCallback("OnClick", function() 
            Save(internalItemId, editbox.lasttext)
        end)
        window:AddChild(saveBtn)
        window:Show()
    end
end