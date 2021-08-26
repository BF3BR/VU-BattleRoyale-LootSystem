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
    self.m_Mesh = DC(Guid("577909B4-EA3A-BF50-2B09-67278E0B0D7A"), Guid("163CAD89-E917-4B51-ED38-814A5F961C1C"))
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_Transform = LinearTransform(
        Vec3(1.2, 0, 0),
        Vec3(0, 1.2, 0),
        Vec3(0, 0, 1.2),
        Vec3(0, -0.75, 0)
    )

    self.m_Tier = p_Tier
    self.m_Durability = p_Durability
    self.m_DamageReduction = p_DamageReduction
end

return {
    ["armor-tier-1"] = BRItemArmorDefinition(
        "armor-tier-1",
        "Armor - Tier 1",
        "Adds +50 armor.",
        "__armor",
        Tier.Tier1,
        50,
        1
    ),
    ["armor-tier-2"] = BRItemArmorDefinition(
        "armor-tier-2",
        "Armor - Tier 2",
        "Adds +75 armor.",
        "__armor",
        Tier.Tier2,
        75,
        1
    ),
    ["armor-tier-3"] = BRItemArmorDefinition(
        "armor-tier-3",
        "Armor - Tier 3",
        "Adds +100 armor.",
        "__armor",
        Tier.Tier3,
        100,
        1
    ),
}
