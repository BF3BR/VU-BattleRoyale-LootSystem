require "__shared/Items/BRItem"

local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"

class("BRItemHelmet", BRItem)

function BRItemHelmet:__init(p_Id, p_Definition, p_CurrentDurability)
    BRItem.__init(self, p_Id, p_Definition, 1)

    self.m_CurrentDurability = p_CurrentDurability or p_Definition.m_Durability
end

function BRItemHelmet:AsTable()
    local s_Table = BRItem.AsTable(self)

    s_Table.CurrentDurability = self.m_CurrentDurability

    return s_Table
end

function BRItemHelmet:CreateFromTable(p_Table)
    return BRItemHelmet(p_Table.Id, m_ArmorDefinitions[p_Table.Name], p_Table.CurrentDurability)
end

--==============================
-- Armor related functions
--==============================

-- Applies damage to the armor. Returns the damage passed through.
-- @param p_Damage number
function BRItemHelmet:ApplyDamage(p_Damage)
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
function BRItemHelmet:GetPercentage()
    if self.m_Definition.Durability <= 0 then
        return 0
    end

    return math.ceil((self.m_CurrentDurability / self.m_Definition.Durability) * 100)
end
