class "BRLootPickupDatabaseShared"

function BRLootPickupDatabaseShared:__init()
  self:ResetVars()
end

function BRLootPickupDatabaseShared:ResetVars()
  -- A map of LootPickups {id -> LootPickup}
  self.m_LootPickups = {}

  -- A map of GridCells used for proximity looting
  self.m_Grid = BRLootGrid(32)
end

function BRLootPickupDatabase:GetById(p_Id)
  return self.m_LootPickups[p_Id]
end

function BRLootPickupDatabase:Add(p_LootPickup)
  if p_LootPickup == nil or self:Contains(p_LootPickup) then
    return false
  end

  -- add to lootpickups
  self.m_LootPickups[p_LootPickup.m_Id] = p_LootPickup

  -- add to grid cell
  self.m_Grid:AddLootPickup(p_LootPickup)

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

function BRLootPickupDatabaseShared:GetCloseItems(p_Position, p_Radius)
  -- TODO
  return {}
end

function BRLootPickupDatabaseShared:GetClosestItem(p_Position, p_Radius)
  local s_Items = self:GetCloseItems(p_Position, p_Radius)

  -- return the item at first index in case the items returned 
  -- are empty or only have one item
  if #s_Items < 2 then
    return s_Items[1]
  end

  -- find the closest item
  local s_ClosestItem = s_Items[1]
  local s_ClosestDistance = p_Position:Distance(Vec2(0, 0)) -- TODO
  for l_Index = 2, #s_Items do
    local s_Item = s_Items[l_Index]
    -- local s_Distance = p_Position:Distance(s_Item:GetPosition2D()) -- TODO
    local s_Distance = p_Position:Distance(Vec2(0, 0))

    if s_Distance < s_ClosestDistance then
      s_ClosestItem = s_Item
      s_ClosestDistance = s_Distance
    end
  end

  return s_ClosestItem
end

function BRLootPickupDatabaseShared:OnRoundDestroy()
  self:ResetVars()
end
