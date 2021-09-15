class "BRLootPickup"

local m_Logger = Logger("BRLootPickup", true)
local m_RotationHelper = require "__shared/Utils/RotationHelper"
local m_MapHelper = require "__shared/Utils/MapHelper"

local m_FlashlightTexture = DC(Guid("04C62561-2236-11DF-A528-EA655525F02D"), Guid("2EE018E8-1451-908C-0974-DB7676407D61"))

function BRLootPickup:__init(p_Id, p_TypeName, p_Transform, p_Items)
    -- Unique Id for each loot pickup
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- ItemEnums - LootPickupType
    self.m_Type = LootPickupType[p_TypeName]

    -- Transform of the pickup
    self.m_Transform = p_Transform

    -- A map of LootPickups {id -> LootPickup}
    self.m_Items = p_Items

    -- 
    self.m_ParentCell = nil

    -- [Client] Contains spawned entities {instanceId -> Entity}
    self.m_Entities = nil
end

function BRLootPickup:AddItem(p_Item)
    if p_Item == nil or self:ContainsItem(p_Item.m_Id) then
        return
    end

    self.m_Items[p_Item.m_Id] = p_Item
end

function BRLootPickup:RemoveItem(p_Id)
    if self.m_Items[p_Id] ~= nil then
        self.m_Items[p_Id] = nil
        m_Logger:Write("Item removed from LootPickup.")
    end
end

function BRLootPickup:ContainsItem(p_Id)
    return self.m_Items[p_Id] ~= nil
end

function BRLootPickup:GetMesh()
    if m_MapHelper:HasSingleItem(self.m_Items) then
        -- If there is only one item then use its mesh
        return m_MapHelper:Item(self.m_Items).m_Definition.m_Mesh
    elseif self.m_Type.Mesh ~= nil then
        -- If there is a mesh set to the current type
        return self.m_Type.Mesh
    end

    return nil
end

function BRLootPickup:GetLinearTransform()
    if m_MapHelper:HasSingleItem(self.m_Items) then
        -- If there is only one item then use its LT
        return m_MapHelper:Item(self.m_Items).m_Definition.m_Transform
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

--==============================
-- Spawn / Destroy functions
--==============================

