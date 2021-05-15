class "VuBattleRoyaleLootSystemClient"

require "__shared/Enums/CustomEvents"

require "__shared/Utils/Logger"

require "Types/BRInventory"

local m_Logger = Logger("VuBattleRoyaleLootSystemClient", true)

function VuBattleRoyaleLootSystemClient:__init()
    Events:Subscribe("Extension:Loaded", self, self.OnExtensionLoaded)
end

function VuBattleRoyaleLootSystemClient:OnExtensionLoaded()
    self:RegisterVars()
    self:RegisterEvents()

    WebUI:Init()
	WebUI:Show()
end

function VuBattleRoyaleLootSystemClient:RegisterVars()
	self.m_Invetnory = BRInventory()
end

function VuBattleRoyaleLootSystemClient:RegisterEvents()
	NetEvents:Subscribe(InventoryNetEvent.InventoryState, self, self.OnReceiveInventoryState)
end

function VuBattleRoyaleLootSystemClient:OnReceiveInventoryState(p_State)
    self.m_Invetnory:OnReceiveInventoryState(p_State)
end

return VuBattleRoyaleLootSystemClient()
