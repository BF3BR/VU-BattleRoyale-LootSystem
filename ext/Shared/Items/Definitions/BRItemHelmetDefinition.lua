require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemHelmetDefinition", BRItemDefinition)

function BRItemHelmetDefinition:__init(
    p_UId,
    p_Name,
    p_Durability,
    p_DamageReduction
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Helmet
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = "" -- TODO
    self.m_Weight = 0.0 -- TODO
    self.m_Mesh = nil -- TODO
    self.m_UIIcon = nil -- TODO
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_Durability = p_Durability
    self.m_DamageReduction = p_DamageReduction
end

return {
    ["helmet-basic"] = BRItemHelmetDefinition(
        "helmet-basic",
        "Basic Helmet",
        100,
        1
    ),
}
