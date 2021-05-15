class "BRLootPickupDatabase"

local m_Logger = Logger("BRLootPickupDatabase", true)

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
    if self.m_LootPickups[p_LootPickup.m_Id] ~= nil then
        m_Logger:Write("Loot pickup already spawned.")
        return
    end

    self.m_LootPickups[p_LootPickup.m_Id] = p_LootPickup

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
    if self.m_SpawnedEntities[p_LootPickup.m_Id] ~= nil then
        return
    end

    local s_LootPickupMesh = p_LootPickup:GetMesh()
	if s_LootPickupMesh == nil then
		m_Logger:Write("Couldn't find loot pickup mesh.")
		return
    end
    
	local s_Params = EntityCreationParams()
	s_Params.transform = p_LootPickup.m_Transform
	s_Params.networked = false

    local s_Bus = EntityManager:CreateEntitiesFromBlueprint(s_LootPickupMesh, s_Params)
    if s_Bus ~= nil then
        for _, l_Entity in pairs(s_Bus.entities) do
            l_Entity:Init(Realm.Realm_ClientAndServer, true)
        end

        self.m_SpawnedEntities[p_LootPickup.m_Id] = s_Bus
    else
		prm_Logger:Writeint("Couldn't spawn loot pickup.")
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
