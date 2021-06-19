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
local m_InventoryManager = require "BRInventoryManager"

class "BRInventory"

local m_Logger = Logger("BRInventory", true)

function BRInventory:__init(p_Owner)
    -- BRPlayer (or Player for now)
    self.m_Owner = p_Owner

    -- A table of slots
    self.m_Slots = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = BRInventoryWeaponSlot(self),
        [InventorySlot.PrimaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(self, AttachmentType.Optics),
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(self, AttachmentType.Barrel),
        [InventorySlot.PrimaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(self, AttachmentType.Other),
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = BRInventoryWeaponSlot(self),
        [InventorySlot.SecondaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(self, AttachmentType.Optics),
        [InventorySlot.SecondaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(self, AttachmentType.Barrel),
        [InventorySlot.SecondaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(self, AttachmentType.Other),
        -- Gadget slots
        [InventorySlot.Armor] = BRInventoryArmorSlot(self),
        [InventorySlot.Helmet] = BRInventoryHelmetSlot(self),
        [InventorySlot.Gadget] = BRInventoryGadgetSlot(self),
        -- Backpack slots
        [InventorySlot.Backpack1] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack2] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack3] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack4] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack5] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack6] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack7] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack8] = BRInventoryBackpackSlot(self),
        [InventorySlot.Backpack9] = BRInventoryBackpackSlot(self),
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

-- Returns the slot of an item or nil if item was not found
-- in this inventory
function BRInventory:GetItemSlot(p_ItemId)
    -- TODO maybe keep some inventory index for instant access
    for l_Index, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item ~= nil and l_Slot.m_Item.m_Id == p_ItemId then
            return l_Slot
        end
    end

    return nil
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
        s_Slot:Put(s_Item)
        m_Logger:Write("Item added to inventory. (" .. s_Item.m_Definition.m_Name .. ")")
    end

    self:SendState()
end

function BRInventory:SwapItems(p_ItemId, p_SlotId)
    -- TODO: Use slots instead of this also if possible merge items when we can
    local s_OldItem = self.m_Slots[p_SlotId].m_Item
    local s_Slot = self:GetItemSlot(p_ItemId)

    if s_Slot ~= nil and self.m_Slots[p_SlotId]:Put(s_Slot.m_Item) then
        s_Slot:Put(s_OldItem)

        m_Logger:Write("Slots swapped.")
        self:SendState()
    else
        m_Logger:Write("Item not found in your inventory.")
    end
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

function BRInventory:UseItem(p_ItemId)
    local s_Slot = self:GetItemSlot(p_ItemId)

    if s_Slot ~= nil then
        l_Slot:Use()
    end
end

function BRInventory:RemoveItem(p_ItemId)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        m_Logger:Write("Invalid item Id.")
        return false
    end

    local s_Slot = self:GetItemSlot(p_ItemId)
    if s_Slot ~= nil then
        s_Slot:Clear()

        m_ItemDatabase:UnregisterItem(p_ItemId)
        self:SendState()

        m_Logger:Write("Item removed from inventory. (" .. s_Item.m_Definition.m_Name .. ")")
        return true
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

function BRInventory:GetItemsByDefinition(p_Definition)
    local s_Items = {}

    for _, l_Slot in pairs(self.m_Slots) do
        if l_Slot:IsOfDefinition(p_Definition) then
            table.insert(s_Items, l_Slot.m_Item)
        end
    end

    return s_Items
end

function BRInventory:GetAmmoDefinition(p_WeaponName)
    if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_AmmoDefinition
        end
    end

    -- If we already found the ammo definition we don't need to check the secondary weapon slot
    if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_AmmoDefinition
        end
    end

    return nil
end

function BRInventory:GetCurrentPrimaryAmmo(p_WeaponName)
    if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_CurrentPrimaryAmmo
        end
    end

    -- If we already found the ammo definition we don't need to check the secondary weapon slot
    if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_CurrentPrimaryAmmo
        end
    end

    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.Gadget].m_Item.m_CurrentPrimaryAmmo
        end
    end

    return 0
end

function BRInventory:SetCurrentPrimaryAmmo(p_WeaponName, p_AmmoCount)
    if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            self.m_Slots[InventorySlot.PrimaryWeapon].m_Item.m_CurrentPrimaryAmmo = p_AmmoCount
        end
    end

    -- If we already found the ammo definition we don't need to check the secondary weapon slot
    if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item ~= nil then
        if self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_Definition.m_EbxName == p_WeaponName then
            self.m_Slots[InventorySlot.SecondaryWeapon].m_Item.m_CurrentPrimaryAmmo = p_AmmoCount
        end
    end

    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            self.m_Slots[InventorySlot.Gadget].m_Item.m_CurrentPrimaryAmmo = p_AmmoCount
        end
    end
end

function BRInventory:ChechIfLastShotForGadget(p_WeaponName)
    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            self.m_Slots[InventorySlot.Gadget].m_Item.m_Quantity = self.m_Slots[InventorySlot.Gadget].m_Item.m_Quantity - 1
            if self.m_Slots[InventorySlot.Gadget].m_Item.m_Quantity <= 0 then
                self:RemoveItem(self.m_Slots[InventorySlot.Gadget].m_Item.m_Id)
            end
            self:SendState()
        end
    end
