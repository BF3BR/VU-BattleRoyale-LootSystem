require "__shared/Enums/ItemEnums"
require "__shared/Utils/BRItemFactory"

class "BRItem"

function BRItem:__init(p_Id, p_Definition, p_Quantity)
    -- Unique Id for each item
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- Item's definition
    self.m_Definition = p_Definition

    -- Item's quantity
    self.m_Quantity = p_Quantity ~= nil and p_Quantity or 1
end

function BRItem:AsTable()
    local s_Table = {
        Id = self.m_Id,
        Type = self.m_Definition.m_Type,
        UId = self.m_Definition.m_UId,
    }

    if self.m_Definition.m_Stackable then
        s_Table.Quantity = self.m_Quantity
    end

    return s_Table
end

function BRItem:CreateFromTable(p_Table)
    return g_BRItemFactory:CreateFromTable(p_Table)
end
