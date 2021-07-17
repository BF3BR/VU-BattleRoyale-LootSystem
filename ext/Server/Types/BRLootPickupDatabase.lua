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

function BRLootPickupDatabase:CreateLootPickup(p_Type, p_Transform, p_Items)
    local s_Items = {}
    for _, l_Item in pairs(p_Items) do
        table.insert(s_Items, l_Item:AsTable())
    end

    local s_DataArray = {
        Id = self:GetRandomId(),
        Type = p_Type,
        Transform = p_Transform,
        Items = s_Items
    }

    -- create item instance and insert it to the items table
    local s_LootPickup = BRLootPickup:CreateFromTable(s_DataArray)
    self.m_LootPickups[s_DataArray.Id] = s_LootPickup
    self.m_LootPickups[s_DataArray.Id]:Spawn(s_DataArray.Id)

    m_Logger:Write("Loot Pickup added to database.")

    NetEvents:BroadcastLocal(InventoryNetEvent.CreateLootPickup, s_DataArray)
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

if g_BRLootPickupDatabase == nil then
    g_BRLootPickupDatabase = BRLootPickupDatabase()
end

return g_BRLootPickupDatabase
