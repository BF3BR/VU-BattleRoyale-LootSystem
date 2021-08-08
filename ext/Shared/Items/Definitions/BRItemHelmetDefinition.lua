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
    p_Mesh,
    p_Durability,
    p_DamageReduction
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Helmet
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = 0.0 -- TODO
    self.m_Mesh = p_Mesh
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

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
        DC(Guid("6C7CD38F-B420-A30D-B5ED-42844BFABDFF"), Guid("26841408-7C70-696E-1AD4-44EECC5014A8")),
        50,
        1
    ),
    ["helmet-tier-2"] = BRItemHelmetDefinition(
        "helmet-tier-2",
        "Helmet - Tier 2",
        "Adds +75 headshot protection.",
        "__helmet",
        Tier.Tier2,
        DC(Guid("6C7CD38F-B420-A30D-B5ED-42844BFABDFF"), Guid("26841408-7C70-696E-1AD4-44EECC5014A8")),
        75,
        1
    ),
    ["helmet-tier-3"] = BRItemHelmetDefinition(
        "helmet-tier-3",
        "Helmet - Tier 3",
        "Adds +100 headshot protection.",
        "__helmet",
        Tier.Tier3,
        DC(Guid("6C7CD38F-B420-A30D-B5ED-42844BFABDFF"), Guid("26841408-7C70-696E-1AD4-44EECC5014A8")),
        100,
        1
    ),
}
