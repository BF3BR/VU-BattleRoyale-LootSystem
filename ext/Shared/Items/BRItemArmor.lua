require "__shared/Items/BRItem"

m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"

class("BRItemArmor", BRItem)

function BRItemArmor:__init(p_Uid, p_ArmorDefinition, p_CurrentDurability)
    BRItem.__init(self, p_Uid, p_ArmorDefinition)

    self.m_CurrentDurability = p_CurrentDurability or p_ArmorDefinition.m_Durability
end

function BRItemArmor:AsTable()
    local s_Table = BRItem.AsTable(self)

    s_Table.CurrentDurability = self.m_CurrentDurability

    return s_Table
end

function BRItemArmor:UpdateFromTable()
end

function BRItemArmor:CreateFromTable(p_Table)
    return BRItemArmor(p_Table.Uid, m_ArmorDefinitions[p_Table.Name], p_Table.CurrentDurability)
end


--==============================
-- Armor related functions
--==============================

function BRItemArmor:OnDamage()
    -- TODO
end
