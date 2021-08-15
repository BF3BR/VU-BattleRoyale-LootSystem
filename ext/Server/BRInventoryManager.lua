class "BRInventoryManager"

require "__shared/Enums/CustomEvents"

local m_Logger = Logger("BRInventoryManager", true)

local m_ItemDatabase = require "Types/BRItemDatabase"
local m_LootPickupDatabase = require "Types/BRLootPickupDatabase"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"
local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

require "__shared/Utils/BRItemFactory"

function BRInventoryManager:__init()
    self:RegisterVars()
    self:RegisterEvents()
end

function BRInventoryManager:RegisterVars()
    -- [Player.id] -> [BRInventory]
    self.m_Inventories = {}
end

function BRInventoryManager:RegisterEvents()
    NetEvents:Subscribe(InventoryNetEvent.PickupItem, self, self.OnInventoryPickupItem)
    NetEvents:Subscribe(InventoryNetEvent.MoveItem, self, self.OnInventoryMoveItem)
    NetEvents:Subscribe(InventoryNetEvent.UseItem, self, self.OnInventoryUseItem)
    NetEvents:Subscribe(InventoryNetEvent.DropItem, self, self.OnInventoryDropItem)

    -- Events:Subscribe("GunSway:UpdateRecoil", self, self.OnGunSwayUpdateRecoil)
    Events:Subscribe("Player:ChangingWeapon", self, self.OnPlayerChangingWeapon)
    Events:Subscribe("Player:PostReload", self, self.OnPlayerPostReload)
    Events:Subscribe("BRItem:DestroyItem", self, self.OnItemDestroy)
end

function BRInventoryManager:OnPlayerLeft(p_Player)
    m_Logger:Write(string.format("Destroying Inventory for '%s'", p_Player.name))

    if self.m_Inventories[p_Player.id] ~= nil then
        self:RemoveInventory(p_Player.id)
    end
end

function BRInventoryManager:OnPlayerChangingWeapon(p_Player)
    if p_Player == nil or p_Player.soldier == nil then
        return
    end

    local s_CurrentWeapon = p_Player.soldier.weaponsComponent.currentWeapon
    local s_Inventory = self.m_Inventories[p_Player.id]
    if s_CurrentWeapon == nil or s_Inventory == nil then
        return
    end

    -- destroy gadget if empty
    s_Inventory:GetSlot(InventorySlot.Gadget):DestroyIfEmpty()

    -- Update secondary ammo count
    s_CurrentWeapon.secondaryAmmo = s_Inventory:GetAmmoTypeCount(s_CurrentWeapon.name)
end

function BRInventoryManager:GetOrCreateInventory(p_Player)
    -- get existing inventory
    local s_Inventory = self.m_Inventories[p_Player.id]

    -- create a new one if needed
    if s_Inventory == nil then
        s_Inventory = BRInventory(p_Player)
        self:AddInventory(s_Inventory, p_Player.id)
    end

    return s_Inventory
end

-- Adds a BRInventory
-- @param p_Inventory BRInventory
-- @param p_PlayerId integer
function BRInventoryManager:AddInventory(p_Inventory, p_PlayerId)
    self.m_Inventories[p_PlayerId] = p_Inventory
end

-- Removes a BRInventory
-- @param p_PlayerId integer
function BRInventoryManager:RemoveInventory(p_PlayerId)
    -- destroy inventory and clear reference
    self.m_Inventories[p_PlayerId]:Destroy()
    self.m_Inventories[p_PlayerId] = nil
end

--============================================================
-- Player <-> Inventory interaction functions
--============================================================

-- Responds to the request of a player to pickup an item from a specified lootpickup
function BRInventoryManager:OnInventoryPickupItem(p_Player, p_LootPickupId, p_ItemId, p_SlotId)
    -- get inventory
    local s_Inventory = self:GetOrCreateInventory(p_Player)
    if s_Inventory == nil then
        return
    end

    -- get lootpickup
    local s_LootPickup = m_LootPickupDatabase:GetLootPickup(p_LootPickupId)
    if s_LootPickup == nil then
        return
    end

    -- TODO check player and lootpickup distance

    -- add item to player and remove it from lootpickup
    if s_LootPickup:ContainsItem(p_ItemId) then
        if s_Inventory:AddItem(p_ItemId, p_SlotId) then
            m_LootPickupDatabase:RemoveItemFromLootPickup(p_LootPickupId, p_ItemId)
        end
    end
end

-- Responds to the request of a player to move an item between slots of his inventory
function BRInventoryManager:OnInventoryMoveItem(p_Player, p_ItemId, p_SlotId)
    local s_Inventory = self.m_Inventories[p_Player.id]
    if s_Inventory == nil then
        return
    end

    s_Inventory:SwapItems(p_ItemId, p_SlotId)
end

-- Responds to the request of a player to drop an item from his inventory
function BRInventoryManager:OnInventoryDropItem(p_Player, p_ItemId, p_Quantity)
    local s_Inventory = self.m_Inventories[p_Player.id]
    if s_Inventory == nil then
        return
    end

    s_Inventory:DropItem(p_ItemId, p_Quantity)
end

-- Responds to the request of a player to use an item from his inventory
function BRInventoryManager:OnInventoryUseItem(p_Player, p_ItemId)
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)

    -- TODO validate that player is owner of this item

    if s_Item ~= nil then
        s_Item:Use()
    end
end

-- TODO move this into BRInventory.UpdateOwnerAmmo
function BRInventoryManager:OnPlayerPostReload(p_Player, p_AmmoAdded, p_Weapon)
    if p_Player == nil or p_Player.soldier == nil then
        return
    end

    local s_Inventory = self.m_Inventories[p_Player.id]
    local p_Weapon = p_Weapon or p_Player.soldier.weaponsComponent.currentWeapon
    if s_Inventory == nil or p_Weapon == nil then
        return
    end

    -- remove ammo that was added
    s_Inventory:RemoveAmmo(p_Weapon.name, p_AmmoAdded)

    -- Update ammo values
    s_Inventory:SavePrimaryAmmo(p_Weapon.name, p_Weapon.primaryAmmo)
    p_Weapon.secondaryAmmo = s_Inventory:GetAmmoTypeCount(p_Weapon.name)
end

-- ugly solution for now
-- BRItemDatabase should know where each item resides and
-- destroy it and remove any references when needed
function BRInventoryManager:OnItemDestroy(p_ItemId)
    -- search for the item
    for _, l_Inventory in pairs(self.m_Inventories) do
        local s_Slot = l_Inventory:GetItemSlot(p_ItemId)

        -- clear slot and send the updated inventory state
        if s_Slot ~= nil then
            s_Slot:Clear()
            l_Inventory:SendState()
            break
        end
    end

    -- remove item from database
    m_ItemDatabase:UnregisterItem(p_ItemId)
end

-- define global
if g_BRInventoryManager== nil then
    g_BRInventoryManager = BRInventoryManager()
end

return g_BRInventoryManager
