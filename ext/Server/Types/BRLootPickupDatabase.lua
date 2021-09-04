class "BRLootPickupDatabase"

require "__shared/Enums/CustomEvents"

require "__shared/Types/BRLootPickup"

local m_Logger = Logger("BRLootPickupDatabase", true)
local m_ItemDatabase = require "Types/BRItemDatabase"

-- This is gonna get replaced with the Spatial index, probably

function BRLootPickupDatabase:__init()
    -- A table of items (id -> BRLootPickup)
    self.m_LootPickups = {}
end

function BRLootPickupDatabase:GetLootPickup(p_LootPickupId)
    return self.m_LootPickups[p_LootPickupId]
end

---@param p_Transform Vec3|LinearTransform
---@param p_Items BRItem[]
function BRLootPickupDatabase:CreateBasicLootPickup(p_Transform, p_Items)
    self:CreateLootPickup(LootPickupType.Basic.Name, p_Transform, p_Items)
end

function BRLootPickupDatabase:CreateLootPickup(p_Type, p_Transform, p_Items)
    if p_Type == nil or p_Transform == nil or p_Items == nil then
        m_Logger:Error("Invalid CreateLootPickup parameters")
        return
    end

    -- if p_Transform is Vec3, use it as the .trans of a LinearTransform
    if type(p_Transform.z) == "number" then
        local s_Trans = p_Transform
        p_Transform = LinearTransform()
        p_Transform.trans = s_Trans
    end

    -- convert items array to map
    local s_Items = {}
    for _, l_Item in pairs(p_Items) do
        s_Items[l_Item.m_Id] = l_Item
    end

    -- create item instance and insert it to the items table
    local s_LootPickupId = self:GetRandomId()
    local s_LootPickup = BRLootPickup(s_LootPickupId, p_Type, p_Transform, s_Items)
    self.m_LootPickups[s_LootPickupId] = s_LootPickup

    -- I don't think we need to spawn the entity server side
    -- self.m_LootPickups[s_DataArray.Id]:Spawn(s_DataArray.Id)

    m_Logger:Write(string.format("LootPickup #%s was added", s_LootPickupId))

    NetEvents:BroadcastLocal(InventoryNetEvent.CreateLootPickup, s_LootPickup:AsTable())
end

function BRLootPickupDatabase:UnregisterLootPickup(p_LootPickupId)
    if self.m_LootPickups[p_LootPickupId] == nil then
        return
    end

    for _, l_Item in pairs(self.m_LootPickups[p_LootPickupId].m_Items) do
        m_ItemDatabase:UnregisterItem(l_Item.m_Id)
    end

    self.m_LootPickups[p_LootPickupId]:Destroy()
    self.m_LootPickups[p_LootPickupId] = nil

    NetEvents:BroadcastLocal(InventoryNetEvent.UnregisterLootPickup, p_LootPickupId)

    m_Logger:Write("Loot Pickup removed from database.")
end

function BRLootPickupDatabase:RemoveItemFromLootPickup(p_LootPickupId, p_ItemId)
    local s_LootPickup = self.m_LootPickups[p_LootPickupId]
    if s_LootPickup == nil then
        return
    end

    s_LootPickup:RemoveItem(p_ItemId)

    if #s_LootPickup.m_Items > 0 then
        -- Broadcast updated lootPickup
        NetEvents:BroadcastLocal(InventoryNetEvent.UpdateLootPickup, s_LootPickup:AsTable())
    else
        -- Remove loot pickup if all the item got picked up
        self:UnregisterLootPickup(p_LootPickupId)
    end
end

function BRLootPickupDatabase:GetRandomId()
    -- for now use the guid string
    return tostring(MathUtils:RandomGuid())
end

-- TODO: OnPlayerJoin send the whole self.m_LootPickups to that player

return BRLootPickupDatabase()
