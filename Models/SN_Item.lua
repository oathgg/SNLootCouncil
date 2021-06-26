SN_Item = {}
if SAVED_ALL_ITEMS == nil then SAVED_ALL_ITEMS = {} end

function SN_Item:New(itemName, itemLink)
    local internalItemId = table.getn(SAVED_ALL_ITEMS) + 1 or 1

    local itemLinkSplit = { strsplit(":", itemLink) }
    local wowItemID = itemLinkSplit[2] or 0
    SAVED_ALL_ITEMS[internalItemId] = { ItemID = wowItemID, Name = itemName, Owner = nil }

    return internalItemId
end

function SN_Item:Delete(internalItemId)
    SAVED_ALL_ITEMS[internalItemId] = nil
end

function SN_Item:AssignOwner(internalItemId, ownerName)
    if SAVED_ALL_ITEMS[internalItemId] then
        SAVED_ALL_ITEMS[internalItemId].Owner = ownerName
    end
end

function SN_Item:GetAllItems()
    return SAVED_ALL_ITEMS
end

function SN_Item:Get(internalItemId)
    return SAVED_ALL_ITEMS[internalItemId]
end

function SN_Item:GetItemByNameWithoutOwner(name)
    for k, item in pairs(SAVED_ALL_ITEMS) do
        if item.Name == name and (item.Owner == nil or item.Owner == "") then
            return k
        end
    end
end

function SN_Item:GetItemByNameWithMyselfAsOwner(name)
    for k, item in pairs(SAVED_ALL_ITEMS) do
        if item.Name == name and item.Owner == UnitName("player") then
            return k
        end
    end
end

function SN_Item:Reset()
    SN:PrintMsg("Cleared item list")
    SAVED_ALL_ITEMS = {}
end