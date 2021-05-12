class "BRItemDatabase"

function BRItemDatabase:__init()
    -- A table of items (id -> BRItem)
    self.m_Items = {}
end

function BRItemDatabase:AddItem(p_Item)
    -- Check if item already exists
    if self.m_Items[p_Item.Id] ~= nil then
        print("Item already exists in database. (" .. p_Item.Name .. ")")
        return false
    end

    self.m_Items[p_Item.Id] = p_Item
    print("Item added to database. (" .. p_Item.Name .. ")")
    return true
end

function BRItemDatabase:RemoveItem(p_Item)
    -- remove reference
    self.m_Items[p_Item.Id] = nil

    -- TODO maybe need to call some kind of :Destroy() for item
end

function BRItemDatabase:FindById(p_Id)
    return self.m_Items[p_Id]
end

function BRItemDatabase:IsEmpty()
    return next(self.m_Items) == nil
end

if g_BRItemDatabase == nil then
	g_BRItemDatabase = BRItemDatabase()
end

return g_BRItemDatabase
