-- TODO

--==============================
-- UI related functions
--==============================

function BRInventory:SyncInventoryWithUI()
    WebUI:ExecuteJS("SyncInventory(%s);", json.encode(self.m_Slots))
end
