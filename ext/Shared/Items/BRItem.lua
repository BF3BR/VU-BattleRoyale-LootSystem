require "__shared/Enums/ItemEnums"
require "__shared/Utils/BRItemFactory"

local m_Logger = Logger("BRItem", true)

class "BRItem"

function BRItem:__init(p_Id, p_Definition, p_Quantity)
    -- Unique Id for each item
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- Item's definition
    self.m_Definition = p_Definition

    -- Item's quantity
    self.m_Quantity = p_Quantity ~= nil and p_Quantity or 1

    -- The LootPickup or Slot that contains the item
    self.m_Owner = nil
end

function BRItem:AsTable()
    local s_Table = {
        Id = self.m_Id,
        UId = self.m_Definition.m_UId,
    }

    -- add quantity if item is stackable
    if self.m_Definition.m_Stackable then
        s_Table.Quantity = self.m_Quantity
    end

    return s_Table
end

function BRItem:GetParentSlot()
    if self.m_Owner == nil or self.m_Owner.m_Item == nil then
        return nil
    end

    -- make sure the slots item equal this item
    return self:Equals(self.m_Owner.m_Item) and self.m_Owner or nil
end

function BRItem:GetParentInventory()
    local s_Slot = self:GetParentSlot()

    if s_Slot ~= nil then
        return s_Slot.m_Inventory
    end
end

function BRItem:GetParentPlayer()
    local s_Inventory = self:GetParentInventory()

    if s_Inventory ~= nil then
        return s_Inventory.m_Owner
    end
end

function BRItem:GetParentLootPickup()
    return (self.m_Owner ~= nil and self.m_Owner.m_Items ~= nil and self.m_Owner) or nil
end

function BRItem:CreateFromTable(p_Table)
    return g_BRItemFactory:CreateFromTable(p_Table)
end

function BRItem:Equals(p_Item)
    return p_Item ~= nil and p_Item.m_Id == self.m_Id
end

function BRItem:Destroy()
    
end
