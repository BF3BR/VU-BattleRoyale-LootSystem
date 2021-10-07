class("AirdropSmoke")

function AirdropSmoke:__init()
end

function AirdropSmoke:Draw(p_Transform)
    local s_Data = EntityManager:CreateEntitiesFromBlueprint(
        m_Airdrop_Object_FX_Smoke:GetInstance(), 
        LinearTransform(
            p_Transform.left,
            p_Transform.up,
            p_Transform.forward,
            Vec3(
                p_Transform.trans.x,
                p_Transform.trans.y + 1.35,
                p_Transform.trans.z
            )
        )
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
if g_AirdropSmoke == nil then
    g_AirdropSmoke = AirdropSmoke()
end

return g_AirdropSmoke
