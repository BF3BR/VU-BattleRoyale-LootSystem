

class "BRInventory"

function BRInventory:__init()
    self.m_Slots = nil
end

-- =============================================
-- Events
-- =============================================

function BRInventory:OnReceiveInventoryState(p_State)
	if p_State == nil then
        return
	end

    self.m_Slots = p_State
    self:SyncInventoryWithUI()
end

--==============================
-- UI related functions
--==============================

function BRInventory:SyncInventoryWithUI()
    WebUI:ExecuteJS(string.format("SyncInventory(%s);", json.encode(self.m_Slots)))
end
