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
-- Spawn / Destory functions
--==============================

function BRLootPickup:Spawn()
    if self.m_Entities ~= nil then
        return
    end

    local s_Mesh = self:GetMesh()
    if s_Mesh == nil then
        m_Logger:Write("Mesh not found.")
        return
    end

    local s_Asset = s_Mesh:GetInstance()
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
		l_Entity:Init(Realm.Realm_ClientAndServer, true, false)
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
