require "__shared/Enums/CustomEvents"
require "__shared/Types/BRLootPickup"
require "__shared/Types/BRLootPickupDatabaseShared"

class("BRLootPickupDatabase", BRLootPickupDatabaseShared)

local m_Logger = Logger("BRLootPickupDatabase", true)
local m_ItemDatabase = require "Types/BRItemDatabase"
local m_MapHelper = require "__shared/Utils/MapHelper"

---@param p_Transform Vec3|LinearTransform
---@param p_Items BRItem[]
function BRLootPickupDatabase:CreateBasicLootPickup(p_Transform, p_Items)
    self:CreateLootPickup(LootPickupType.Basic.Name, p_Transform, p_Items)
end

function BRLootPickupDatabase:CreateAirdropLootPickup(p_Transform, p_Items)
    self:CreateLootPickup(LootPickupType.Airdrop.Name, p_Transform, p_Items)
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

    -- Spawn the entity server side as well if it has collision
    if LootPickupType[p_Type].PhysicsEntityData ~= nil then
        self.m_LootPickups[s_LootPickupId]:Spawn()
    end

    m_Logger:Write(string.format("LootPickup #%s was added", s_LootPickupId))

    NetEvents:BroadcastLocal(InventoryNetEvent.CreateLootPickup, s_LootPickup:AsTable())
end

function BRLootPickupDatabase:Remove(p_LootPickup)
    if not BRLootPickupDatabaseShared.Remove(self, p_LootPickup) then
        return
    end

    -- remove remaining items from item database
    for _, l_Item in pairs(p_LootPickup.m_Items) do
        m_ItemDatabase:UnregisterItem(l_Item.m_Id)
    end

    p_LootPickup:Destroy()

    NetEvents:BroadcastLocal(InventoryNetEvent.UnregisterLootPickup, p_LootPickup.m_Id)

    m_Logger:Write("Loot Pickup removed from database.")
end

function BRLootPickupDatabase:RemoveItemFromLootPickup(p_LootPickupId, p_ItemId)
    local s_LootPickup = self.m_LootPickups[p_LootPickupId]
    if s_LootPickup == nil then
        return
    end

    s_LootPickup:RemoveItem(p_ItemId)

    if not m_MapHelper:Empty(s_LootPickup.m_Items) then
        -- Broadcast updated lootPickup
        NetEvents:BroadcastLocal(InventoryNetEvent.UpdateLootPickup, s_LootPickup:AsTable())
    else
        -- Remove loot pickup if all the item got picked up
        self:Remove(s_LootPickup)
    end
end

function BRLootPickupDatabase:UpdateState(p_LootPickupId)
    local s_LootPickup = self.m_LootPickups[p_LootPickupId]
    if s_LootPickup == nil then
        return
    end

    NetEvents:BroadcastLocal(InventoryNetEvent.UpdateLootPickup, s_LootPickup:AsTable())
end

function BRLootPickupDatabase:GetRandomId()
    -- for now use the guid string
    return tostring(MathUtils:RandomGuid())
end

-- TODO: OnPlayerJoin send the whole self.m_LootPickups to that player

return BRLootPickupDatabase()
