require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemArmorDefinition", BRItemDefinition)

function BRItemArmorDefinition:__init(
    p_UId,
    p_Name,
    p_Description,
    p_UIIcon,
    p_Tier,
    p_Durability,
    p_DamageReduction
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Armor
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = 0.0
    self.m_Mesh = nil -- TODO
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_Tier = p_Tier
    self.m_Durability = p_Durability
    self.m_DamageReduction = p_DamageReduction
end

return {
    ["armor-tier-1"] = BRItemArmorDefinition(
        "armor-tier-1",
        "Armor - Tier 1",
        "Adds +50 armor.",
        "UI/art/Persistence/Specializations/Fancy/Suppression", -- TODO: Swap this out
        Tier.Tier1,
        50,
        1
    ),
    ["armor-tier-2"] = BRItemArmorDefinition(
        "armor-tier-2",
        "Armor - Tier 2",
        "Adds +75 armor.",
        "UI/art/Persistence/Specializations/Fancy/Suppression", -- TODO: Swap this out
        Tier.Tier2,
        75,
        1
    ),
    ["armor-tier-3"] = BRItemArmorDefinition(
        "armor-tier-3",
        "Armor - Tier 3",
        "Adds +100 armor.",
        "UI/art/Persistence/Specializations/Fancy/Suppression", -- TODO: Swap this out
        Tier.Tier3,
        100,
        1
    ),
}
