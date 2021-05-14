class "BRLootPickup"

-- local m_BRPickups = require "__shared/Types/BRPickups"

function BRLootPickup:__init(p_Type, p_Transform, p_Items)
    -- Unique Id for each loot pickup
    -- TODO: Find a better solution for generating unique id for each item
    self.m_Id = MathUtils:RandomGuid()

    -- ItemEnums - LootPickupType
    self.m_Type = p_Type

    -- Transform of the pickup
    self.m_Transform = p_Transform

    -- A table of items
    self.m_Items = p_Items
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
    return {
        Id = self.m_Id,
        Type = self.m_Type,
        Transform = self.m_Transform,
        Items = self.m_Items:AsTable(),
    }
end

-- TODO: Create subclasses for each pickup types
function BRLootPickup.static:BasicPickup(p_Transform, p_Items)
    --[[m_BRPickups:AddLootPickup(
        BRLootPickup(
            MathUtils:RandomGuid(),
            LootPickupType.Basic,
            p_Transform,
            p_Items
        )
    )]]
end

-- TODO: Create subclasses for each pickup types
function BRLootPickup.static:ChestPickup(p_Transform, p_Items)
    --[[m_BRPickups:AddLootPickup(
            BRLootPickup(
            MathUtils:RandomGuid(),
            LootPickupType.Chest,
            p_Transform,
            p_Items
        )
    )]]
end


--==============================
-- LootPickup related functions
--==============================

function BRLootPickup:SpawnMeshEntity()
    -- TODO: Spawn the mesh set in this object
end

function BRLootPickup:Destory()
    -- TODO: Destory this object
end
