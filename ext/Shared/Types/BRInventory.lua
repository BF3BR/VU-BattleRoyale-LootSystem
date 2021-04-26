class "BRInventory"

local m_ItemDatabase = require "__shared/Types/BRItemDatabase"

function BRInventory:__init()
    -- A table of items
    self.m_Items = {}
end

function BRInventory:AddItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:FindById(p_ItemId)
    if s_Item ~= nil then
        -- TODO: Check for available slot
    
        -- Add item to players inventory
        table.insert(self.m_Items, s_Item:AsTable())
    else
        print("Invalid item Id.")
    end
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:FindFirstByID(p_ItemId)
    if s_Item ~= nil then
        if #self.m_Items == 0 then
            return
        end
    
        for l_Index, l_Item in pairs(self.m_Items) do
            if l_Item.Id == s_Item.Id then
                table.remove(self.m_Items, l_Index)
                return
            end
        end
    else
        print("Invalid item Id.")
    end
end
