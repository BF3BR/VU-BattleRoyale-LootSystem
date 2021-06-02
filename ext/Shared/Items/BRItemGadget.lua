require "__shared/Items/BRItem"

local m_GadgetDefinitions = require "__shared/Items/Definitions/BRItemGadgetDefinition"

class("BRItemGadget", BRItem)

function BRItemGadget:__init(p_Id, p_Definition, p_Quantity, p_CurrentPrimaryAmmo)
    BRItem.__init(self, p_Id, p_Definition, p_Quantity)

    self.m_CurrentPrimaryAmmo = p_CurrentPrimaryAmmo or 0
end

function BRItemGadget:AsTable()
    local s_Table = BRItem.AsTable(self)

    s_Table.CurrentPrimaryAmmo = self.m_CurrentPrimaryAmmo

    return s_Table
end

function BRItemGadget:CreateFromTable(p_Table)
    return BRItemGadget(p_Table.Id, m_GadgetDefinitions[p_Table.UId], p_Table.Quantity, p_Table.CurrentPrimaryAmmo)
end

--==============================
-- Gadget related functions
--==============================
