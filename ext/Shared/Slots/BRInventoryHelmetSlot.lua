require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryHelmetSlot", BRInventorySlot)

function BRInventoryHelmetSlot:__init()
    BRInventorySlot.__init(self, { ItemType.Helmet })
end
