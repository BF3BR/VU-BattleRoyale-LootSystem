class "BRLootPickup"

function BRLootPickup:__init(p_Guid, p_Type, p_Transform, p_Items)
    self.m_Guid = p_Guid

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

function BRLootPickup.static:BasicPickup(p_Transform, p_Items)
    return BRLootPickup(
        MathUtils:RandomGuid(),
        LootPickupType.Basic,
        p_Transform,
        p_Items
    )
end

function BRLootPickup.static:ChestPickup(p_Transform, p_Items)
    return BRLootPickup(
        MathUtils:RandomGuid(),
        LootPickupType.Chest,
        p_Transform,
        p_Items
    )
end
