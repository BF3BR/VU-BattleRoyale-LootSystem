require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryArmorSlot", BRInventorySlot)

function BRInventoryArmorSlot:__init()
    BRInventorySlot.__init(self, { ItemType.Armor })
end
