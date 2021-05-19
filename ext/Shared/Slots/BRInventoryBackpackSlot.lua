require "__shared/Enums/ItemEnums"
require "__shared/Slots/BRInventorySlot"

class("BRInventoryBackpackSlot", BRInventorySlot)

function BRInventoryBackpackSlot:__init(p_Inventory)
    BRInventorySlot.__init(self, p_Inventory, { 
        ItemType.Attachment,
        ItemType.Ammo,
        ItemType.Consumable,
        ItemType.Gadget
    })
end
