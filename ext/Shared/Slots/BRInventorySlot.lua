class "BRInventorySlot"

function BRInventorySlot:__init(p_Inventory, p_AcceptedTypes)
    self.m_Item = nil
    self.m_Inventory = p_Inventory
    self.m_AcceptedTypes = p_AcceptedTypes or {}
    self.m_IsUpdated = true
end

-- Checks if the slot contains an item with the specified definition
function BRInventorySlot:IsOfDefinition(p_Definition)
    if self.m_Item ~= nil and self.m_Item.m_Definition:Equals(p_Definition) then
        return true
    end

    return false
end

-- Puts an item into the slot
function BRInventorySlot:Put(p_Item)
    -- TODO more checks + swap logic + more...
    -- check if invalid item for this slot
    if p_Item ~= nil and not self:IsAccepted(p_Item) then
        return false, {}
    end

    -- check if the item is already equipped
    if p_Item ~= nil and p_Item:Equals(self.m_Item) then
        return true, {}
    end

    -- drop old stuff
    local s_DroppedItems = self:Drop()

    -- set new item
    self.m_Item = p_Item
    self.m_IsUpdated = true

    -- trigger the update event
    self:OnUpdate()

    return true, s_DroppedItems
end

function BRInventorySlot:Clear()
    return self:Put(nil)
end

function BRInventorySlot:IsAccepted(p_Item)
    if p_Item == nil then
        return false
    end

    for _, l_Type in ipairs(self.m_AcceptedTypes) do
        if p_Item.m_Definition.m_Type == l_Type then
            return true
        end
    end

    return false
end

function BRInventorySlot:IsAvailable(p_Item)
    -- Check if type is not accepted
    if not self:IsAccepted(p_Item) then
        return false
    end

    -- Check if empty
    if self.m_Item == nil then
        return true
    end

    -- Check if item is stackable and slot contains same item type and has space
    if p_Item.m_Definition.m_Stackable and p_Item.m_Definition.m_MaxStack ~= nil and
        self.m_Item.m_Definition:Equals(p_Item.m_Definition) and
        self.m_Item.m_Quantity < p_Item.m_Definition.m_MaxStack then
        return true
    end

    return false
end

function BRInventorySlot:OnUpdate()
    -- Override
end

function BRInventorySlot:Drop()
    -- Override (if needed)
    if self.m_Item == nil then
        return {}
    end

    local s_Item = self.m_Item
    self.m_Item = nil

    return { s_Item }
end

function BRInventorySlot:Use()
    -- TODO
    print("TODO: Item used...")
    return {}
end

function BRInventorySlot:AsTable()
    return {Item = self.m_Item ~= nil and self.m_Item:AsTable() or nil}
end
