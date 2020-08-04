SN_Item = {}
if SAVED_ALL_ITEMS == nil then SAVED_ALL_ITEMS = {} end

function SN_Item:New(itemName)
    local internalItemId = table.getn(SAVED_ALL_ITEMS) + 1 or 1

    SAVED_ALL_ITEMS[internalItemId] = { Name = itemName, Owner = nil }

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

function SN_Item:Reset()
    SAVED_ALL_ITEMS = {}
end