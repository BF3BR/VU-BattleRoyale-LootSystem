class "BRItemDatabase"

function BRItemDatabase:__init()
    -- A table of items (id -> BRItem)
    self.m_Items = {}
end

function BRItemDatabase:RegisterItem(p_Item)
    if p_Item == nil then
        print("Cannot register nil item.")
        return false
    end

    -- Check if item already exists
    if self.m_Items[p_Item.m_Id] ~= nil then
        print("Item already exists in database. (" .. p_Item.m_Definition.m_Name .. ")")
        return false
    end

    self.m_Items[p_Item.m_Id] = p_Item
    print("Item added to database. (" .. p_Item.m_Definition.m_Name .. ")")
    return true
end

function BRItemDatabase:UnregisterItem(p_Id)
    if p_Id == nil then
        return
    end

    if self.m_Items[p_Id] == nil then
        return
    end

    self.m_Items[p_Id] = nil

    print("Item removed from database. (" .. tostring(p_Id) .. ")")
end

function BRItemDatabase:GetItem(p_Id)
    return self.m_Items[p_Id]
end

if g_BRItemDatabase == nil then
    g_BRItemDatabase = BRItemDatabase()
end

return g_BRItemDatabase
