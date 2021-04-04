require "__shared/Items/BRItem"

local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"

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
    -- TODO
end

function BRItemArmor:CreateFromTable(p_Table)
    return BRItemArmor(p_Table.Uid, m_ArmorDefinitions[p_Table.Name], p_Table.CurrentDurability)
end

--==============================
-- Armor related functions
--==============================

-- Applies damage to the armor. Returns the damage passed through.
-- @param p_Damage number
function BRItemArmor:ApplyDamage(p_Damage)
    -- check if armor is fully damaged
    if self.m_CurrentDurability <= 0 then
        return p_Damage
    end

    -- calculate damage
    local s_DamageToArmor = p_Damage * self.m_Definition.DamageReduction
    local s_DamagePassed = p_Damage - s_DamageToArmor

    -- update armor durability
    self.m_CurrentDurability = self.m_CurrentDurability - s_DamageToArmor
    if self.m_CurrentDurability < 0 then
        s_DamagePassed = s_DamagePassed + math.abs(self.m_CurrentDurability)
        self.m_CurrentDurability = 0
    end

    return s_DamagePassed
end

-- Returns the current percentage of the armor
function BRItemArmor:GetPercentage()
    if self.m_Definition.Durability <= 0 then
        return 0
    end

    return math.floor((self.m_CurrentDurability / self.m_Definition.Durability) * 100)
end
