require "__shared/Items/BRItem"

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

class("BRItemWeapon", BRItem)

function BRItemWeapon:__init(p_Id, p_Definition)
    BRItem.__init(self, p_Id, p_Definition, 1)
end

function BRItemWeapon:CreateFromTable(p_Table)
    return BRItemWeapon(p_Table.Id, m_WeaponDefinitions[p_Table.Name])
end

--==============================
-- Weapon related functions
--==============================
