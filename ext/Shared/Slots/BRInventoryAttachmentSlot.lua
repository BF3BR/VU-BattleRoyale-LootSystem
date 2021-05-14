require "__shared/Enums/InventoryEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryAttachmentSlot", BRInventorySlot)

function BRInventoryAttachmentSlot:__init(p_WeaponSlot, p_SlotType)
    BRInventorySlot.__init(self, {ItemType.Attachment})

    self.m_WeaponSlot = p_WeaponSlot
    self.m_SlotType = p_SlotType
end

function BRInventoryAttachmentSlot:IsAccepted(p_Item)
    -- Do the basic check
    if not BRInventorySlot.IsAccepted(self, p_Item) then
        return false
    end

    -- Check if weapon exists
    local s_WeaponItem = self.m_WeaponSlot.m_Item
    if s_WeaponItem == nil then
        return false
    end

    -- Check if compatible with weapon
    for l_Index, l_WeaponDefinition in ipairs(p_Item.m_CompatibleWith) do
        if p_Item.m_Definition:Equals(l_WeaponDefinition) then
            return true
        end
    end

    return false
end
