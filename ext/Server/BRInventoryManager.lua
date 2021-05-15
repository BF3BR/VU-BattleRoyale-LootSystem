require "__shared/Enums/CustomEvents"
require "Types/BRInventory"

class "BRInventoryManager"

local m_Logger = Logger("BRInventoryManager", true)

local m_ItemDatabase = require "Types/BRItemDatabase"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"
local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

function BRInventoryManager:__init()
	self:RegisterVars()
	self:RegisterEvents()
end

function BRInventoryManager:RegisterVars()
	-- [id] -> [BRInventory]
	self.m_Inventories = {}
end

function BRInventoryManager:RegisterEvents()
	NetEvents:Subscribe(InventoryNetEvent.InventoryGiveCommand, self, self.OnPlayerGiveCommand)
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

	local s_Definition = self:FindDefinitionByName(p_Args[1])

	if s_Definition == nil then
		m_Logger:Error("Invalid item definition name: " .. p_Args[1])
        return
	end

	local s_Inventory = self:GetPlayersInventory(p_Player, false)
	local s_CreatedItem = m_ItemDatabase:CreateItem(s_Definition, p_Args[2] ~= nil and p_Args[2] or 1)

	s_Inventory:AddItem(s_CreatedItem.m_Id)
	m_Logger:Write(s_Definition.m_Name .. " - Item given to player: " .. p_Player.name)
end

function BRInventoryManager:OnPlayerLeft(p_Player)
	m_Logger:Write(string.format("Destroying Inventory for '%s'", p_Player.name))

	local s_InventoryId = self:GetPlayersInventory(p_Player, true)
	if s_InventoryId ~= nil then
		self:RemoveInventory()
	end
end

-- Removes a BRInventory
-- @param p_InventoryId integer
function BRInventoryManager:RemoveInventory(p_InventoryId)
	-- destroy inventory and clear reference
    self.m_Inventories[p_InventoryId]:Destroy()
	self.m_Inventories[p_InventoryId] = nil
end

-- Adds a BRInventory
-- @param p_Inventory BRInventory
function BRInventoryManager:AddInventory(p_Inventory)
    table.insert(self.m_Inventories, p_Inventory)
end

function BRInventoryManager:GetPlayersInventory(p_Player, p_KeyOnly)
    for l_InventoryId, l_Inventory in pairs(self.m_Inventories) do
        if l_Inventory.m_Owner == p_Player then
			-- TODO we should use PlayerID for the inventory IDs for faster search
			if p_KeyOnly then
				return l_InventoryId
			end

            return l_Inventory
        end
	end
end

function BRInventoryManager:FindDefinitionByName(p_DefinitionName)
    for l_DefinitionKey, l_Definition in pairs(m_AmmoDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	for l_DefinitionKey, l_Definition in pairs(m_ArmorDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	for l_DefinitionKey, l_Definition in pairs(m_AttachmentDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	for l_DefinitionKey, l_Definition in pairs(m_ConsumableDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	for l_DefinitionKey, l_Definition in pairs(m_HelmetDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	for l_DefinitionKey, l_Definition in pairs(m_WeaponDefinitions) do
        if l_DefinitionKey == p_DefinitionName then
			return l_Definition
        end
	end

	return nil
end

-- define global
if g_BRInventoryManager== nil then
	g_BRInventoryManager = BRInventoryManager()
end

return g_BRInventoryManager
