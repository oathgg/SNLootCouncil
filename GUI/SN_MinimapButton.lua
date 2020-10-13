--SN_MinimapButton = {}

local addon = LibStub("AceAddon-3.0"):NewAddon("SNLootCouncil", "AceConsole-3.0")
local SNLootCouncilLDB = LibStub("LibDataBroker-1.1"):NewDataObject("SNLootCouncil", {
    type = "data source",
    text = "SNLootCouncil",
    icon = "Interface\\Icons\\INV_Chest_Cloth_17",
    OnClick = function() 
        SN_ItemList:Show() 
    end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: SNLootCouncilDB line in your TOC, duh! 
    self.db = LibStub("AceDB-3.0"):New("SNLootCouncilDB", { profile = { minimap = { hide = false, }, }, }) 
    icon:Register("SNLootCouncil", SNLootCouncilLDB, self.db.profile.minimap) 
    self:RegisterChatCommand("SNLootCouncil", "ButtonPressed") 
end

function addon:ButtonPressed() 
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
    
    if self.db.profile.minimap.hide then 
        icon:Hide("SNLootCouncil") 
    else 
        icon:Show("SNLootCouncil") 
    end 
end