function BRLootPickup:Spawn()
    if self.m_Entities ~= nil then
        return false
    end

    local s_Mesh = self:GetMesh()
    if s_Mesh == nil then
        m_Logger:Write("Mesh not found.")
        return false
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
        return false
    end

    s_StaticModelEntityData = StaticModelEntityData()
    s_StaticModelEntityData.mesh = s_Asset
    s_StaticModelEntityData.transform = LinearTransform(
        s_LinearTransform.left,
        s_LinearTransform.up,
        s_LinearTransform.forward,
        Vec3(
            s_LinearTransform.trans.x,
            s_LinearTransform.trans.y + 0.4,
            s_LinearTransform.trans.z
        )
    )

    local s_SingleItem = m_MapHelper:Item(self.m_Items)
    if m_MapHelper:HasSingleItem(self.m_Items) then
        -- We need to set the bone transforms if we want to spawn a weapon or helmet
        if (s_SingleItem.m_Definition.m_Type == ItemType.Weapon or 
        s_SingleItem.m_Definition.m_Type == ItemType.Gadget) and 
        s_SingleItem.m_Definition.m_SoldierWeaponBlueprint ~= nil then
            local s_SoldierWeaponUnlockAsset = s_SingleItem.m_Definition.m_SoldierWeaponBlueprint:GetInstance()
            local s_SoldierWeaponData = SoldierWeaponData(s_SoldierWeaponUnlockAsset.weapon.object)
            s_StaticModelEntityData.basePoseTransforms:clear()
            for _, l_LinearTransform in pairs(s_SoldierWeaponData.weaponStates[1].mesh3pTransforms) do        
                s_StaticModelEntityData.basePoseTransforms:add(l_LinearTransform)
            end
        elseif s_SingleItem.m_Definition.m_Type == ItemType.Helmet or s_SingleItem.m_Definition.m_Type == ItemType.Armor then
            for i = 1, 213 do
                s_StaticModelEntityData.basePoseTransforms:add(LinearTransform())
            end
        end
    end

    local s_Color = Vec3(1.0, 0.9, 0.9)
    if m_MapHelper:HasSingleItem(self.m_Items) and s_SingleItem.m_Definition.m_Tier ~= nil then
        if s_SingleItem.m_Definition.m_Tier == Tier.Tier2 then
            s_Color = Vec3(0.039, 0.702, 1)
        elseif s_SingleItem.m_Definition.m_Tier == Tier.Tier3 then
            s_Color = Vec3(1, 0.6, 0)
        end
    end

    local s_SpotLightEntityData = PointLightEntityData()
    local left, up, forward = m_RotationHelper:GetLUFfromYPR(0, 1.57079633, 0)
    s_SpotLightEntityData.transform = LinearTransform(
        left,
        up,
        forward,
        Vec3(0, 1.2, 0)
    )
    s_SpotLightEntityData.color = s_Color
    s_SpotLightEntityData.radius = 2.35
    s_SpotLightEntityData.width = 2.0
    s_SpotLightEntityData.intensity = 5.25
    s_SpotLightEntityData.visible = true
    s_SpotLightEntityData.enlightenEnable = false

    --[[s_SpotLightEntityData.intensity = 15.0
    s_SpotLightEntityData.attenuationOffset = 50.0
    s_SpotLightEntityData.specularEnable = true
    s_SpotLightEntityData.enlightenColorMode = EnlightenColorMode.EnlightenColorMode_Multiply
    s_SpotLightEntityData.enlightenColorScale = Vec3(1.3, 1.3, 1.3)
    s_SpotLightEntityData.particleColorScale = Vec3(0.2, 0.2, 0.2)
    s_SpotLightEntityData.shape = SpotLightShape.SpotLightShape_Frustum
    s_SpotLightEntityData.coneInnerAngle = 0.0
    s_SpotLightEntityData.coneOuterAngle = 32.3720016479
    s_SpotLightEntityData.frustumFov = 55.0
    s_SpotLightEntityData.frustumAspect = 1.0
    s_SpotLightEntityData.orthoWidth = 5.0
    s_SpotLightEntityData.orthoHeight = 5.0
    s_SpotLightEntityData.castShadowsEnable = false
    s_SpotLightEntityData.castShadowsMinLevel = QualityLevel.QualityLevel_Low
    s_SpotLightEntityData.texture = m_FlashlightTexture:GetInstance()]]

    local s_BusStaticModel = EntityManager:CreateEntity(s_StaticModelEntityData, self.m_Transform)
    local s_BusSpotLight = EntityManager:CreateEntity(s_SpotLightEntityData, self.m_Transform)

    if s_BusStaticModel == nil or s_BusSpotLight == nil then
        m_Logger:Write("Models are nil, can't spawn")
        return false
    end

    if self.m_Entities == nil then
        self.m_Entities = {}
    end

    s_BusStaticModel:Init(Realm.Realm_Client, true, false)
    self.m_Entities[s_BusStaticModel.instanceId] = s_BusStaticModel

    s_BusSpotLight:Init(Realm.Realm_Client, true, false)
    self.m_Entities[s_BusSpotLight.instanceId] = s_BusSpotLight

    return self.m_Entities ~= nil
end

--==============================
-- Serialization
--==============================

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

function BRLootPickup:CreateFromTable(p_Table)
    local s_Items = {}
    for _, l_Item in pairs(p_Table.Items) do
        local s_Item = g_BRItemFactory:CreateFromTable(l_Item)
        s_Items[s_Item.m_Id] = s_Item
    end

    return BRLootPickup(
        p_Table.Id,
        p_Table.Type,
        p_Table.Transform,
        s_Items
    )
end

function BRLootPickup:UpdateFromTable(p_Table)
    if p_Table.Id ~= self.m_Id then
        return
    end

    local s_Items = {}
    for _, l_Item in pairs(p_Table.Items) do
        local s_Item = g_BRItemFactory:CreateFromTable(l_Item)
        s_Items[s_Item.m_Id] = s_Item
    end

    self.m_Transform = p_Table.Transform
    self.m_Items = s_Items
end

function BRLootPickup:DestroyEntities()
    if self.m_Entities == nil then
        return
    end

    for l_InstanceId, l_Entity in pairs(self.m_Entities) do
        l_Entity:FireEvent("Disable")
        l_Entity:FireEvent("Destroy")
        l_Entity:Destroy()

        self.m_Entities[l_InstanceId] = nil
    end

    self.m_Entities = nil
end

function BRLootPickup:Destroy()
    self.m_ParentCell = nil
    self:DestroyEntities()
end
