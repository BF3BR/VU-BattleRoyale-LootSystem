class "BRInventoryManager"

require "__shared/Enums/CustomEvents"

local m_Logger = Logger("BRInventoryManager", true)

local m_ItemDatabase = require "Types/BRItemDatabase"

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
    NetEvents:Subscribe(InventoryNetEvent.UseItem, self, self.OnInventoryUseItem)
    NetEvents:Subscribe(InventoryNetEvent.InventoryGiveCommand, self, self.OnPlayerGiveCommand)
    NetEvents:Subscribe(InventoryNetEvent.MoveItem, self, self.OnInventoryMoveItem)
    NetEvents:Subscribe(InventoryNetEvent.DropItem, self, self.OnInventoryDropItem)

    Events:Subscribe("GunSway:UpdateRecoil", self, self.OnGunSwayUpdateRecoil)
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

function BRInventoryManager:OnGunSwayUpdateRecoil(p_GunSway, p_Weapon, p_WeaponFiring, p_DeltaTime)
    if p_GunSway.isFiring and p_GunSway.fireShot then
        local s_Players = PlayerManager:GetPlayers()
        for _, l_Player in pairs(s_Players) do
            if l_Player.soldier.weaponsComponent.currentWeapon.instanceId == p_Weapon.instanceId then
                local s_Inventory = self.m_Inventories[l_Player.id]

                if s_Inventory == nil then
                    return
                end

                s_Inventory:SetCurrentPrimaryAmmo(
                    l_Player.soldier.weaponsComponent.currentWeapon.name,
                    l_Player.soldier.weaponsComponent.currentWeapon.primaryAmmo
                )

                s_Inventory:CheckIfLastShotForGadget(l_Player.soldier.weaponsComponent.currentWeapon.name) 
            end
        end
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

    -- Update primary and secondary ammo count
    s_CurrentWeapon.primaryAmmo = s_Inventory:GetCurrentPrimaryAmmo(s_CurrentWeapon.name)
    s_CurrentWeapon.secondaryAmmo = s_Inventory:GetAmmoTypeCount(s_CurrentWeapon.name)
end

-- Removes a BRInventory
-- @param p_PlayerId integer
function BRInventoryManager:RemoveInventory(p_PlayerId)
    -- destroy inventory and clear reference
    self.m_Inventories[p_PlayerId]:Destroy()
    self.m_Inventories[p_PlayerId] = nil
end

-- Adds a BRInventory
-- @param p_Inventory BRInventory
-- @param p_PlayerId integer
function BRInventoryManager:AddInventory(p_Inventory, p_PlayerId)
    self.m_Inventories[p_PlayerId] = p_Inventory
end

function BRInventoryManager:OnPlayerGiveCommand(p_Player, p_Args)
    if p_Player == nil then
        m_Logger:Error("Invalid player.")
        return
    end

    if #p_Args == 0 then
        m_Logger:Error("Invalid command.")
        return
    end

    local s_Definition = g_BRItemFactory:FindDefinitionByUId(p_Args[1])

    if s_Definition == nil then
        m_Logger:Error("Invalid item definition UId: " .. p_Args[1])
        return
    end

    local s_Inventory = self.m_Inventories[p_Player.id]
    local s_CreatedItem = m_ItemDatabase:CreateItem(s_Definition, p_Args[2] ~= nil and tonumber(p_Args[2]) or 1)

    s_Inventory:AddItem(s_CreatedItem.m_Id)
    m_Logger:Write(s_Definition.m_Name .. " - Item given to player: " .. p_Player.name)
end

function BRInventoryManager:OnInventoryMoveItem(p_Player, p_ItemId, p_SlotId)
    local s_Inventory = self.m_Inventories[p_Player.id]
    if s_Inventory == nil then
        return
    end

    s_Inventory:SwapItems(p_ItemId, p_SlotId)
end

function BRInventoryManager:OnInventoryDropItem(p_Player, p_ItemId, p_Quantity)
    local s_Inventory = self.m_Inventories[p_Player.id]
    if s_Inventory == nil then
        return
    end

    s_Inventory:DropItem(p_ItemId, p_Quantity)
end

function BRInventoryManager:OnPlayerPostReload(p_Player, p_PreviousPrimaryAmmo)
    if p_Player == nil or p_Player.soldier == nil then
        return
    end
    
    local s_Inventory = self.m_Inventories[p_Player.id]
    local s_CurrentWeapon = p_Player.soldier.weaponsComponent.currentWeapon
    if s_Inventory:IsGadget(s_CurrentWeapon.name) then
        s_Inventory:SetCurrentPrimaryAmmo(s_CurrentWeapon.name, s_CurrentWeapon.primaryAmmo)
        return
    end

    local s_AmmoDiff = s_CurrentWeapon.primaryAmmo - p_PreviousPrimaryAmmo

    local s_PrimaryAmmo = p_PreviousPrimaryAmmo + s_Inventory:RemoveAmmo(s_CurrentWeapon.name, s_AmmoDiff)
    local s_SecondaryAmmo = s_Inventory:GetAmmoTypeCount(s_CurrentWeapon.name)

    -- Update ammo values
    s_CurrentWeapon.primaryAmmo = s_PrimaryAmmo
    s_CurrentWeapon.secondaryAmmo = s_SecondaryAmmo

    s_Inventory:SetCurrentPrimaryAmmo(s_CurrentWeapon.name, s_PrimaryAmmo)
end

function BRInventoryManager:OnInventoryUseItem(p_Player, p_ItemId)
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item ~= nil then
        s_Item:Use()
    end
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
