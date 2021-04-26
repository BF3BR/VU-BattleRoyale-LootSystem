require "__shared/Items/BRItem"

local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"

class("BRItemConsumable", BRItem)

function BRItemConsumable:__init(p_Definition)
    BRItem.__init(self, p_Definition)
end

function BRItemConsumable:AsTable()
    return BRItem.AsTable(self)
end

function BRItemConsumable:CreateFromTable(p_Table)
    return BRItemConsumable(p_Table.Id, m_ConsumableDefinitions[p_Table.Name])
end

--==============================
-- Consumable related functions
--==============================
