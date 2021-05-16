class "BRLootPickup"

local m_Logger = Logger("BRLootPickup", true)

function BRLootPickup:__init(p_Id, p_Type, p_Transform, p_Items)
    -- Unique Id for each loot pickup
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- ItemEnums - LootPickupType
    self.m_Type = p_Type

    -- Transform of the pickup
    self.m_Transform = p_Transform

    -- A table of items
    self.m_Items = p_Items

    -- Client only
    self.m_Entities = nil
end

function BRLootPickup:GetMesh()
    if self.m_Type.Mesh ~= nil then
        -- If there is a mesh set to the current type
        return self.m_Type.Mesh
    elseif #self.m_Items == 1 then
        -- If there is only one item then use its mesh
        return self.m_Items[1].m_Definition.m_Mesh
    end

    -- TODO: We might need to specify a default mesh
    return nil
end

function BRLootPickup:AsTable()
    local s_Items = {}
    for _, l_Item in pairs(self.m_Items) do
        table.insert(s_Items, l_Item:AsTable())
    end

    return {
        Id = self.m_Id,
        Type = self.m_Type,
        Transform = self.m_Transform,
        Items = s_Items,
    }
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
-- Client only functions
--==============================

function BRLootPickup:Spawn()
    if self.m_Entities ~= nil then
        return
    end

    -- TODO: Use self:GetMesh()

    local s_Asset = ResourceManager:FindInstanceByGuid(Guid('3D606B79-946A-4A6E-BF28-6F92357DB103'), Guid('C6C78918-23C2-4FF7-9A93-904066867737'))
    if s_Asset == nil then
        m_Logger:Write("Asset not found.")
        return
    end

    local s_Bp = ObjectBlueprint(s_Asset)
	local s_Bus = EntityManager:CreateEntitiesFromBlueprint(s_Bp, self.m_Transform)

	if s_Bus == nil then
		m_Logger:Write("Bus not found.")
		return
	end

	for _, l_Entity in pairs(s_Bus.entities) do
		l_Entity:Init(Realm.Realm_Client, true, false)
	end

    self.m_Entities = s_Bus.entities
end

function BRLootPickup:Destory()
    if self.m_Entities == nil then
        return
    end
    
	for _, l_Entity in pairs(self.m_Entities.entities) do
		l_Entity:Destory()
	end
end
