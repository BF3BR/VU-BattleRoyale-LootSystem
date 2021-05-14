require "__shared/Enums/InventoryEnums"

require "__shared/Items/BRItem"

require "__shared/Slots/BRInventoryWeaponSlot"
require "__shared/Slots/BRInventoryAttachmentSlot"
require "__shared/Slots/BRInventoryArmorSlot"
require "__shared/Slots/BRInventoryHelmetSlot"
require "__shared/Slots/BRInventoryGadgetSlot"
require "__shared/Slots/BRInventoryBackpackSlot"

local m_ItemDatabase = require "__shared/Types/BRItemDatabase"

class "BRInventory"

function BRInventory:__init(p_Owner)
    -- BRPlayer (or Player for now)
    self.m_Owner = p_Owner

    -- A table of slots
    self.m_Slots = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = BRInventoryWeaponSlot(),
        [InventorySlot.PrimaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(),
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(),
        [InventorySlot.PrimaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(),
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = BRInventoryWeaponSlot(),
        [InventorySlot.SecondaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(),
        [InventorySlot.SecondaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(),
        [InventorySlot.SecondaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(),
        -- Gadget slots
        [InventorySlot.Armor] = BRInventoryArmorSlot(),
        [InventorySlot.Helmet] = BRInventoryHelmetSlot(),
        [InventorySlot.Gadget] = BRInventoryGadgetSlot(),
        -- Backpack slots
        [InventorySlot.Backpack1] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack2] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack3] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack4] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack5] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack6] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack7] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack8] = BRInventoryBackpackSlot(),
        [InventorySlot.Backpack9] = BRInventoryBackpackSlot(),
    }

    self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOptics]:SetWeaponSlot(self.m_Slots[InventorySlot.PrimaryWeapon])
    self.m_Slots[InventorySlot.PrimaryWeaponAttachmentBarrel]:SetWeaponSlot(self.m_Slots[InventorySlot.PrimaryWeapon])
    self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOther]:SetWeaponSlot(self.m_Slots[InventorySlot.PrimaryWeapon])

    self.m_Slots[InventorySlot.PrimaryWeapon]:SetAttachmentSlots(
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOptics],
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentBarrel],
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOther]
    )

    self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOptics]:SetWeaponSlot(self.m_Slots[InventorySlot.SecondaryWeapon])
    self.m_Slots[InventorySlot.SecondaryWeaponAttachmentBarrel]:SetWeaponSlot(self.m_Slots[InventorySlot.SecondaryWeapon])
    self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOther]:SetWeaponSlot(self.m_Slots[InventorySlot.SecondaryWeapon])

    self.m_Slots[InventorySlot.SecondaryWeapon]:SetAttachmentSlots(
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOptics],
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentBarrel],
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOther]
    )

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

function BRInventory:AsTable()
    return {
        self.m_Slots[InventorySlot.PrimaryWeapon]:AsTable(),
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOptics]:AsTable(),
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentBarrel]:AsTable(),
        self.m_Slots[InventorySlot.PrimaryWeaponAttachmentOther]:AsTable(),
        self.m_Slots[InventorySlot.SecondaryWeapon]:AsTable(),
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOptics]:AsTable(),
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentBarrel]:AsTable(),
        self.m_Slots[InventorySlot.SecondaryWeaponAttachmentOther]:AsTable(),
        self.m_Slots[InventorySlot.Armor]:AsTable(),
        self.m_Slots[InventorySlot.Helmet]:AsTable(),
        self.m_Slots[InventorySlot.Gadget]:AsTable(),
        self.m_Slots[InventorySlot.Backpack1]:AsTable(),
        self.m_Slots[InventorySlot.Backpack2]:AsTable(),
        self.m_Slots[InventorySlot.Backpack3]:AsTable(),
        self.m_Slots[InventorySlot.Backpack4]:AsTable(),
        self.m_Slots[InventorySlot.Backpack5]:AsTable(),
        self.m_Slots[InventorySlot.Backpack6]:AsTable(),
        self.m_Slots[InventorySlot.Backpack7]:AsTable(),
        self.m_Slots[InventorySlot.Backpack8]:AsTable(),
        self.m_Slots[InventorySlot.Backpack9]:AsTable(),
    }
end

function BRInventory:AddItem(p_ItemId, p_SlotIndex)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        print("Invalid item Id.")
        return
    end

    local s_Slot = nil
    if p_SlotIndex == nil then
        s_Slot = self:GetAvailableSlot(s_Item)
    end

    if s_Slot == nil then
        print("No available slot.")
        return
    end

    if s_Slot.m_Item ~= nil then
        local s_CurrentSlotItemTable = s_Slot.m_Item
        local s_NewQuantity = s_CurrentSlotItemTable.m_Quantity + s_Item.m_Quantity

        if s_NewQuantity <= s_Item.m_Definition.m_MaxStack then
            local s_CurrentSlotItem = m_ItemDatabase:GetItem(s_CurrentSlotItemTable.m_Id)
            s_CurrentSlotItem.m_Quantity = s_NewQuantity
            s_Slot.m_Item.m_Quantity = s_NewQuantity
            print("Item quantity updated to: " .. s_NewQuantity .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")
        else
            -- Set the current one to max stack
            local s_CurrentSlotItem = m_ItemDatabase:GetItem(s_CurrentSlotItemTable.m_Id)
            s_CurrentSlotItem.m_Quantity = s_Item.m_Definition.m_MaxStack
            s_Slot.m_Item.m_Quantity = s_NewQuantity
            print("Item quantity updated to: " .. s_Item.m_Definition.m_MaxStack .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")

            -- TODO: Create new item and put in other slots or drop if we don't have enough slots
        end
    else
        -- If the slot is empty / nil then we can just put the item there
        s_Slot.m_Item = s_Item
        print("Item added to inventory. (" .. s_Item.m_Definition.m_Name .. ")")
    end
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        print("Invalid item Id.")
        return false
    end

    for l_Index, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item.Id == s_Item.m_Id then
            self.m_Slots[l_Index].m_Item = nil
            print("Item removed from inventory. (" .. s_Item.m_Definition.m_Name .. ")")
            return true
        end
    end

    print("Item not found in any slot.")
    return false
end

function BRInventory:GetAvailableSlot(p_Item)
    if p_Item.m_Definition.m_Stackable and p_Item.m_Definition.m_MaxStack ~= nil then
        for _, l_Slot in pairs(self.m_Slots) do
            -- If we found a slot with the matching type and it is not empty
            if l_Slot:IsAccepted(p_Item) and l_Slot.m_Item ~= nil then
                if l_Slot.m_Item.m_Quantity < p_Item.m_Definition.m_MaxStack and 
                    l_Slot.m_Item.m_Definition.m_Type == p_Item.m_Definition.m_Type and 
                    l_Slot.m_Item.m_Definition.m_Name == p_Item.m_Definition.m_Name then
                    return l_Slot
                end
            end
        end
        
    end

    for _, l_Slot in pairs(self.m_Slots) do
        -- If we found a slot with the matching type and it is empty
        if l_Slot:IsAccepted(p_Item) and l_Slot.m_Item == nil then
            return l_Slot
        end
    end

    return nil
end
