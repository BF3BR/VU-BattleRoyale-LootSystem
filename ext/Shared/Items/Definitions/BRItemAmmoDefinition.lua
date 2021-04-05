require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemAmmoDefinition", BRItemDefinition)

function BRItemAmmoDefinition:__init(
    p_Name, 
    p_Description,
    p_Weight,
    p_UIIcon,
    p_MaxStack
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Ammo
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = p_Weight
    self.m_Mesh = {
        Partition = Guid("677A72F6-D21E-BBE0-053C-FA6716A78EA2"),
        Instance = Guid("571C2D93-077A-166C-9C03-F6E592DC4BB2")
    }
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = true
    self.m_MaxStack = p_MaxStack
    self.m_Price = 0
end

return {
    ["556mm"] = BRItemAmmoDefinition(
        "5.56mm", 
        "The 5.56mm ammo is used for ARs."
        0.25,
        "UI/Art/Persistence/KitItem/Fancy/ammobag",
        60
    ),
    ["9mm"] = BRItemAmmoDefinition(
        "9mm", 
        "The 9mm ammo is used for SMGs and Pistols."
        0.1,
        "UI/Art/Persistence/KitItem/Fancy/ammobag",
        120
    ),
}
