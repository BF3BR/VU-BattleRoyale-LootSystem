require "__shared/Types/BRLootPickupDatabaseShared"

class ("BRLootPickupDatabase", BRLootPickupDatabaseShared)

function BRLootPickupDatabase:__init()
  BRLootPickupDatabaseShared.__init(self)

  self.m_InstanceIdToLootPickup = {}
end

function BRLootPickupDatabase:Add(p_LootPickup)
  if not BRLootPickupDatabaseShared.Add(self, p_LootPickup) then
    return
  end

  -- TODO add required refs to grid

  -- TODO handle spawn with a class method
	p_LootPickup:Spawn(p_DataArray.Id)
	if p_LootPickup.m_Entities == nil then
		return
	end

  -- map each entity spawned to the LootPickup
	for l_InstanceId, _ in pairs(p_LootPickup.m_Entities) do
		self.m_InstanceIdToLootPickup[l_InstanceId] = p_LootPickup
	end
end

function BRLootPickupDatabase:UpdateGridSubscriptions()
  -- TODO
end

return BRLootPickupDatabase()
