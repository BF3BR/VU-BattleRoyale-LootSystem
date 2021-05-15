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

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"
local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"

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

    local s_ItemPP2000 = BRItemWeapon(nil, m_WeaponDefinitions["PP-2000"], 1)
    local s_ItemAK = BRItemWeapon(nil, m_WeaponDefinitions["AK-74M"], 1)
    m_ItemDatabase:RegisterItem(s_ItemPP2000)
    m_ItemDatabase:RegisterItem(s_ItemAK)
    s_Inventory:AddItem(s_ItemPP2000.m_Id)
    s_Inventory:AddItem(s_ItemAK.m_Id)

    local s_ItemAttachment = BRItemAttachment(nil, m_AttachmentDefinitions["ACOG"], nil)
    m_ItemDatabase:RegisterItem(s_ItemAttachment)
    s_Inventory:AddItem(s_ItemAttachment.m_Id)

    local s_ItemAmmo1 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"], 30)
    local s_ItemAmmo2 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"], 24)
    local s_ItemAmmo3 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"], 30)
    m_ItemDatabase:RegisterItem(s_ItemAmmo1)
    m_ItemDatabase:RegisterItem(s_ItemAmmo2)
    m_ItemDatabase:RegisterItem(s_ItemAmmo3)
    s_Inventory:AddItem(s_ItemAmmo1.m_Id)
    s_Inventory:AddItem(s_ItemAmmo2.m_Id)
    s_Inventory:AddItem(s_ItemAmmo3.m_Id)

    local s_ItemArmor = BRItemArmor(nil, m_ArmorDefinitions["BasicArmor"], nil)
    m_ItemDatabase:RegisterItem(s_ItemArmor)
    s_Inventory:AddItem(s_ItemArmor.m_Id)

    local s_ItemHelmet = BRItemHelmet(nil, m_HelmetDefinitions["BasicHelmet"], nil)
    m_ItemDatabase:RegisterItem(s_ItemHelmet)
    s_Inventory:AddItem(s_ItemHelmet.m_Id)

    m_Logger:Write(s_Inventory:AsTable())

    m_InventoryManager:AddInventory(s_Inventory)
end

return VuBattleRoyaleLootSystemServer()
