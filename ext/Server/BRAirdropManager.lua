class "BRAirdropManager"

require "__shared/Enums/CustomEvents"

local m_Logger = Logger("BRAirdropManager", true)

local m_MapHelper = require "__shared/Utils/MapHelper"

function BRAirdropManager:__init()
    self:RegisterVars()
end

function BRAirdropManager:RegisterVars()
    self.m_AirdropTimers = {}
    self.m_AirdropHandles = {}
end


function BRAirdropManager:CreateAirdrop(p_Trans)
    if p_Trans == nil then
        return
    end

    local s_Bp = ObjectBlueprint(
        ResourceManager:SearchForInstanceByGuid(Guid("261E43BF-259B-BF3B-41D2-0000BBBDBBBF"))
    )

    local s_CreationParams = EntityCreationParams()
    s_CreationParams.transform = p_Trans
    s_CreationParams.networked = true

    local s_CreatedBus = EntityManager:CreateEntitiesFromBlueprint(s_Bp, s_CreationParams)
    
    if s_CreatedBus == nil then
        m_Logger:Write("CreatedBus is nil for the Airdrop.")
        return
    end

    for _, l_Entity in pairs(s_CreatedBus.entities) do
        l_Entity:Init(Realm.Realm_ClientAndServer, true)
        local l_PhysicsEntity = PhysicsEntity(l_Entity)
        local l_CollisionCallback = l_PhysicsEntity:RegisterCollisionCallback(function(p_Entity, p_CollisionInfo)
            if p_CollisionInfo.entity.typeInfo.name == "ServerSoldierEntity" then
                return
            end

            if self.m_AirdropTimers[p_Entity.instanceId] ~= nil then
                self.m_AirdropTimers[p_Entity.instanceId]:Destroy()
            end

            local s_Table = {
                transform = SpatialEntity(p_Entity).transform,
                entity = p_Entity,
                handle = self.m_AirdropHandles,
            }

            self.m_AirdropTimers[p_Entity.instanceId] = g_Timers:Timeout(2.0, s_Table, function(p_Table)
                -- print(p_Table.transform)

                -- TODO: Spawn loot
                -- lvl 3 armor
                -- lvl 3 helmet
                -- lvl 3 randomized weapon with attachment and 2 -3 ammo
                -- Large medkit

                if p_Table.handle[p_Table.entity.instanceId] ~= nil then
                    local s_PhysicsEntity = PhysicsEntity(p_Table.entity)
                    s_PhysicsEntity:UnregisterCollisionCallback(p_Table.handle[s_PhysicsEntity.instanceId])
                end
            end)
        end)

        self.m_AirdropHandles[l_PhysicsEntity.instanceId] = l_CollisionCallback
    end
end

-- define global
if g_BRAirdropManager== nil then
    g_BRAirdropManager = BRAirdropManager()
end

return g_BRAirdropManager
