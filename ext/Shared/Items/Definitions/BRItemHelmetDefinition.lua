require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"
require "__shared/Types/DataContainer"

class("BRItemHelmetDefinition", BRItemDefinition)

function BRItemHelmetDefinition:__init(
    p_UId,
    p_Name,
    p_Description,
    p_UIIcon,
    p_Tier,
    p_Durability,
    p_DamageReduction
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Helmet
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = 0.0 -- TODO
    self.m_Mesh = DC(Guid("0202751D-1ACE-3542-43E4-9BFFA6EF7F98"), Guid("9558CB54-0238-B2BD-643B-403FEE4A613D"))
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_Transform = LinearTransform(
        Vec3(1.2, 0, 0),
        Vec3(0, 1.2, 0),
        Vec3(0, 0, 1.2),
        Vec3(0, -1.2, 0)
    )

    self.m_Tier = p_Tier
    self.m_Durability = p_Durability
    self.m_DamageReduction = p_DamageReduction
end

return {
    ["helmet-tier-1"] = BRItemHelmetDefinition(
        "helmet-tier-1",
        "Helmet - Tier 1",
        "Adds +50 headshot protection.",
        "__helmet",
        Tier.Tier1,
        50,
        1
    ),
    ["helmet-tier-2"] = BRItemHelmetDefinition(
        "helmet-tier-2",
        "Helmet - Tier 2",
        "Adds +75 headshot protection.",
        "__helmet",
        Tier.Tier2,
        75,
        1
    ),
    ["helmet-tier-3"] = BRItemHelmetDefinition(
        "helmet-tier-3",
        "Helmet - Tier 3",
        "Adds +100 headshot protection.",
        "__helmet",
        Tier.Tier3,
        100,
        1
    ),
}
