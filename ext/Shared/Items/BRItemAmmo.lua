require "__shared/Items/BRItem"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"

class("BRItemAmmo", BRItem)

function BRItemAmmo:__init(p_Uid, p_Definition)
    BRItem.__init(self, p_Uid, p_Definition)
end

function BRItemAmmo:AsTable()
    return BRItem.AsTable(self)
end

function BRItemAmmo:CreateFromTable(p_Table)
    return BRItemAmmo(p_Table.Uid, m_AmmoDefinitions[p_Table.Name])
end

--==============================
-- Ammo related functions
--==============================
