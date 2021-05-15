class "VuBattleRoyaleLootSystemServer"

require "__shared/Utils/Logger"

require "__shared/Types/DataContainer"
require "Types/BRLootPickup"
require "Types/BRInventory"

require "__shared/Enums/ItemEnums"

require "__shared/Items/BRItemWeapon"
require "__shared/Items/BRItemAmmo"
require "__shared/Items/BRItemArmor"
require "__shared/Items/BRItemHelmet"
require "__shared/Items/BRItemAttachment"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"
local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

local m_ItemDatabase = require "Types/BRItemDatabase"
local m_LootPickupDatabase = require "Types/BRLootPickupDatabase"

local m_InventoryManager = require "BRInventoryManager"

local m_Logger = Logger("VuBattleRoyaleLootSystemServer", true)

function VuBattleRoyaleLootSystemServer:__init()
    Events:Subscribe("Extension:Loaded", self, self.OnExtensionLoaded)
end

function VuBattleRoyaleLootSystemServer:OnExtensionLoaded()
    Events:Subscribe("Player:SpawnOnSelectedSpawnPoint", self, self.OnPlayerAuthenticated)
end

function VuBattleRoyaleLootSystemServer:OnPlayerAuthenticated(p_Player)
    local s_Inventory = BRInventory(p_Player)

    local s_ItemPP2000 = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-pp2000"])
    local s_ItemAK = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-ak74m"])
    s_Inventory:AddItem(s_ItemPP2000.m_Id)
    s_Inventory:AddItem(s_ItemAK.m_Id)

    local s_ItemAttachment = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["attachment-acog"])
    s_Inventory:AddItem(s_ItemAttachment.m_Id)

    local s_ItemAmmo1 = m_ItemDatabase:CreateItem(m_AmmoDefinitions["ammo-556mm"], 30)
    local s_ItemAmmo2 = m_ItemDatabase:CreateItem(m_AmmoDefinitions["ammo-556mm"], 24)
    local s_ItemAmmo3 = m_ItemDatabase:CreateItem(m_AmmoDefinitions["ammo-556mm"], 30)
    s_Inventory:AddItem(s_ItemAmmo1.m_Id)
    s_Inventory:AddItem(s_ItemAmmo2.m_Id)
    s_Inventory:AddItem(s_ItemAmmo3.m_Id)

    local s_ItemArmor = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["armor-basic"])
    s_Inventory:AddItem(s_ItemArmor.m_Id)

    local s_ItemHelmet = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["helmet-basic"])
    s_Inventory:AddItem(s_ItemHelmet.m_Id)

    m_Logger:Write(s_Inventory:AsTable())

    m_InventoryManager:AddInventory(s_Inventory)
end

return VuBattleRoyaleLootSystemServer()
