class "BRLootPickup"

require "__shared/Utils/ArmorSkeletonHelper"

local m_Logger = Logger("BRLootPickup", true)
local m_RotationHelper = require "__shared/Utils/RotationHelper"


function BRLootPickup:__init(p_Id, p_Type, p_Transform, p_Items)
    -- Unique Id for each loot pickup
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- ItemEnums - LootPickupType
    self.m_Type = p_Type

    -- Transform of the pickup
    self.m_Transform = p_Transform

    -- A table of items
    self.m_Items = p_Items

    -- [Client] Contains spawned entities {instanceId -> Entity}
    self.m_Entities = nil
end

function BRLootPickup:GetMesh()
    if #self.m_Items == 1 then
        -- If there is only one item then use its mesh
        return self.m_Items[1].m_Definition.m_Mesh
    elseif self.m_Type.Mesh ~= nil then
        -- If there is a mesh set to the current type
        return self.m_Type.Mesh
    end

    return nil
end

function BRLootPickup:GetLinearTransform()
    if #self.m_Items == 1 then
        -- If there is only one item then use its LT
        return self.m_Items[1].m_Definition.m_Transform
    elseif self.m_Type.Mesh ~= nil then
        -- If there is a LT set to the current type
        return self.m_Type.Transform
    end

    return LinearTransform(
        Vec3(1, 0, 0),
        Vec3(0, 1, 0),
        Vec3(0, 0, 1),
        Vec3(0, 0, 0)
    )
end

function BRLootPickup:AsTable()
    local s_Items = {}
    for _, l_Item in pairs(self.m_Items) do
        table.insert(s_Items, l_Item:AsTable())
    end

    return {
        Id = self.m_Id,
        Type = self.m_Type.Name,
        Transform = self.m_Transform,
        Items = s_Items,
    }
end

function BRLootPickup:RemoveItem(p_Id)
    for l_Index, l_Item in pairs(self.m_Items) do
        if l_Item.m_Id == p_Id then
            self.m_Items[l_Index] = nil

            m_Logger:Write("Loot Pickup item removed from database.")
        end
    end
end

function BRLootPickup:ContainsItem(p_Id)
    for _, l_Item in pairs(self.m_Items) do
        if l_Item.m_Id == p_Id then
            return true
        end
    end

    return false
end

function BRLootPickup:CreateFromTable(p_Table)
    local s_Items = {}
    for _, l_Item in pairs(p_Table.Items) do
        table.insert(s_Items, g_BRItemFactory:CreateFromTable(l_Item))
    end

    return BRLootPickup(
        p_Table.Id,
        LootPickupType[p_Table.Type],
        p_Table.Transform,
        s_Items
    )
end

--==============================
-- Spawn / Destroy functions
--==============================

