require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryGadgetSlot", BRInventorySlot)

function BRInventoryGadgetSlot:__init()
    BRInventorySlot.__init(self, { ItemType.Gadget })
end
