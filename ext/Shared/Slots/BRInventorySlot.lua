class "BRInventorySlot"

function BRInventorySlot:__init(p_AcceptedTypes)
  self.m_Item = nil
  self.m_AcceptedTypes = p_AcceptedTypes or {}
end

function BRInventorySlot:IsAccepted(p_Item)
  for _, l_Type in ipairs(self.m_AcceptedTypes) do
    if p_Item.m_Definition.m_Type == l_Type then
      return true
    end
  end

  return false
end
