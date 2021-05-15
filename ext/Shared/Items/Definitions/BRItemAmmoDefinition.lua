require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemAmmoDefinition", BRItemDefinition)

function BRItemAmmoDefinition:__init(
    p_UId,
    p_Name, 
    p_Description,
    p_Weight,
    p_Mesh,
    p_UIIcon,
    p_MaxStack
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Ammo
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = p_Weight
    self.m_Mesh = p_Mesh
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = true
    self.m_MaxStack = p_MaxStack
    self.m_Price = 0
end

return {
    ["ammo-556mm"] = BRItemAmmoDefinition(
        "ammo-556mm",
        "5.56mm", 
        "The 5.56mm ammo is used for ARs.",
        0.25,
        DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
        "UI/Art/Persistence/KitItem/Fancy/ammobag",
        60
    ),
    ["ammo-9mm"] = BRItemAmmoDefinition(
        "ammo-9mm",
        "9mm", 
        "The 9mm ammo is used for SMGs and Pistols.",
        0.1,
        DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
        "UI/Art/Persistence/KitItem/Fancy/ammobag",
        120
    ),
}
