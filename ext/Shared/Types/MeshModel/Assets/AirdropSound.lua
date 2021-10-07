class("AirdropSound")

function AirdropSound:__init()
end

function AirdropSound:Draw(p_Transform)
    local s_Data = EntityManager:CreateEntitiesFromBlueprint(
        m_Airdrop_Object_SFX:GetInstance(),
        p_Transform
    )
    
    if s_Data ~= nil then
        local s_Entities = {}
        for _, l_Entity in pairs(s_Data.entities) do
            l_Entity:Init(Realm.Realm_Client, false)
            l_Entity:FireEvent("Start")
            s_Entities[l_Entity.instanceId] = l_Entity
        end
        return s_Entities
    end

    return nil
end

-- define global
if g_AirdropSound == nil then
    g_AirdropSound = AirdropSound()
end

return g_AirdropSound
