class "VuBattleRoyaleLootSystemClient"

require "__shared/Types/DataContainer"
require "__shared/Types/BRLootPickup"

require "__shared/Enums/CustomEvents"

require "__shared/Utils/Logger"

require "__shared/Items/BRItemWeapon"
require "__shared/Items/BRItemAmmo"
require "__shared/Items/BRItemArmor"
require "__shared/Items/BRItemHelmet"
require "__shared/Items/BRItemAttachment"
require "__shared/Items/BRItemConsumable"
require "__shared/Items/BRItemGadget"

require "Types/BRInventory"
require "Types/BRLooting"

require "ClientCommands"

local m_Logger = Logger("VuBattleRoyaleLootSystemClient", true)

function VuBattleRoyaleLootSystemClient:__init()
    Events:Subscribe("Extension:Loaded", self, self.OnExtensionLoaded)
    Events:Subscribe("Extension:Unloaded", self, self.OnExtensionUnloaded)
end

function VuBattleRoyaleLootSystemClient:OnExtensionLoaded()
    self:RegisterVars()
    self:RegisterEvents()
    self:RegisterWebUIEvents()
    self:RegisterCommands()

    WebUI:Init()
	WebUI:Show()
end

function VuBattleRoyaleLootSystemClient:OnExtensionUnloaded()
    self:UnregisterCommands()
end

function VuBattleRoyaleLootSystemClient:RegisterCommands()
    Console:Register("give", "Gives player items", ClientCommands.Give)
    Console:Register("spawn", "Spawns items under the player", ClientCommands.Spawn)
    Console:Register("list", "List all the items", ClientCommands.List)
end

function VuBattleRoyaleLootSystemClient:UnregisterCommands()
    Console:Deregister("give")
    Console:Deregister("spawn")
    Console:Deregister("list")
end

function VuBattleRoyaleLootSystemClient:RegisterVars()
	self.m_Invetnory = BRInventory()
	self.m_Looting = BRLooting()
end

function VuBattleRoyaleLootSystemClient:RegisterEvents()
	NetEvents:Subscribe(InventoryNetEvent.InventoryState, self, self.OnReceiveInventoryState)
    NetEvents:Subscribe(InventoryNetEvent.CreateLootPickup, self, self.OnCreateLootPickup)
    NetEvents:Subscribe(InventoryNetEvent.UnregisterLootPickup, self, self.OnUnregisterLootPickup)
    NetEvents:Subscribe(InventoryNetEvent.UpdateLootPickup, self, self.OnUpdateLootPickup)
end

function VuBattleRoyaleLootSystemClient:RegisterWebUIEvents()
	Events:Subscribe("WebUI:MoveItem", self, self.OnWebUIMoveItem)
    Events:Subscribe("WebUI:DropItem", self, self.OnWebUIDropItem)
    Events:Subscribe("WebUI:UseItem", self, self.OnWebUIUseItem)
    Events:Subscribe("WebUI:PickupItem", self, self.OnWebUIPickupItem)

	Events:Subscribe("Client:UpdateInput", self, self.OnClientUpdateInput)
end

function VuBattleRoyaleLootSystemClient:OnWebUIMoveItem(p_JsonData)
    self.m_Invetnory:OnWebUIMoveItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnWebUIDropItem(p_JsonData)
    self.m_Invetnory:OnWebUIDropItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnWebUIUseItem(p_JsonData)
    self.m_Invetnory:OnWebUIUseItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnWebUIPickupItem(p_JsonData)
    self.m_Invetnory:OnWebUIPickupItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnReceiveInventoryState(p_State)
    self.m_Invetnory:OnReceiveInventoryState(p_State)
end

function VuBattleRoyaleLootSystemClient:OnCreateLootPickup(p_DataArray)
	self.m_Looting:OnCreateLootPickup(p_DataArray)
end

function VuBattleRoyaleLootSystemClient:OnUnregisterLootPickup(p_LootPickupId)
    self.m_Looting:OnUnregisterLootPickup(p_LootPickupId)
end

function VuBattleRoyaleLootSystemClient:OnUpdateLootPickup(p_DataArray)
    self.m_Looting:OnUpdateLootPickup(p_DataArray)
end

function VuBattleRoyaleLootSystemClient:OnClientUpdateInput(p_Delta)
	self.m_Looting:OnClientUpdateInput(p_Delta)
end

return VuBattleRoyaleLootSystemClient()