end

function BRInventory:IsGadget(p_WeaponName)
    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return true
        end
    end

    return false
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

--==============================
-- Player / Soldier related functions
--==============================
function BRInventory:GetAmmoTypeCount(p_WeaponName)
    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.Gadget].m_Item.m_Quantity - self.m_Slots[InventorySlot.Gadget].m_Item.m_CurrentPrimaryAmmo
        end
    end

    local s_AmmoDefinition = self:GetAmmoDefinition(p_WeaponName)
    if s_AmmoDefinition == nil then
        return 0
    end

    local s_Sum = 0

    for l_Key, l_Slot in pairs(self.m_Slots) do
        if l_Slot.m_Item ~= nil then
            if l_Key >= InventorySlot.Backpack1 and l_Slot.m_Item.m_Definition:Equals(s_AmmoDefinition) then
                s_Sum = s_Sum + l_Slot.m_Item.m_Quantity
            end
        end
    end

    return s_Sum
end

-- @return The number of ammo that was successfully removed
function BRInventory:RemoveAmmo(p_WeaponName, p_Quantity)
    -- Handle all the Gadget related code here
    if self.m_Slots[InventorySlot.Gadget].m_Item ~= nil then
        if self.m_Slots[InventorySlot.Gadget].m_Item.m_Definition.m_EbxName == p_WeaponName then
            return self.m_Slots[InventorySlot.Gadget].m_Item.m_Quantity - 1
        end
    end


    local s_AmmoDefinition = self:GetAmmoDefinition(p_WeaponName)
    if s_AmmoDefinition == nil then
        return 0
    end

    -- Get similar ammo items
    local s_AmmoItems = self:GetItemsByDefinition(s_AmmoDefinition)

    -- Sort by quantity from low to high
    table.sort(s_AmmoItems, function (p_AmmoItemA, p_AmmoItemB)
        return p_AmmoItemA.m_Quantity < p_AmmoItemB.m_Quantity
    end)

    local s_QuantityLeftToRemove = p_Quantity
    for _, l_AmmoItem in ipairs(s_AmmoItems) do
        local s_QuantityRemoved = math.min(l_AmmoItem.m_Quantity, s_QuantityLeftToRemove)

        -- Update ammo item state
        l_AmmoItem.m_Quantity = l_AmmoItem.m_Quantity - s_QuantityRemoved
        if l_AmmoItem.m_Quantity <= 0 then
            self:RemoveItem(l_AmmoItem.m_Id)
        end

        -- Update quantity left to remove
        s_QuantityLeftToRemove = s_QuantityLeftToRemove - s_QuantityRemoved
        if s_QuantityLeftToRemove <= 0 then
            self:SendState()
            return p_Quantity
        end
    end

    self:SendState()
    return p_Quantity - s_QuantityLeftToRemove
end

function BRInventory:UpdateSoldierCustomization()
    if self.m_Owner == nil then
        return
    end

    if self.m_Owner.soldier == nil then
        return
    end

    self.m_Owner.soldier:ApplyCustomization(self:CreateCustomizeSoldierData())

    -- Reset primary ammo for each weapon
    for _, l_Weapon in ipairs(self.m_Owner.soldier.weaponsComponent.weapons) do
        l_Weapon.primaryAmmo = self:GetCurrentPrimaryAmmo(l_Weapon.name)
    end
end

function BRInventory:CreateCustomizeSoldierData()
    local s_CustomizeSoldierData = CustomizeSoldierData()
    s_CustomizeSoldierData.restoreToOriginalVisualState = false
    s_CustomizeSoldierData.clearVisualState = true
    s_CustomizeSoldierData.overrideMaxHealth = -1.0
    s_CustomizeSoldierData.overrideCriticalHealthThreshold = -1.0

    -- Primary weapon
    local s_PrimaryWeapon = self.m_Slots[InventorySlot.PrimaryWeapon]:GetUnlockWeaponAndSlot()
    if s_PrimaryWeapon ~= nil then
        s_PrimaryWeapon.slot = WeaponSlot.WeaponSlot_0
        s_CustomizeSoldierData.weapons:add(s_PrimaryWeapon)
    end

    -- Secondary weapon
    local s_SecondaryWeapon = self.m_Slots[InventorySlot.SecondaryWeapon]:GetUnlockWeaponAndSlot()
    if s_SecondaryWeapon ~= nil then
        s_SecondaryWeapon.slot = WeaponSlot.WeaponSlot_1
        s_CustomizeSoldierData.weapons:add(s_SecondaryWeapon)
    end

    -- Gadget
    local s_Gadget = self.m_Slots[InventorySlot.Gadget]:GetUnlockWeaponAndSlot()
    if s_Gadget ~= nil then
        s_Gadget.slot = WeaponSlot.WeaponSlot_2
        s_CustomizeSoldierData.weapons:add(s_Gadget)
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
