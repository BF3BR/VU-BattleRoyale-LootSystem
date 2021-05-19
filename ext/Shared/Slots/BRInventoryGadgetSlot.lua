require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryGadgetSlot", BRInventorySlot)

function BRInventoryGadgetSlot:__init(p_Inventory)
    BRInventorySlot.__init(self, p_Inventory, { ItemType.Gadget })
end
