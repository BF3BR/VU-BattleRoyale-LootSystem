require "__shared/Enums/ItemEnums"

class "BRItem"

function BRItem:__init(p_Uid, p_Definition)
    -- Unique ID for each item
    self.m_Uid = p_Uid

    -- Item's definition
    self.m_Definition = p_Definition
end

function BRItem:FromTable(p_Table)
    return BRItem()
end

function BRItem:AsTable()
    return {
        Uid = self.m_Uid,
        Type = self.m_Definition.m_Type,
        Name = self.m_Definition.m_Name
    }
end

-- p_Table.Uid
-- p_Table.Type
-- p_Table.Name
-- p_Table.Durability
function BRItem:CreateFromTable(p_Table)
    if self.m_Definition.m_Type == ItemType.Armor then
        return BRItemArmor:CreateFromTable(p_Table)
    end
end
