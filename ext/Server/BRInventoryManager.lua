require "__shared/Enums/CustomEvents"
require "Types/BRInventory"

class "BRInventoryManager"

local m_Logger = Logger("BRInventoryManager", true)

function BRInventoryManager:__init()
	self:RegisterVars()
	self:RegisterEvents()
end

function BRInventoryManager:RegisterVars()
	-- [id] -> [BRInventory]
	self.m_Inventories = {}
end

function BRInventoryManager:RegisterEvents()
end

function BRInventoryManager:OnPlayerLeft(p_Player)
	m_Logger:Write(string.format("Destroying Inventory for '%s'", p_Player.name))

    for l_InventoryId, l_Inventory in pairs(self.m_Inventories) do
        if l_Inventory.m_Owner == p_Player then
            self:RemoveInventory(l_InventoryId)
        end
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

-- define global
if g_BRInventoryManager== nil then
	g_BRInventoryManager = BRInventoryManager()
end

return g_BRInventoryManager
