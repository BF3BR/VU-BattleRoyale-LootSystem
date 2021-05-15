require "__shared/Enums/ItemEnums"
require "__shared/Enums/CustomEvents"

require "__shared/Items/BRItem"

require "__shared/Slots/BRInventoryWeaponSlot"
require "__shared/Slots/BRInventoryAttachmentSlot"
require "__shared/Slots/BRInventoryArmorSlot"
require "__shared/Slots/BRInventoryHelmetSlot"
require "__shared/Slots/BRInventoryGadgetSlot"
require "__shared/Slots/BRInventoryBackpackSlot"

local m_ItemDatabase = require "Types/BRItemDatabase"

class "BRInventory"

local m_Logger = Logger("BRInventory", true)

function BRInventory:__init(p_Owner)
    -- BRPlayer (or Player for now)
    self.m_Owner = p_Owner

    -- A table of slots
    self.m_Slots = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = BRInventoryWeaponSlot(),
        [InventorySlot.PrimaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(AttachmentType.Optics),
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(AttachmentType.Barrel),
        [InventorySlot.PrimaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(AttachmentType.Other),
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = BRInventoryWeaponSlot(),
        [InventorySlot.SecondaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(AttachmentType.Optics),
        [InventorySlot.SecondaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(AttachmentType.Barrel),
        [InventorySlot.SecondaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(AttachmentType.Other),
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
        m_Logger:Write("Invalid item Id.")
        return p_ItemId
    end

    local s_Slot = nil
    if p_SlotIndex == nil then
        s_Slot = self:GetAvailableSlot(s_Item)
    end

    if s_Slot == nil then
        m_Logger:Write("No available slot in the inventory.")
        return p_ItemId
    end

    if s_Slot.m_Item ~= nil then
        local s_CurrentSlotItem = s_Slot.m_Item
        local s_NewQuantity = s_CurrentSlotItem.m_Quantity + s_Item.m_Quantity

        if s_NewQuantity <= s_Item.m_Definition.m_MaxStack then
            s_CurrentSlotItem.m_Quantity = s_NewQuantity
            s_Slot.m_Item.m_Quantity = s_NewQuantity
            m_Logger:Write("(Less than maxstack) Item quantity updated to: " .. s_NewQuantity .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")
        else
            -- Set the current one to max stack
            s_CurrentSlotItem.m_Quantity = s_Item.m_Definition.m_MaxStack
            s_Slot.m_Item.m_Quantity = s_Item.m_Definition.m_MaxStack
            m_Logger:Write("(More than maxstack) Item quantity updated to: " .. s_Item.m_Definition.m_MaxStack .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")

            s_NewQuantity = math.abs(s_NewQuantity - s_Item.m_Definition.m_MaxStack)
            if s_NewQuantity > s_Item.m_Definition.m_MaxStack then
                local s_CreatedItem = m_ItemDatabase:CreateItem(s_Item.m_Definition, s_Item.m_Definition.m_MaxStack)
                self:AddItem(s_CreatedItem.m_Id)
            else
                m_ItemDatabase:CreateItem(s_Item.m_Definition, s_NewQuantity)
                self:AddItem(s_CreatedItem.m_Id)
            end

            m_ItemDatabase:UnregisterItem(p_ItemId)
        end
    else
        -- If the slot is empty / nil then we can just put the item there
        s_Slot.m_Item = s_Item
        m_Logger:Write("Item added to inventory. (" .. s_Item.m_Definition.m_Name .. ")")
    end

    self:SendState()
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        m_Logger:Write("Invalid item Id.")
        return false
    end

    for l_Index, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item.Id == s_Item.m_Id then
            self.m_Slots[l_Index].m_Item = nil
            m_Logger:Write("Item removed from inventory. (" .. s_Item.m_Definition.m_Name .. ")")
            self:SendState()
            return true
        end
    end

    m_Logger:Write("Item not found in any slot.")
    return false
end

function BRInventory:GetAvailableSlot(p_Item)
    if p_Item.m_Definition.m_Stackable and p_Item.m_Definition.m_MaxStack ~= nil then
        for _, l_Slot in pairs(self.m_Slots) do
            -- If we found a slot with the matching type and it is not empty
            if l_Slot:IsAccepted(p_Item) and l_Slot.m_Item ~= nil then
                if l_Slot.m_Item.m_Quantity < p_Item.m_Definition.m_MaxStack and 
                    l_Slot.m_Item.m_Definition:Equals(p_Item.m_Definition) then
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

function BRInventory:SendState()
    if self.m_Owner == nil then
        return
    end

    NetEvents:SendToLocal(InventoryNetEvent.InventoryState, self.m_Owner, self:AsTable())
end

-- Destroys the `BRInventory` instance
function BRInventory:Destroy()
    self.m_Owner = nil
	self.m_Slots = {}
end

-- Garbage collector metamethod
function BRInventory:__gc()
	self:Destroy()
end