function BRLootPickup:Spawn(p_Id)
    if self.m_Entities ~= nil then
        return
    end

    local s_Mesh = self:GetMesh()
    if s_Mesh == nil then
        m_Logger:Write("Mesh not found.")
        return
    end

    local s_LinearTransform = self:GetLinearTransform()
    if s_LinearTransform == nil then
        s_LinearTransform = LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0, 0)
        )
    end

    local s_Asset = s_Mesh:GetInstance()
    if s_Asset == nil then
        m_Logger:Write("Asset not found.")
        return
    end

    s_StaticModelEntityData = StaticModelEntityData()
    s_StaticModelEntityData.mesh = s_Asset
    s_StaticModelEntityData.transform = s_LinearTransform

    -- We need to set the bone transforms if we want to spawn a weapon mesh for the loot pickup
    if #self.m_Items == 1 then
        if self.m_Items[1].m_Definition.m_Type == ItemType.Weapon and self.m_Items[1].m_Definition.m_SoldierWeaponBlueprint ~= nil then
            local s_SoldierWeaponUnlockAsset = self.m_Items[1].m_Definition.m_SoldierWeaponBlueprint:GetInstance()
            local s_SoldierWeaponData = SoldierWeaponData(s_SoldierWeaponUnlockAsset.weapon.object)
            s_StaticModelEntityData.basePoseTransforms:clear()
            for _, l_LinearTransform in pairs(s_SoldierWeaponData.weaponStates[1].mesh3pTransforms) do        
                s_StaticModelEntityData.basePoseTransforms:add(l_LinearTransform)
            end
        elseif self.m_Items[1].m_Definition.m_Type == ItemType.Helmet then
            --[[
            s_StaticModelEntityData.basePoseTransforms:clear()
            for _, l_LinearTransform in pairs(s_VeniceAntSke01.localPose) do
                s_StaticModelEntityData.basePoseTransforms:add(l_LinearTransform)
            end
            ]]
            s_StaticModelEntityData = MeshProxyEntityData()
            s_StaticModelEntityData.mesh = s_Asset
            s_StaticModelEntityData.transform = s_LinearTransform
            for index, point in pairs(ArmorSkeletonHelper) do
                s_StaticModelEntityData.basePoseTransforms:add(point)
            end
        end
    end

    local s_Color = Vec3(1.0, 0.9, 0.9)
    if #self.m_Items == 1 and self.m_Items[1].m_Definition.m_Tier ~= nil then
        if self.m_Items[1].m_Definition.m_Tier == Tier.Tier2 then
            s_Color = Vec3(0.039, 0.702, 1)
        elseif self.m_Items[1].m_Definition.m_Tier == Tier.Tier3 then
            s_Color = Vec3(1, 0.6, 0)
        end
    end

    local s_SpotLightEntityData = SpotLightEntityData()
    local left, up, forward = m_RotationHelper:GetLUFfromYPR(0, 1.57079633, 0)
    s_SpotLightEntityData.transform = LinearTransform(
        left,
        up,
        forward,
        Vec3(0, 1.2, 0)
    )
    s_SpotLightEntityData.color = s_Color
    s_SpotLightEntityData.radius = 6.5
    s_SpotLightEntityData.intensity = 3.5
    s_SpotLightEntityData.attenuationOffset = 0
    s_SpotLightEntityData.specularEnable = false
    s_SpotLightEntityData.enlightenColorMode = EnlightenColorMode.EnlightenColorMode_Multiply
    s_SpotLightEntityData.enlightenEnable = false
    s_SpotLightEntityData.enlightenColorScale = Vec3(5, 5, 5)
    s_SpotLightEntityData.particleColorScale = Vec3(1, 1, 1)
    s_SpotLightEntityData.visible = true
    s_SpotLightEntityData.shape = SpotLightShape.SpotLightShape_Cone
    s_SpotLightEntityData.coneInnerAngle = 0.0
    s_SpotLightEntityData.coneOuterAngle = 60.0
    s_SpotLightEntityData.frustumFov = 60.0
    s_SpotLightEntityData.frustumAspect = 1.0
    s_SpotLightEntityData.orthoWidth = 5.0
    s_SpotLightEntityData.orthoHeight = 0.5
    s_SpotLightEntityData.castShadowsEnable = false
    s_SpotLightEntityData.castShadowsMinLevel = QualityLevel.QualityLevel_Low

    local s_BusStaticModel = EntityManager:CreateEntity(s_StaticModelEntityData, self.m_Transform)
    local s_BusSpotLight = EntityManager:CreateEntity(s_SpotLightEntityData, self.m_Transform)

    if s_BusStaticModel == nil or s_BusSpotLight == nil then
        return
    end

    if self.m_Entities == nil then
        self.m_Entities = {}
    end

    s_BusStaticModel:Init(Realm.Realm_ClientAndServer, true, false)
    self.m_Entities[s_BusStaticModel.instanceId] = s_BusStaticModel
    -- table.insert(self.m_Entities, s_BusStaticModel)

    s_BusSpotLight:Init(Realm.Realm_ClientAndServer, true, false)
    self.m_Entities[s_BusSpotLight.instanceId] = s_BusSpotLight
    -- table.insert(self.m_Entities, s_BusSpotLight)
end

function BRLootPickup:Destroy()
    if self.m_Entities == nil then
        return
    end

    for l_InstanceId, l_Entity in pairs(self.m_Entities) do
        l_Entity:FireEvent("Disable")
        l_Entity:FireEvent("Destroy")
        l_Entity:Destroy()

        self.m_Entities[l_InstanceId] = nil
    end
end
