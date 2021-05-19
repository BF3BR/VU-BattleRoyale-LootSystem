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
                local s_CreatedItem = m_ItemDatabase:CreateItem(s_Item.m_Definition, s_NewQuantity)
                self:AddItem(s_CreatedItem.m_Id)
            end

            m_ItemDatabase:UnregisterItem(p_ItemId)
        end
    else
        -- If the slot is empty / nil then we can just put the item there
        s_Slot:PutItem(s_Item)
        m_Logger:Write("Item added to inventory. (" .. s_Item.m_Definition.m_Name .. ")")
    end

    self:SendState()
end

function BRInventory:SwapItems(p_ItemId, p_SlotId)
    local s_SlotReplaced = self.m_Slots[p_SlotId].m_Item
    for l_Index, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item ~= nil and l_Slot.m_Item.m_Id == p_ItemId then
            if self.m_Slots[p_SlotId]:IsAccepted(l_Slot.m_Item) then
                self.m_Slots[p_SlotId].m_Item = l_Slot.m_Item
                self.m_Slots[l_Index].m_Item = s_SlotReplaced
                m_Logger:Write("Slots swapped.")
                self:SendState()
                return
            end
        end
    end

    m_Logger:Write("Item not found in your inventory.")
end

function BRInventory:DropItem(p_ItemId, p_Quantity)
    -- TODO: Use this later on 
    --[[for _, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item ~= nil and l_Slot.m_Item.m_Id == p_ItemId then
            l_Slot:Drop()
            return
        end
    end]]

    --TODO: Use p_Quantity for splitting

    self:RemoveItem(p_ItemId)
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        m_Logger:Write("Invalid item Id.")
        return false
    end

    for l_Index, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item ~= nil and l_Slot.m_Item.m_Id == p_ItemId then
            l_Slot.m_Item = nil
            m_ItemDatabase:UnregisterItem(p_ItemId)
            m_Logger:Write("Item removed from inventory. (" .. s_Item.m_Definition.m_Name .. ")")
            self:SendState()
            return true
        end
    end

    m_Logger:Write("Item not found in any slot.")
    return false
end

function BRInventory:GetAvailableSlot(p_Item)
    -- If the item is stackable then search for an existing item with same
    -- definition and available space first
    if p_Item.m_Definition.m_Stackable and p_Item.m_Definition.m_MaxStack ~= nil then
        for _, l_Slot in pairs(self.m_Slots) do
            if l_Slot.m_Item ~= nil and l_Slot:IsAvailable(p_Item) then
                return l_Slot
            end
        end
    end

    -- If we found a slot with the matching type and it is empty
    for _, l_Slot in pairs(self.m_Slots) do
        if l_Slot:IsAvailable(p_Item) then
            return l_Slot
        end
    end

    return nil
end

function BRInventory:SendState()
    if self.m_Owner == nil then
        return
    end

    self:OnUpdate()

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

--==============================
-- Player / Soldier related functions
--==============================
function BRInventory:GetAmmoTypeCount(p_WeaponName)
    local s_Sum = 0
    local s_AmmoDefinition = nil

    if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            s_AmmoDefinition = self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_AmmoDefinition
        end
    end

    -- If we already found the ammo definition we don't need to check the secondary weapon slot
    if s_AmmoDefinition == nil then
        if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item ~= nil then
            if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
                s_AmmoDefinition = self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_AmmoDefinition
            end
        end
    end

    if s_AmmoDefinition == nil then
        return 0
    end

    for l_Key, l_Slot in pairs(self.m_Slots) do
        if l_Key >= InventorySlot.Backpack1 then
            if l_Slot.m_Item ~= nil then
                if l_Slot.m_Item.m_Definition:Equals(s_AmmoDefinition) then
                    s_Sum = s_Sum + l_Slot.m_Item.m_Quantity
                end
            end
        end
    end

    return s_Sum
end

function BRInventory:OnUpdate()
    if self.m_Owner == nil then
        return
    end

    if self.m_Owner.soldier == nil then
        return
    end

    self.m_Owner.soldier:ApplyCustomization(self:CreateCustomizeSoldierData())
end

