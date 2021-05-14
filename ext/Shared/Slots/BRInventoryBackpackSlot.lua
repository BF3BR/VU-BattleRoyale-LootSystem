require "__shared/Enums/InventoryEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryBackpackSlot", BRInventorySlot)

function BRInventoryBackpackSlot:__init()
    BRInventorySlot.__init(self, { 
        ItemType.Attachment,
        ItemType.Ammo,
        ItemType.Consumable,
        ItemType.Gadget
    })
end
