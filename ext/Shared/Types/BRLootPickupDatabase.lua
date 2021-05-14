class "BRLootPickupDatabase"

-- This is gonna get replaced with the Spatial index, probably

function BRLootPickupDatabase:__init()
    -- A table of items (id -> BRLootPickup)
    self.m_LootPickups = {}

    -- A table of enitites (id -> EntityBus)
    self.m_SpawnedEntities = {}
end

function BRLootPickupDatabase:RegisterLootPickup(p_LootPickup)
    if p_LootPickup == nil then
        return
    end

    -- Check if loot pickup already exists
    if self.m_LootPickups[p_LootPickup.Id] ~= nil then
        print("Loot pickup already spawned.")
        return
    end

    self.m_LootPickups[p_LootPickup.Id] = p_LootPickup

    self:Spawn(p_LootPickup)
end

function BRLootPickupDatabase:UnregisterLootPickup(p_LootPickupId)
    if p_LootPickupId == nil then
        return
    end

    if self.m_LootPickups[p_LootPickupId] == nil then
        return
    end

    self.m_LootPickups[p_LootPickupId] = nil

    self:Destory(p_LootPickupId)
end

function BRLootPickupDatabase:Spawn(p_LootPickup)
    if self.m_SpawnedEntities[p_LootPickup.Id] ~= nil then
        return
    end

	if p_LootPickup.Mesh == nil then
		print("Couldn't find loot pickup blueprint.")
		return
    end
    
	local s_Params = EntityCreationParams()
	s_Params.transform = p_LootPickup.Transform
	s_Params.networked = false

    local s_Bus = EntityManager:CreateEntitiesFromBlueprint(p_LootPickup.Mesh, s_Params)
    if s_Bus ~= nil then
        for _, l_Entity in pairs(s_Bus.entities) do
            l_Entity:Init(Realm.Realm_ClientAndServer, true)
        end

        self.m_SpawnedEntities[p_LootPickup.Id] = s_Bus
    else
		print("Couldn't spawn loot pickup.")
	end
end

function BRLootPickupDatabase:Destory(p_LootPickupId)
    if self.m_SpawnedEntities[p_LootPickupId] == nil then
        return
    end

    for _, l_Entity in pairs(self.m_SpawnedEntities[p_LootPickupId].entities) do
        l_Entity:Destroy()
    end
end
