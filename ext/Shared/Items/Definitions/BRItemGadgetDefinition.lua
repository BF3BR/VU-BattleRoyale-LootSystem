require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemGadgetDefinition", BRItemDefinition)

function BRItemGadgetDefinition:__init(
    p_UId,
    p_Name, 
    p_Description,
    p_Weight,
    p_Mesh,
    p_UIIcon,
    p_MaxStack,
    p_SoldierWeaponBlueprint,
    p_EbxName,
    p_Transform
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Gadget
    self.m_UId = p_UId
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = p_Weight
    self.m_Mesh = p_Mesh
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = true
    self.m_MaxStack = p_MaxStack
    self.m_Price = 0
    self.m_Transform = p_Transform

    self.m_SoldierWeaponBlueprint = p_SoldierWeaponBlueprint
    self.m_EbxName = p_EbxName
end

return {
    ["gadget-m320-smoke"] = BRItemGadgetDefinition(
        "gadget-m320-smoke",
        "M320 Smoke",
        "The M320 Smoke is a variant of the M320 grenade launcher that fires smoke grenades.",
        5.0,
        DC(Guid("C1C59CFB-D2DD-5C43-CF76-4A465CB9007A"), Guid("579D4CB4-1937-D2CA-C7EA-23193B0B0B7B")),
        "UI/Art/Persistence/Weapons/Fancy/m320",
        3,
        DC(Guid("5407475F-7E82-44A8-99D2-8009B925A528"), Guid("2F200B5C-4958-467C-9E12-B99DDADE2332")),
        "Weapons/Gadgets/M320/M320",
        LinearTransform(
            Vec3(0,-1, 0),
            Vec3(1, 0, 0),
            Vec3(0, 0, 1),
            Vec3(-0.5, 0.04, -0.5)
        )
    ),
}