function BRInventory:CreateCustomizeSoldierData()
	local s_CustomizeSoldierData = CustomizeSoldierData()
	s_CustomizeSoldierData.restoreToOriginalVisualState = false
	s_CustomizeSoldierData.clearVisualState = true
	s_CustomizeSoldierData.overrideMaxHealth = -1.0
	s_CustomizeSoldierData.overrideCriticalHealthThreshold = -1.0

    local function setAttachments(p_UnlockWeapon, p_WeaponSlot, p_AttachmentSlot)
        if self.m_Slots[p_AttachmentSlot].m_Item ~= nil then
            local s_AttachmentId = self.m_Slots[p_AttachmentSlot].m_Item.m_Definition.m_AttachmentId
            local s_UnlockAsset = UnlockAsset(
                self.m_Slots[p_WeaponSlot].m_Item.m_Definition.m_EbxAttachments[s_AttachmentId]:GetInstance()
            )
            p_UnlockWeapon.unlockAssets:add(s_UnlockAsset)
        else
            if p_AttachmentSlot == InventorySlot.PrimaryWeaponAttachmentOptics or 
                p_AttachmentSlot == InventorySlot.SecondaryWeaponAttachmentOptics 
            then
                local s_UnlockAsset = UnlockAsset(
                    self.m_Slots[p_WeaponSlot].m_Item.m_Definition.m_EbxAttachments[g_AttachmentIds.NoOptics]:GetInstance()
                )
                p_UnlockWeapon.unlockAssets:add(s_UnlockAsset)
            end
        end
	end

    if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item ~= nil then
        local s_PrimaryWeapon = UnlockWeaponAndSlot()
        s_PrimaryWeapon.weapon = SoldierWeaponUnlockAsset(
            self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_SoldierWeaponBlueprint:GetInstance()
        )
        setAttachments(s_PrimaryWeapon, InventorySlot.PrimaryWeapon, InventorySlot.PrimaryWeaponAttachmentOptics)
        setAttachments(s_PrimaryWeapon, InventorySlot.PrimaryWeapon, InventorySlot.PrimaryWeaponAttachmentBarrel)
        setAttachments(s_PrimaryWeapon, InventorySlot.PrimaryWeapon, InventorySlot.PrimaryWeaponAttachmentOther)
        s_PrimaryWeapon.slot = WeaponSlot.WeaponSlot_0
        s_CustomizeSoldierData.weapons:add(s_PrimaryWeapon)
    end

    if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item ~= nil then
        local s_SecondaryWeapon = UnlockWeaponAndSlot()
        s_SecondaryWeapon.weapon = SoldierWeaponUnlockAsset(
            self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_SoldierWeaponBlueprint:GetInstance()
        )
        setAttachments(s_SecondaryWeapon, InventorySlot.SecondaryWeapon, InventorySlot.SecondaryWeaponAttachmentOptics)
        setAttachments(s_SecondaryWeapon, InventorySlot.SecondaryWeapon, InventorySlot.SecondaryWeaponAttachmentBarrel)
        setAttachments(s_SecondaryWeapon, InventorySlot.SecondaryWeapon, InventorySlot.SecondaryWeaponAttachmentOther)
        s_SecondaryWeapon.slot = WeaponSlot.WeaponSlot_1
        s_CustomizeSoldierData.weapons:add(s_SecondaryWeapon)
    end

	local s_UnlockWeaponAndSlot = UnlockWeaponAndSlot()
	s_UnlockWeaponAndSlot.weapon = SoldierWeaponUnlockAsset(
        ResourceManager:FindInstanceByGuid(Guid("0003DE1B-F3BA-11DF-9818-9F37AB836AC2"),Guid("8963F500-E71D-41FC-4B24-AE17D18D8C73"))
    )
	s_UnlockWeaponAndSlot.slot = WeaponSlot.WeaponSlot_7
	s_CustomizeSoldierData.weapons:add(s_UnlockWeaponAndSlot)

	local s_UnlockWeaponAndSlot = UnlockWeaponAndSlot()
	s_UnlockWeaponAndSlot.weapon = SoldierWeaponUnlockAsset(
        ResourceManager:FindInstanceByGuid(Guid("7C58AA2F-DCF2-4206-8880-E32497C15218"),Guid("B145A444-BC4D-48BF-806A-0CEFA0EC231B"))
    )
	s_UnlockWeaponAndSlot.slot = WeaponSlot.WeaponSlot_9
	s_CustomizeSoldierData.weapons:add(s_UnlockWeaponAndSlot)

    s_CustomizeSoldierData.activeSlot = self.m_Owner.soldier.weaponsComponent.currentWeaponSlot
	s_CustomizeSoldierData.removeAllExistingWeapons = true
	s_CustomizeSoldierData.disableDeathPickup = false

	return s_CustomizeSoldierData
end
