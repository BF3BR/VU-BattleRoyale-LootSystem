class "BRItemDatabase"

local m_Logger = Logger("BRItemDatabase", true)

function BRItemDatabase:__init()
    -- A table of items (id -> BRItem)
    self.m_Items = {}
end

-- All items should created using this methods from the database
-- to keep it's integrity
function BRItemDatabase:CreateItem(p_Definition, p_Quantity)
    p_Quantity = p_Quantity or 1

    local s_Id = self:GetRandomId()
    local s_Item = BRItem:CreateFromTable({
        Id = s_Id,
        Type = p_Definition.m_Type,
        UId = p_Definition.m_UId,
        Quantity = p_Quantity
    })

    self.m_Items[s_Id] = s_Item
    m_Logger:Write("Item added to database. (" .. s_Item.m_Definition.m_Name .. ")")

    return s_Item
end

function BRItemDatabase:RegisterItem(p_Item)
    if p_Item == nil then
        m_Logger:Write("Cannot register nil item.")
        return false
    end

    -- Check if item already exists
    if self.m_Items[p_Item.m_Id] ~= nil then
        m_Logger:Write("Item already exists in database. (" .. p_Item.m_Definition.m_Name .. ")")
        return false
    end

    self.m_Items[p_Item.m_Id] = p_Item
    m_Logger:Write("Item added to database. (" .. p_Item.m_Definition.m_Name .. ")")
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

    m_Logger:Write("Item removed from database. (" .. tostring(p_Id) .. ")")
end

function BRItemDatabase:GetRandomId()
    -- for now use the guid string
    return tostring(MathUtils:RandomGuid())
end

function BRItemDatabase:GetItem(p_Id)
    return self.m_Items[p_Id]
end

if g_BRItemDatabase == nil then
    g_BRItemDatabase = BRItemDatabase()
end

return g_BRItemDatabase
