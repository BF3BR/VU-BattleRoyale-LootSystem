require "__shared/Items/BRItem"

local m_GadgetDefinitions = require "__shared/Items/Definitions/BRItemGadgetDefinition"

class("BRItemGadget", BRItem)

function BRItemGadget:__init(p_Id, p_Definition, p_Quantity)
    BRItem.__init(self, p_Id, p_Definition, p_Quantity)
end

function BRItemGadget:CreateFromTable(p_Table)
    return BRItemGadget(p_Table.Id, m_GadgetDefinitions[p_Table.UId], p_Table.Quantity)
end

--==============================
-- Gadget related functions
--==============================
