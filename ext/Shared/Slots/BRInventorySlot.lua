class "BRInventorySlot"

function BRInventorySlot:__init(p_AcceptedTypes)
    self.m_Item = nil
    self.m_AcceptedTypes = p_AcceptedTypes or {}
end

function BRInventorySlot:PutItem(p_Item)
    -- TODO more checks + swap logic + more...
    if not self:IsAccepted(p_Item) then
        return {false, {}}
    end

    local s_DroppedItems = self:Drop()
    self.m_Item = p_Item

    return {true, s_DroppedItems}
end

function BRInventorySlot:IsAccepted(p_Item)
    for _, l_Type in ipairs(self.m_AcceptedTypes) do
        if p_Item.m_Definition.m_Type == l_Type then
            return true
        end
    end

    return false
end

function BRInventorySlot:Clear()
    self.m_Item = nil
end

function BRInventorySlot:Drop()
    local s_Item = self.m_Item
    self:Clear()

    return {s_Item}
end

function BRInventorySlot:AsTable()
    return {
        Item = self.m_Item ~= nil and self.m_Item:AsTable() or nil,
        AcceptedTypes = self.m_AcceptedTypes
    }
end
