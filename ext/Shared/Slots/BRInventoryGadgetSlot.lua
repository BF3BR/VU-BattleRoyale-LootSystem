require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

local m_Logger = Logger("BRInventoryGadgetSlot", true)

class("BRInventoryGadgetSlot", BRInventorySlot)

function BRInventoryGadgetSlot:__init(p_Inventory)
    BRInventorySlot.__init(self, p_Inventory, { ItemType.Gadget })
end

function BRInventoryGadgetSlot:GetUnlockWeaponAndSlot()
    if self.m_Item == nil then
        return nil
    end

    -- Create gadget unlock
    local s_Gadget = UnlockWeaponAndSlot()
    s_Gadget.weapon = SoldierWeaponUnlockAsset(
        self.m_Item.m_Definition.m_SoldierWeaponBlueprint:GetInstance()
    )

    return s_Gadget
end

function BRInventoryGadgetSlot:OnUpdate()
    m_Logger:Write("Gadget slot updated")
    self.m_Inventory:UpdateSoldierCustomization()
end
