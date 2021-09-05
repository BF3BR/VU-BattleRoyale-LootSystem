class "BRLootPickupDatabaseShared"

function BRLootPickupDatabaseShared:__init()
  self:ResetVars()
end

function BRLootPickupDatabaseShared:ResetVars()
  -- A map of LootPickups {id -> LootPickup}
  self.m_LootPickups = {}
end

function BRLootPickupDatabase:GetById(p_Id)
  return self.m_LootPickups[p_Id]
end

function BRLootPickupDatabase:Add(p_LootPickup)
  if p_LootPickup == nil or self:Contains(p_LootPickup) then
    return false
  end

  self.m_LootPickups[p_LootPickup.m_Id] = p_LootPickup
  return true
end

function BRLootPickupDatabase:Remove(p_LootPickup)
  if p_LootPickup == nil or not self:Contains(p_LootPickup) then
    return false
  end

  self.m_LootPickups[p_LootPickup.m_Id] = nil
  return true
end

function BRLootPickupDatabaseShared:Contains(p_LootPickup)
  return self.m_LootPickups[p_LootPickup.m_Id] ~= nil
end

function BRLootPickupDatabaseShared:OnRoundDestroy()
  self:ResetVars()
end
