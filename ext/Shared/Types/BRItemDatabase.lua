class "BRItemDatabase"

function BRItemDatabase:__init()
    -- A table of items
    self.m_Items = {}
end

function BRItemDatabase:AddItem(p_Item)
    -- Check if item already exists
    if self:FindById(p_Item.Id) then
        print("Item already exists.")
        return false
    end
    
    table.insert(self.m_Items, p_Item:AsTable())
    return true
end

function BRItemDatabase:RemoveItem(p_Item)
    if #self.m_Items == 0 then
        return
    end

    for l_Index, l_Item in pairs(self.m_Items) do
        if l_Item.Id == p_Item.Id then
            table.remove(self.m_Items, l_Index)
            return
        end
    end
end

function BRItemDatabase:FindById(p_Id)
    if #self.m_Items == 0 then
        return nil
    end

    for l_Index, l_Item in pairs(self.m_Items) do
        if l_Item.Id == p_Id then
            return l_Item
        end
    end

    return nil
end
