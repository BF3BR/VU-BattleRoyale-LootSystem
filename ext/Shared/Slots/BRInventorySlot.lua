class "BRInventorySlot"

function BRInventorySlot:__init(p_AcceptedTypes)
    self.m_Item = nil
    self.m_AcceptedTypes = p_AcceptedTypes or {}
end

function BRInventorySlot:PutItem(p_Item)
    -- TODO more checks + swap logic + more...
    if not self:IsAccepted(p_Item) then
        return false, {}
    end

    local s_DroppedItems = self:Drop()
    self.m_Item = p_Item

    self:OnUpdate()

    return true, s_DroppedItems
end

function BRInventorySlot:IsAccepted(p_Item)
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
    -- TODO
    return {}

    -- local s_Item = self.m_Item
    -- self.m_Item = nil

    -- return {s_Item}
end

function BRInventorySlot:AsTable()
    return {Item = self.m_Item ~= nil and self.m_Item:AsTable() or nil}
end
