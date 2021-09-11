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
local m_LootPickupDatabase = require "Types/BRLootPickupDatabase"

class "BRInventory"

local m_Logger = Logger("BRInventory", true)

function BRInventory:__init(p_Owner)
    -- BRPlayer (or Player for now)
    self.m_Owner = p_Owner

    -- A table of slots
    self.m_Slots = {
        -- PrimaryWeapon slots
        [InventorySlot.PrimaryWeapon] = BRInventoryWeaponSlot(self, WeaponSlot.WeaponSlot_0),
        [InventorySlot.PrimaryWeaponAttachmentOptics] = BRInventoryAttachmentSlot(self, AttachmentType.Optics),
        [InventorySlot.PrimaryWeaponAttachmentBarrel] = BRInventoryAttachmentSlot(self, AttachmentType.Barrel),
        [InventorySlot.PrimaryWeaponAttachmentOther] = BRInventoryAttachmentSlot(self, AttachmentType.Other),
        -- SecondaryWeapon slots
        [InventorySlot.SecondaryWeapon] = BRInventoryWeaponSlot(self, WeaponSlot.WeaponSlot_1),
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

    self.m_UpdateCustomizationTimer = nil
end

function BRInventory:AsTable()
    local s_Data = {}

    -- Add only updated slots into the data that 
    -- will be sent to the client
    for l_SlotIndex = 1, 20 do
        local s_Slot = self.m_Slots[l_SlotIndex]
        if s_Slot.m_IsUpdated then
            s_Data[l_SlotIndex] = s_Slot:AsTable()
            s_Slot.m_IsUpdated = false
        end
    end

    return s_Data
end

function BRInventory:GetSlot(p_SlotIndex)
    return self.m_Slots[p_SlotIndex]
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

-- Returns the inventory slot of the currently equipped weapon
function BRInventory:GetCurrentWeaponSlot()
    if self.m_Owner == nil or self.m_Owner.soldier == nil then
        return
    end

    local s_WeaponSlot = self.m_Owner.soldier.weaponsComponent.currentWeaponSlot

    if s_WeaponSlot == WeaponSlot.WeaponSlot_0 then
        return self.m_Slots[InventorySlot.PrimaryWeapon]
    elseif s_WeaponSlot == WeaponSlot.WeaponSlot_1 then
        return self.m_Slots[InventorySlot.SecondaryWeapon]
    end

    return nil
end

-- TODO p_CreateLootPickup wont be needed when we will be sure that each item
-- will have a link to it's owner. Then we will only need to check if it's owner is
-- a LootPickup or not

function BRInventory:AddItem(p_ItemId, p_SlotIndex, p_CreateLootPickup)
    -- Check if item exists
    local s_Item = m_ItemDatabase:GetItem(p_ItemId)
    if s_Item == nil then
        m_Logger:Write("Invalid item Id.")
        return false
    end

    -- check if there's a free slot
    local s_Slot = self.m_Slots[p_SlotIndex]
    if s_Slot == nil then
        s_Slot = self:GetFirstAvailableSlot(s_Item)
    end

    -- get current weapon slot if item is weapon and no other slot
    -- is available
    if s_Slot == nil and s_Item:IsOfType(ItemType.Weapon) then
        s_Slot = self:GetCurrentWeaponSlot()

        if s_Slot ~= nil and not s_Slot:IsAccepted(s_Item) then
            s_Slot = nil
        end
    end

    -- check if no slot is found
    if s_Slot == nil then
        m_Logger:Write("No available slot in the inventory.")

        if p_CreateLootPickup then
            m_LootPickupDatabase:CreateBasicLootPickup(self.m_Owner.soldier.worldTransform, {s_Item})
        end

        return false
    end

    if s_Slot.m_Item ~= nil and s_Item.m_Definition.m_Stackable then
        local s_CurrentSlotItem = s_Slot.m_Item
        local s_NewQuantity = s_CurrentSlotItem.m_Quantity + s_Item.m_Quantity

        if s_NewQuantity <= s_Item.m_Definition.m_MaxStack then
            s_CurrentSlotItem:SetQuantity(s_NewQuantity)
            m_Logger:Write("(Less than maxstack) Item quantity updated to: " .. s_NewQuantity .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")
        else
            -- Set the current one to max stack
            s_CurrentSlotItem:SetQuantity(s_Item.m_Definition.m_MaxStack)
            m_Logger:Write("(More than maxstack) Item quantity updated to: " .. s_Item.m_Definition.m_MaxStack .. ". (" .. s_CurrentSlotItem.m_Definition.m_Name .. ")")

            -- TODO issue if s_NewQuantity bigger than MaxStack, it will only create one new item
            -- (although i guess, it shouldn't be)
            s_NewQuantity = math.min(math.abs(s_NewQuantity - s_Item.m_Definition.m_MaxStack), s_Item.m_Definition.m_MaxStack)
            local s_CreatedItem = m_ItemDatabase:CreateItem(s_Item.m_Definition, s_NewQuantity)
            self:AddItem(s_CreatedItem.m_Id, nil, true)

            m_ItemDatabase:UnregisterItem(p_ItemId)
        end
    else
        local _, s_DroppedItems = s_Slot:Put(s_Item)

        if #s_DroppedItems > 0 then
            m_LootPickupDatabase:CreateBasicLootPickup(self.m_Owner.soldier.worldTransform, s_DroppedItems)
        end

        m_Logger:Write("Item added to inventory. (" .. s_Item.m_Definition.m_Name .. ")")
    end

    self:SendState()
    return true
end

function BRInventory:SwapItems(p_ItemId, p_SlotId)
    local s_NewSlot = self.m_Slots[p_SlotId]
    local s_OldSlot = self:GetItemSlot(p_ItemId)

    -- check if item isn't in the inventory
    if s_OldSlot == nil then
        m_Logger:Write("Item not found in your inventory.")
        return
    end

    -- check if item can be put into the new slot
    if not s_NewSlot:IsAccepted(s_OldSlot.m_Item) then
        return
    end

    -- empty slots and keep dropped items
    local s_ReplacedItems = s_NewSlot:Drop()
    local s_NewItems = s_OldSlot:Drop()

    -- swap items
    s_NewSlot:PutWithRelated(s_NewItems)
    local _, s_RemainingItems = s_OldSlot:PutWithRelated(s_ReplacedItems)

    -- try to readd all the remaining items
    for _, l_Item in ipairs(s_RemainingItems) do
        self:AddItem(l_Item.m_Id)
    end

    self:SendState()
end

function BRInventory:DropItem(p_ItemId, p_Quantity)
    if self.m_Owner == nil or
       self.m_Owner.soldier == nil or
       self.m_Owner.soldier.worldTransform == nil then
        return
    end

    p_Quantity = p_Quantity or 0

    local s_Slot = self:GetItemSlot(p_ItemId)
    if s_Slot ~= nil then
        local l_DroppedItems = s_Slot:Drop(p_Quantity)
        m_LootPickupDatabase:CreateBasicLootPickup(self.m_Owner.soldier.worldTransform, l_DroppedItems)

        self:SendState()
    end
end

function BRInventory:DestroyItem(p_ItemId)
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

function BRInventory:GetFirstAvailableSlot(p_Item)
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

-- Returns the first weapon slot item with the specified weapon name
-- if it exists in the inventory
-- TODO not sure if good way to search for weapons cause we may have duplicates
function BRInventory:GetWeaponItemByName(p_WeaponName)
    for _, l_SlotIndex in pairs({InventorySlot.PrimaryWeapon, InventorySlot.SecondaryWeapon, InventorySlot.Gadget}) do
        local s_Slot = self.m_Slots[l_SlotIndex]
        if s_Slot:HasWeapon(p_WeaponName) then
            return s_Slot.m_Item
        end
    end

    return nil
end

function BRInventory:GetWeaponItemByWeaponSlot(p_WeaponSlot)
    if p_WeaponSlot == WeaponSlot.WeaponSlot_0 then
        return self:GetSlot(InventorySlot.PrimaryWeapon).m_Item
    elseif p_WeaponSlot == WeaponSlot.WeaponSlot_1 then
        return self:GetSlot(InventorySlot.SecondaryWeapon).m_Item
    elseif p_WeaponSlot == WeaponSlot.WeaponSlot_2 then
        return self:GetSlot(InventorySlot.Gadget).m_Item
    end

    return nil
end

function BRInventory:GetAmmoDefinition(p_WeaponName)
    local s_Item = self:GetWeaponItemByName(p_WeaponName)
    return (s_Item ~= nil and s_Item.m_Definition.m_AmmoDefinition) or nil
end

function BRInventory:GetSavedPrimaryAmmo(p_WeaponSlot)
    local s_Item = self:GetWeaponItemByWeaponSlot(p_WeaponSlot)
    return (s_Item ~= nil and s_Item.m_CurrentPrimaryAmmo) or 0
end

function BRInventory:SavePrimaryAmmo(p_WeaponSlot, p_AmmoCount)
    local s_Item = self:GetWeaponItemByWeaponSlot(p_WeaponSlot)
    return s_Item ~= nil and s_Item:SetPrimaryAmmo(p_AmmoCount)
end

-- Sends the state of the inventory to its owner
function BRInventory:SendState()
    if self.m_Owner == nil then
        return
    end

    NetEvents:SendToLocal(InventoryNetEvent.InventoryState, self.m_Owner, self:AsTable())
end

-- Destroys the `BRInventory` instance
function BRInventory:Destroy()
    -- TODO probably needs some more things to cleanup
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
    local s_GadgetSlot = self.m_Slots[InventorySlot.Gadget]
    if s_GadgetSlot.m_Item ~= nil and s_GadgetSlot:HasWeapon(p_WeaponName) then
        return s_GadgetSlot.m_Item.m_Quantity - s_GadgetSlot.m_Item.m_CurrentPrimaryAmmo
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
    local s_GadgetSlot = self.m_Slots[InventorySlot.Gadget]
    local s_GadgetItem = s_GadgetSlot.m_Item
    if s_GadgetItem ~= nil and s_GadgetSlot:HasWeapon(p_WeaponName) then
        s_GadgetItem:SetQuantity(s_GadgetItem.m_Quantity - 1)
        s_GadgetSlot.m_IsUpdated = true

        if s_GadgetItem.m_Quantity == 0 then
            self:DestroyItem(s_GadgetItem.m_Id)
        else
            self:SendState()
        end

        return s_GadgetItem.m_Quantity - 1
    end

    -- Get ammo definition for this weapon
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
        l_AmmoItem:SetQuantity(l_AmmoItem.m_Quantity - s_QuantityRemoved)
        if l_AmmoItem.m_Quantity <= 0 then
            self:DestroyItem(l_AmmoItem.m_Id)
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

function BRInventory:DeferUpdateSoldierCustomization()
    if self.m_UpdateCustomizationTimer ~= nil then
        self.m_UpdateCustomizationTimer:Destroy()
        self.m_UpdateCustomizationTimer = nil
    end

    self.m_UpdateCustomizationTimer = g_Timers:Timeout(0.12, self, self.UpdateSoldierCustomization)
end

function BRInventory:UpdateSoldierCustomization()
    if self.m_Owner == nil or self.m_Owner.soldier == nil then
        return
    end

    -- This one is called because a change in some slots causes a
    -- complete change in customization so it may have some side-effects
    -- to unrelated slots
    for _, l_Slot in pairs(self.m_Slots) do
        l_Slot:BeforeCustomizationApply()
    end

    self.m_Owner.soldier:ApplyCustomization(self:CreateCustomizeSoldierData())

    -- Reset primary ammo for each weapon
    for l_WeaponSlot, l_Weapon in pairs(self.m_Owner.soldier.weaponsComponent.weapons) do
        if l_Weapon ~= nil then
            l_Weapon.primaryAmmo = self:GetSavedPrimaryAmmo(l_WeaponSlot - 1)
            l_Weapon.secondaryAmmo = self:GetAmmoTypeCount(l_Weapon.name)
        end
    end
end

function BRInventory:UpdateWeaponSecondaryAmmo()
    if self.m_Owner == nil or self.m_Owner.soldier == nil then
        return
    end

    for _, l_Weapon in pairs(self.m_Owner.soldier.weaponsComponent.weapons) do
        if l_Weapon ~= nil then
            l_Weapon.secondaryAmmo = self:GetAmmoTypeCount(l_Weapon.name)
        end
    end
end

function BRInventory:CreateCustomizeSoldierData()
    local s_CustomizeSoldierData = CustomizeSoldierData()
    s_CustomizeSoldierData.restoreToOriginalVisualState = false
    s_CustomizeSoldierData.clearVisualState = true
    s_CustomizeSoldierData.overrideMaxHealth = -1.0
    s_CustomizeSoldierData.overrideCriticalHealthThreshold = -1.0

    -- Update weapon and gadget slots
    local s_SlotIndexes = {InventorySlot.PrimaryWeapon, InventorySlot.SecondaryWeapon, InventorySlot.Gadget}
    for _, l_SlotIndex in pairs(s_SlotIndexes) do
        local s_UnlockWeaponAndSlot = self.m_Slots[l_SlotIndex]:GetUnlockWeaponAndSlot()
        if s_UnlockWeaponAndSlot ~= nil then
            s_CustomizeSoldierData.weapons:add(s_UnlockWeaponAndSlot)
        end
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

function BRInventory:Destroy()
    if self.m_UpdateCustomizationTimer ~= nil then
        self.m_UpdateCustomizationTimer:Destroy()
        self.m_UpdateCustomizationTimer = nil
    end
end
