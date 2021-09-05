class "BRLootGridCell"

function BRLootGridCell:__init()
  self.m_LootPickups = {}
  self.m_Subscribers = {}
end

function BRLootGridCell:AddLootPickup(p_LootPickup)
  self.m_LootPickups[p_LootPickup.m_Id] = p_LootPickup
  -- p_LootPickup.m_ParentCell = self
end

function BRLootGridCell:RemoveLootPickup()
  self.m_LootPickups[p_LootPickup.m_Id] = nil
  -- p_LootPickup.m_ParentCell = nil
end

function BRLootGridCell:SendState()
  
end

function BRLootGridCell:Destroy()
  self.m_LootPickups = nil
  self.m_Subscribers = nil
end
