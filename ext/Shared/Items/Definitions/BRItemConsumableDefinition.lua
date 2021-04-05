require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemConsumableDefinition", BRItemDefinition)

function BRItemConsumableDefinition:__init(
    p_Name, 
    p_Description,
    p_Weight,
    p_UIIcon,
    p_Stackable,
    p_MaxStack,
    p_HealthToRegen, 
    p_TimeToApply
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Consumable
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = p_Weight
    self.m_Mesh = {
        Partition = Guid("2B73C280-C014-27BF-43FF-9C20ECF37D83"),
        Instance = Guid("089E7BEC-7195-C842-FFE0-0FCB634822F9")
    }
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = p_Stackable
    self.m_MaxStack = p_MaxStack
    self.m_Price = 0

    -- The ammount of health you regenerate after using this item
    self.m_HealthToRegen = p_HealthToRegen

    -- The time it takes to regenerate your health / use the item
    self.m_TimeToApply = p_TimeToApply
end

return {
    SmallMedkit = BRItemConsumableDefinition(
        "Small Medkit", 
        "A small medkit, it's gonna refill 25% of your health.",
        15,
        "UI/Art/Persistence/KitItem/Fancy/medkit",
        true,
        5,
        25, 
        3
    ),
    LargeMedkit = BRItemConsumableDefinition(
        "Large Medkit", 
        "A large medkit, it's gonna refill 50% of your health.",
        25,
        "UI/Art/Persistence/KitItem/Fancy/medkit",
        true,
        3,
        50, 
        5
    ),
}
