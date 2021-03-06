local AceGUI = LibStub("AceGUI-3.0")
UIHelper = {}

function UIHelper:CreateTab(parent, title, width)
    local tab = AceGUI:Create("TabGroup")
    if width then
        tab:SetWidth(width)
    else
        tab:SetFullWidth(true)
    end
    tab:SetLayout("Flow")
    tab:SetTitle(title)
    parent:AddChild(tab)

    return tab
end

function UIHelper:CreateCheckBoxButton(parent, label, value, onClickCallback, width)
    local checkbox = AceGUI:Create("CheckBox")

    checkbox:SetLabel(label)
    checkbox:SetValue(value)

    checkbox:SetCallback("OnValueChanged", function (_,_,value) 
        onClickCallback(value)
    end)

    if width then
        checkbox:SetWidth(width)
    end

    parent:AddChild(checkbox)

    return checkbox
end

function UIHelper:CreateSettingsKeyCB(parent, label, settingsKey, width)
    UIHelper:CreateCheckBoxButton(parent, label, Settings:GetKey(settingsKey), function(value) 
        Settings:SetKeyValue(settingsKey, value)
    end, width)
end

function UIHelper:CreateSimpleDropdownMenu(self, level, menuItems, callback, hasDeleteOption)
    if hasDeleteOption == nil then -- because if we check if it's false then it will always be true...
        hasDeleteOption = true
    end
    level = level or 1;

    if (level == 1) then
        for key, subarray in pairs(menuItems) do
            local info = UIDropDownMenu_CreateInfo();
            info.notCheckable = true
            info.text = key;
            info.func = callback
            info.value = { 
                ["Key"] = key;
            };
            UIDropDownMenu_AddButton(info, level);
        end 

        if hasDeleteOption then
            -- Adding the "DELETE" button as the last one on the list
            local info = UIDropDownMenu_CreateInfo();
            info.notCheckable = true
            info.text = "Delete";
            info.func = callback
            info.value = { 
                ["Key"] = "Delete";
            };
            UIDropDownMenu_AddButton(info, level);
        end
    end 
end

function UIHelper:AddButtonToFrame(mainFrame, text, position, callback, width, height, xoff, yoff)
    local btn = AceGUI:Create("Button")
    btn:SetText(text)
    btn:SetCallback("OnClick", callback)
    if width then
        btn:SetWidth(width)
    end
    if height then
        btn:SetHeight(height)
    end
    mainFrame:AddChild(btn)
    btn:ClearAllPoints()
    btn:SetPoint(position,0,0)
end