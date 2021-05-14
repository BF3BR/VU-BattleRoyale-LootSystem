require "__shared/Enums/InventoryEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryWeaponSlot", BRInventorySlot)

function BRInventoryWeaponSlot:__init()
    BRInventorySlot.__init(self, { ItemType.Weapon })

    self.m_AttachmentSlots = {
        OpticsSlot = nil,
        BarrelSlot = nil,
        OtherSlot = nil
    }
end

-- Drop all attachments too when dropping a weapon
function BRInventoryWeaponSlot:Drop()
    -- Check if there is a weapon in the slot
    if self.m_Item == nil then
        return {}
    end

    local s_DroppedItems = {self.m_Item}
    for _, l_AttachmentSlot in pairs(self.m_AttachmentSlots) do
        local s_Items = l_AttachmentSlot:Drop()

        -- attachments only drop one item
        if #s_Items == 1 then
            table.insert(s_DroppedItems, s_Items[1])
        end
    end

    self:Clear()

    return s_DroppedItems
end

function BRInventoryWeaponSlot:SetAttachmentSlots(p_OpticsSlot, p_BarrelSlot, p_OtherSlot)
    self.m_AttachmentSlots = {
        OpticsSlot = p_OpticsSlot,
        BarrelSlot = p_BarrelSlot,
        OtherSlot = p_OtherSlot
    }
end
