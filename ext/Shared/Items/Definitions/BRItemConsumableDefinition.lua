require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemConsumableDefinition", BRItemDefinition)

function BRItemConsumableDefinition:__init(p_UId, p_Name, p_Options)
    p_Options = p_Options or {}

    -- set fixed shared option values for consumables
    p_Options.Type = ItemType.Consumable
    p_Options.Mesh = nil--DC(Guid("6519E1BF-BB39-8B7F-47D9-1B4C365318D9"), Guid("BC6154A0-CDFC-D402-ECCA-444811062765")),
    p_Options.Price = 0

    -- call super's constructor and set shared options
    BRItemDefinition.__init(self, p_UId, p_Name, p_Options)

    -- The ammount of health you regenerate after using this item
    self.m_HealthToRegen = p_Options.HealthToRegen

    -- The time it takes to regenerate your health / use the item
    self.m_TimeToApply = p_Options.TimeToApply
end

return {
    ["consumable-small-medkit"] = BRItemConsumableDefinition(
        "consumable-small-medkit",
        "Small Medkit", 
        {
            Description = "A small medkit, it's gonna refill 25% of your health.",
            UIIcon = "UI/Art/Persistence/KitItem/Fancy/medkit",
            Weight = 15,
            Stackable = true,
            MaxStack = 5,
            HealthToRegen = 25,
            TimeToApply = 3
        }
    ),
    ["consumable-large-medkit"] = BRItemConsumableDefinition(
        "consumable-large-medkit",
        "Large Medkit", 
        {
            Description = "A large medkit, it's gonna refill 50% of your health.",
            UIIcon = "UI/Art/Persistence/KitItem/Fancy/medkit",
            Weight = 25,
            Stackable = true,
            MaxStack = 3,
            HealthToRegen = 50,
            TimeToApply = 5
        }
    ),
}
