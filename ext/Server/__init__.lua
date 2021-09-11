class "VuBattleRoyaleLootSystemServer"

require "__shared/Utils/Logger"

require "__shared/Types/DataContainer"
require "__shared/Types/BRLootPickup"
require "Types/BRInventory"

require "__shared/Enums/ItemEnums"

require "__shared/Items/BRItemWeapon"
require "__shared/Items/BRItemAmmo"
require "__shared/Items/BRItemArmor"
require "__shared/Items/BRItemHelmet"
require "__shared/Items/BRItemAttachment"
require "__shared/Items/BRItemConsumable"
require "__shared/Items/BRItemGadget"

require "DebugCommands"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"
local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"
local m_GadgetDefinitions = require "__shared/Items/Definitions/BRItemGadgetDefinition"

local m_ItemDatabase = require "Types/BRItemDatabase"
local m_LootPickupDatabase = require "Types/BRLootPickupDatabase"

local m_InventoryManager = require "BRInventoryManager"

local m_Logger = Logger("VuBattleRoyaleLootSystemServer", true)

function VuBattleRoyaleLootSystemServer:__init()
    Events:Subscribe("Extension:Loaded", self, self.OnExtensionLoaded)
end

function VuBattleRoyaleLootSystemServer:OnExtensionLoaded()
    Events:Subscribe("Level:Loaded", self, self.OnLevelLoaded)
    Events:Subscribe("Level:Destroy", self, self.OnLevelDestroy)

    Events:Subscribe("Player:Respawn", self, self.OnPlayerRespawn)
    Events:Subscribe("Player:Left", self, self.OnPlayerLeft)

    -- TODO remove, just for reloading while testing
    local s_Players = PlayerManager:GetPlayers()
    for _, l_Player in ipairs(s_Players) do
        if l_Player ~= nil and l_Player.soldier ~= nil then
            self:OnPlayerAuthenticated(l_Player)
        end
    end
end

function VuBattleRoyaleLootSystemServer:OnPlayerLeft(p_Player)
    m_InventoryManager:OnPlayerLeft(p_Player)
end

function VuBattleRoyaleLootSystemServer:OnLevelDestroy(p_Player)
    m_LootPickupDatabase:OnLevelDestroy()
end

function VuBattleRoyaleLootSystemServer:OnLevelLoaded()
    local s_ItemAKSpawned = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-ak74m"])
    m_LootPickupDatabase:CreateBasicLootPickup(Vec3(21.276367, 10.880676, 3.685547), {s_ItemAKSpawned})

    local s_ItemAcogSpawned = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["attachment-acog"])
    local s_ItemHoloSpawned = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["attachment-holo"])
    m_LootPickupDatabase:CreateBasicLootPickup(
        Vec3(20.837891, 10.881640, 7.938477),
        {
            s_ItemAcogSpawned,
            s_ItemHoloSpawned
        }
    )

    local s_ItemHoloSpawned2 = m_ItemDatabase:CreateItem(m_AttachmentDefinitions["attachment-holo"])
    m_LootPickupDatabase:CreateBasicLootPickup(Vec3(21.837891, 10.881640, 7.938477), {s_ItemHoloSpawned2})

    local s_ItemM98b = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-m98b"])
    m_LootPickupDatabase:CreateBasicLootPickup(Vec3(21.047852, 10.881640, -0.941406), {s_ItemM98b})
end

function VuBattleRoyaleLootSystemServer:OnPlayerRespawn(p_Player)
    if p_Player == nil then
        return
    end

    local s_Inventory = m_InventoryManager:GetOrCreateInventory(p_Player)

    -- local s_ItemPP2000 = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-pp2000"])
    local s_ItemPP2000 = m_ItemDatabase:CreateItem(m_WeaponDefinitions["weapon-r870"])
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

    local s_ItemShotgun = m_ItemDatabase:CreateItem(m_AmmoDefinitions["ammo-12-gauge"], 80)
    s_Inventory:AddItem(s_ItemShotgun.m_Id)

    local s_ItemAmmo4 = m_ItemDatabase:CreateItem(m_AmmoDefinitions["ammo-9mm"], 80)
    s_Inventory:AddItem(s_ItemAmmo4.m_Id)

    local s_ItemArmor = m_ItemDatabase:CreateItem(m_ArmorDefinitions["armor-tier-2"])
    s_Inventory:AddItem(s_ItemArmor.m_Id)

    local s_ItemHelmet = m_ItemDatabase:CreateItem(m_HelmetDefinitions["helmet-tier-3"])
    s_Inventory:AddItem(s_ItemHelmet.m_Id)

    local s_ItemLargeMedkit = m_ItemDatabase:CreateItem(m_ConsumableDefinitions["consumable-large-medkit"])
    s_Inventory:AddItem(s_ItemLargeMedkit.m_Id)

    local s_ItemSmoke = m_ItemDatabase:CreateItem(m_GadgetDefinitions["gadget-m320-smoke"])
    s_Inventory:AddItem(s_ItemSmoke.m_Id)

    s_Inventory:DeferUpdateSoldierCustomization()
    s_Inventory:SendState()
end


return VuBattleRoyaleLootSystemServer()
