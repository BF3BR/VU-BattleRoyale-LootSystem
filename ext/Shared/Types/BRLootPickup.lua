class "BRLootPickup"

local m_Logger = Logger("BRLootPickup", true)
local m_RotationHelper = require "__shared/Utils/RotationHelper"
local m_MapHelper = require "__shared/Utils/MapHelper"

local m_Airdrop_Object_SFX = DC(Guid("CE2EF674-9C22-11E0-9F7B-CD3BC4364C43"), Guid("EBF2202A-9716-2A81-EA34-464432189CD0"))
local m_Airdrop_Object_FX_Smoke = DC(Guid("25B9AFF0-6622-11DE-9DCF-A96EA7FB2539"), Guid("EB9BAF48-75CA-3413-DE82-0CF9EC98603F"))

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
    if p_Item == nil or self:ContainsItemId(p_Item.m_Id) then
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

function BRLootPickup:ContainsItemId(p_Id)
    return self.m_Items[p_Id] ~= nil
end

function BRLootPickup:GetMesh()
    if m_MapHelper:SizeEquals(self.m_Items, 1) then
        -- If there is only one item then use its mesh
        return m_MapHelper:NextItem(self.m_Items).m_Definition.m_Mesh
    elseif self.m_Type.Mesh ~= nil then
        -- If there is a mesh set to the current type
        return self.m_Type.Mesh
    end

    return nil
end

function BRLootPickup:GetLinearTransform()
    if m_MapHelper:SizeEquals(self.m_Items, 1) then
        -- If there is only one item then use its LT
        return m_MapHelper:NextItem(self.m_Items).m_Definition.m_Transform
    elseif self.m_Type.Mesh ~= nil then
        -- If there is a LT set to the current type
        return self.m_Type.Transform
    end

    return LinearTransform()
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
            s_LinearTransform.trans.y,
            s_LinearTransform.trans.z
        )
    )

    if self.m_Type.PhysicsEntityData ~= nil then
        s_StaticModelEntityData.physicsData = self.m_Type.PhysicsEntityData:GetInstance()
    end

    local s_SingleItem = m_MapHelper:NextItem(self.m_Items)
    if m_MapHelper:SizeEquals(self.m_Items, 1) then
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
    if m_MapHelper:SizeEquals(self.m_Items, 1) and s_SingleItem.m_Definition.m_Tier ~= nil then
        if s_SingleItem.m_Definition.m_Tier == Tier.Tier2 then
            s_Color = Vec3(0.039, 0.702, 1)
        elseif s_SingleItem.m_Definition.m_Tier == Tier.Tier3 then
            s_Color = Vec3(1, 0.6, 0)
        end
    end

    local s_LightEntityData = PointLightEntityData()
    s_LightEntityData.transform = LinearTransform(
        Vec3(1, 0, 0),
        Vec3(0, 1, 0),
        Vec3(0, 0, 1),
        Vec3(0, 0.35, 0)
    )
    s_LightEntityData.color = s_Color
    s_LightEntityData.radius = 2.65
    s_LightEntityData.width = 0.5
    s_LightEntityData.intensity = 7
    s_LightEntityData.visible = true
    s_LightEntityData.enlightenEnable = false


    local s_BusStaticModel = EntityManager:CreateEntity(s_StaticModelEntityData, self.m_Transform)

    if self.m_Entities == nil then
        self.m_Entities = {}
    end

    if s_BusStaticModel ~= nil then
        s_BusStaticModel:Init(Realm.Realm_ClientAndServer, true, false)
        self.m_Entities[s_BusStaticModel.instanceId] = s_BusStaticModel
    end

    if SharedUtils:IsClientModule() then
        if self.m_Type.Name == "Airdrop" then
            local s_BusEffect = EntityManager:CreateEntitiesFromBlueprint(m_Airdrop_Object_SFX:GetInstance(), self.m_Transform)
            if s_BusEffect ~= nil then
                for _, l_Entity in pairs(s_BusEffect.entities) do
                    l_Entity:Init(Realm.Realm_Client, false)
                    l_Entity:FireEvent("Start")
                    self.m_Entities[l_Entity.instanceId] = l_Entity
                end
            end

            local s_BusSmokeEffect = EntityManager:CreateEntitiesFromBlueprint(
                m_Airdrop_Object_FX_Smoke:GetInstance(), 
                LinearTransform(
                    self.m_Transform.left,
                    self.m_Transform.up,
                    self.m_Transform.forward,
                    Vec3(
                        self.m_Transform.trans.x,
                        self.m_Transform.trans.y + 1.6,
                        self.m_Transform.trans.z
                    )
                )
            )
            if s_BusSmokeEffect ~= nil then
                for _, l_Entity in pairs(s_BusSmokeEffect.entities) do
                    l_Entity:Init(Realm.Realm_Client, false)
                    l_Entity:FireEvent("Start")
                    self.m_Entities[l_Entity.instanceId] = l_Entity
                end
            end
        else
            local s_BusLight = EntityManager:CreateEntity(s_LightEntityData, self.m_Transform)
        
            if s_BusLight ~= nil then
                s_BusLight:Init(Realm.Realm_ClientAndServer, true, false)
                self.m_Entities[s_BusLight.instanceId] = s_BusLight
            end
        end
    end

    return self.m_Entities ~= nil
end

--==============================
-- Serialization
--==============================

function BRLootPickup:AsTable(p_Extended)
    local s_Items = {}
    for _, l_Item in pairs(self.m_Items) do
        table.insert(s_Items, l_Item:AsTable(p_Extended))
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
