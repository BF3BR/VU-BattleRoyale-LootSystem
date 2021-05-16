class "VuBattleRoyaleLootSystemClient"

require "ClientCommands"

require "__shared/Types/DataContainer"

require "__shared/Enums/CustomEvents"

require "__shared/Utils/Logger"

require "__shared/Items/BRItemWeapon"
require "__shared/Items/BRItemAmmo"
require "__shared/Items/BRItemArmor"
require "__shared/Items/BRItemHelmet"
require "__shared/Items/BRItemAttachment"

require "Types/BRInventory"

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
end

function VuBattleRoyaleLootSystemClient:UnregisterCommands()
    Console:Deregister("give")
end

function VuBattleRoyaleLootSystemClient:RegisterVars()
	self.m_Invetnory = BRInventory()
end

function VuBattleRoyaleLootSystemClient:RegisterEvents()
	NetEvents:Subscribe(InventoryNetEvent.InventoryState, self, self.OnReceiveInventoryState)
end

function VuBattleRoyaleLootSystemClient:RegisterWebUIEvents()
	Events:Subscribe("WebUI:MoveItem", self, self.OnWebUIMoveItem)
    Events:Subscribe("WebUI:DropItem", self, self.OnWebUIDropItem)
end

function VuBattleRoyaleLootSystemClient:OnWebUIMoveItem(p_JsonData)
    self.m_Invetnory:OnWebUIMoveItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnWebUIDropItem(p_JsonData)
    self.m_Invetnory:OnWebUIDropItem(p_JsonData)
end

function VuBattleRoyaleLootSystemClient:OnReceiveInventoryState(p_State)
    self.m_Invetnory:OnReceiveInventoryState(p_State)
end

return VuBattleRoyaleLootSystemClient()
