require "__shared/Enums/InventoryEnums"
require "__shared/Items/BRItem"

local m_ItemDatabase = require "__shared/Types/BRItemDatabase"

class "BRInventory"

function BRInventory:__init(p_Owner)
    -- BRPlayer (or Player for now)
    self.m_Owner = p_Owner

    -- A table of slots
    self.m_Slots = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = nil,
        [InventorySlot.PrimaryWeaponAttachmentOptics] = nil,
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = nil,
        [InventorySlot.PrimaryWeaponAttachmentOther] = nil,
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = nil,
        [InventorySlot.SecondaryWeaponAttachmentOptics] = nil,
        [InventorySlot.SecondaryWeaponAttachmentBarrel] = nil,
        [InventorySlot.SecondaryWeaponAttachmentOther] = nil,
        -- Gadget slots
        [InventorySlot.Armor] = nil,
        [InventorySlot.Helmet] = nil,
        [InventorySlot.Gadget] = nil,
        -- Backpack slots
        [InventorySlot.Backpack1] = nil,
        [InventorySlot.Backpack2] = nil,
        [InventorySlot.Backpack3] = nil,
        [InventorySlot.Backpack4] = nil,
        [InventorySlot.Backpack5] = nil,
        [InventorySlot.Backpack6] = nil,
        [InventorySlot.Backpack7] = nil,
        [InventorySlot.Backpack8] = nil,
        [InventorySlot.Backpack9] = nil,
    }

    -- A table of items
    self.m_SlotValidators = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = { ItemType.Weapon },
        [InventorySlot.PrimaryWeaponAttachmentOptics] = { ItemType.Attachment },
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = { ItemType.Attachment },
        [InventorySlot.PrimaryWeaponAttachmentOther] = { ItemType.Attachment },
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = { ItemType.Weapon },
        [InventorySlot.SecondaryWeaponAttachmentOptics] = { ItemType.Attachment },
        [InventorySlot.SecondaryWeaponAttachmentBarrel] = { ItemType.Attachment },
        [InventorySlot.SecondaryWeaponAttachmentOther] = { ItemType.Attachment },
        -- Gadget slots
        [InventorySlot.Armor] = { ItemType.Armor },
        [InventorySlot.Helmet] = { ItemType.Helmet },
        [InventorySlot.Gadget] = { ItemType.Gadget },
        -- Backpack slots
        [InventorySlot.Backpack1] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack2] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack3] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack4] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack5] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack6] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack7] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack8] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
        [InventorySlot.Backpack9] = { ItemType.Attachment, ItemType.Gadget, ItemType.Consumable, ItemType.Ammo },
    }
end

function BRInventory:AddItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:FindById(p_ItemId)
    if s_Item == nil then
        print("Invalid item Id.")
        return
    end

    local s_AvailableSlotIndex = self:GetAvailableSlot(s_Item)

    if s_AvailableSlot == false then
        print("No available slot.")
        return
    end
    
    -- If the slot is empty / nil then we can just put the item there
    -- self.m_Slots[s_AvailableSlotIndex] = s_Item

    if self.m_Slots[s_AvailableSlotIndex] == nil then
        self.m_Slots[s_AvailableSlotIndex] = {}
    end

    table.insert(self.m_Slots[s_AvailableSlotIndex], s_Item)
    print("Item added to inventory. (" .. s_Item.Name .. ")")
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:FindFirstByID(p_ItemId)
    if s_Item == nil then
        print("Invalid item Id.")
        return false
    end

    for l_Index, l_Item in pairs(self.m_Slots) do
        if l_Item.Id == s_Item.Id then
            self.m_Slots[l_Index] = nil
            return true
        end
    end

    print("Item not found in any slot.")
    return false
end

function BRInventory:GetAvailableSlot(p_Item)
    local s_BrItem = BRItem:CreateFromTable(p_Item)

    if s_BrItem.m_Definition.m_Stackable and s_BrItem.m_Definition.m_MaxStack ~= nil then
        for l_Index, l_SlotValidatorItems in pairs(self.m_SlotValidators) do
            for _, l_Validator in pairs(l_SlotValidatorItems) do
                -- If we found a slot with the matching type and it is not empty
                if l_Validator == p_Item.Type and self.m_Slots[l_Index] ~= nil then
                    local l_Item = self.m_Slots[l_Index][1]
                    if l_Item.Type == p_Item.Type and l_Item.Name == p_Item.Name then
                        -- We found a slot where we have the same item and it is stackable
                        if (#self.m_Slots[l_Index] + 1) <= s_BrItem.m_Definition.m_MaxStack then
                            return l_Index
                        end
                    end
                end
            end
        end
    end

    for l_Index, l_SlotValidatorItems in pairs(self.m_SlotValidators) do
        for _, l_Validator in pairs(l_SlotValidatorItems) do
            -- If we found a slot with the matching type and it is empty
            if l_Validator == p_Item.Type and self.m_Slots[l_Index] == nil then
                return l_Index
            end
        end 
    end

    return false
end
