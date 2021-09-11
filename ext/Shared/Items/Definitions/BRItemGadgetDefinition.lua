require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemGadgetDefinition", BRItemDefinition)

function BRItemGadgetDefinition:__init(p_UId, p_Name, p_Options)
    p_Options = p_Options or {}

    -- set fixed shared option values for gadgets
    p_Options.Type = ItemType.Gadget
    p_Options.Stackable = true
    p_Options.Price = 0

    -- call super's constructor and set shared options
    BRItemDefinition.__init(self, p_UId, p_Name, p_Options)

    -- set gadget only options
    self.m_SoldierWeaponBlueprint = p_Options.SoldierWeaponBlueprint
    self.m_EbxName = p_Options.EbxName
end

return {
    ["gadget-m320-smoke"] = BRItemGadgetDefinition(
        "gadget-m320-smoke",
        "M320 Smoke",
        {
            Description = "The M320 Smoke is a variant of the M320 grenade launcher that fires smoke grenades.",
            MaxStack = 3,
            RandomWeight = 100,
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/m320",
            EbxName = "Weapons/Gadgets/M320/M320",
            Mesh = DC(Guid("C1C59CFB-D2DD-5C43-CF76-4A465CB9007A"), Guid("579D4CB4-1937-D2CA-C7EA-23193B0B0B7B")),
            SoldierWeaponBlueprint = DC(Guid("5407475F-7E82-44A8-99D2-8009B925A528"), Guid("2F200B5C-4958-467C-9E12-B99DDADE2332")),
            Transform = LinearTransform(
                Vec3(1, 0, 0),
                Vec3(0, 1, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0, -0.35)
            )
        }
    ),
}
