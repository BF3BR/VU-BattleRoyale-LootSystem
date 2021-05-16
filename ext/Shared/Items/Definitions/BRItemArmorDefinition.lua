require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemArmorDefinition", BRItemDefinition)

function BRItemArmorDefinition:__init(
    p_UId,
    p_Name,
    p_UIIcon,
    p_Durability,
    p_DamageReduction
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Armor
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = "" -- TODO
    self.m_Weight = 0.0 -- TODO
    self.m_Mesh = nil -- TODO
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_Durability = p_Durability
    self.m_DamageReduction = p_DamageReduction
end

return {
    ["armor-basic"] = BRItemArmorDefinition(
        "armor-basic",
        "Basic Armor",
        "UI/art/Persistence/Specializations/Fancy/Suppression", -- TODO: Swap this out
        100,
        1
    ),
}
