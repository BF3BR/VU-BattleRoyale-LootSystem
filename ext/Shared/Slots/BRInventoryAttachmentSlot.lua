require "__shared/Enums/InventoryEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryAttachmentSlot", BRInventorySlot)

function BRInventoryAttachmentSlot:__init()
    BRInventorySlot.__init(self, { ItemType.Attachment })

    self.m_WeaponSlot = nil
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
    for l_Index, l_WeaponDefinition in ipairs(p_Item.m_Definition.m_CompatibleWith) do
        if s_WeaponItem.m_Definition:Equals(l_WeaponDefinition) then
            return true
        end
    end

    return false
end

function BRInventoryAttachmentSlot:SetWeaponSlot(p_WeaponSlot)
    self.m_WeaponSlot = p_WeaponSlot
end
