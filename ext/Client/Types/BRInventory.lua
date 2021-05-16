

class "BRInventory"

require "__shared/Items/BRItem"

function BRInventory:__init()
    self.m_Slots = {}
end

-- =============================================
-- Events
-- =============================================

function BRInventory:OnReceiveInventoryState(p_State)
	if p_State == nil then
        return
	end

    for l_Index, l_Item in pairs(p_State) do
        local l_ReturnVal = { }

        if l_Item.Item ~= nil then
            local l_GeneratedItem = BRItem:CreateFromTable(l_Item.Item)
            if l_GeneratedItem ~= nil and l_GeneratedItem.m_Definition ~= nil then
                l_ReturnVal = {
                    Id = l_GeneratedItem.m_Id,
                    UId = l_GeneratedItem.m_Definition.m_UId,
                    Name = l_GeneratedItem.m_Definition.m_Name,
                    Type = l_GeneratedItem.m_Definition.m_Type,
                    Description = l_GeneratedItem.m_Definition.m_Description,
                    UIIcon = l_GeneratedItem.m_Definition.m_UIIcon,
                    Price = l_GeneratedItem.m_Definition.m_Price,
                    Quantity = l_GeneratedItem.m_Quantity
                }

                if l_GeneratedItem.m_Definition.m_Type == ItemType.Weapon then
                    l_ReturnVal.Tier = l_GeneratedItem.m_Definition.m_WeaponTier
                    l_ReturnVal.AmmoName = l_GeneratedItem.m_Definition.m_AmmoDefinition.m_Name
                elseif l_GeneratedItem.m_Definition.m_Type == ItemType.Helmet or 
                    l_GeneratedItem.m_Definition.m_Type == ItemType.Armor then
                    l_ReturnVal.Durability = l_GeneratedItem.m_Definition.m_Durability
                    l_ReturnVal.CurrentDurability = l_GeneratedItem.m_CurrentDurability
                end
            end
        end
        
        self.m_Slots[l_Index] = l_ReturnVal
    end
    self:SyncInventoryWithUI()
end

function BRInventory:AsTable()
    local s_Data = {}
    for l_Index, l_Item in ipairs(self.m_Slots) do
        s_Data[l_Index] = l_Item
    end
    return s_Data
end

--==============================
-- UI related functions
--==============================

function BRInventory:SyncInventoryWithUI()
    WebUI:ExecuteJS(string.format("SyncInventory(%s);", json.encode(self:AsTable())))
end

function BRInventory:OnWebUIMoveItem(p_JsonData)
    local s_DecodedData = json.decode(p_JsonData)

    -- Load params from the decoded JSON.
	local p_ItemId = s_DecodedData.item
	local p_SlotId = tonumber(s_DecodedData.slot) + 1

    if p_ItemId == nil or p_SlotId == nil then
        return
    end

    NetEvents:Send(InventoryNetEvent.MoveItem, p_ItemId, p_SlotId)
end


function BRInventory:OnWebUIDropItem(p_JsonData)
    local s_DecodedData = json.decode(p_JsonData)

    -- Load params from the decoded JSON.
	local p_ItemId = s_DecodedData.item

    if p_ItemId == nil then
        return
    end

    NetEvents:Send(InventoryNetEvent.DropItem, p_ItemId)
end
