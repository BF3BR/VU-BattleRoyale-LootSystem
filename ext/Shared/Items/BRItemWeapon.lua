require "__shared/Items/BRItem"

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

class("BRItemWeapon", BRItem)

function BRItemWeapon:__init(p_Uid, p_Definition)
    BRItem.__init(self, p_Uid, p_Definition)
end

function BRItemWeapon:AsTable()
    return BRItem.AsTable(self)
end

function BRItemWeapon:UpdateFromTable()
    -- Do we need this?
end

function BRItemWeapon:CreateFromTable(p_Table)
    return BRItemWeapon(p_Table.Uid, m_WeaponDefinitions[p_Table.Name])
end

--==============================
-- Weapon related functions
--==============================
