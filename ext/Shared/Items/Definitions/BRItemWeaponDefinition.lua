require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"

class("BRItemWeaponDefinition", BRItemDefinition)

function BRItemWeaponDefinition:__init(
    p_Name, 
    p_Description,
    p_UIIcon,
    p_Mesh,
    p_SoldierWeaponBlueprint,
    p_AmmoDefinition,
    p_WeaponTier
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Weapon
    self.m_Name = p_Name
    self.m_Description = p_Description
    self.m_Weight = 0
    self.m_Mesh = p_Mesh
    self.m_UIIcon = p_UIIcon
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0

    self.m_SoldierWeaponBlueprint = p_SoldierWeaponBlueprint
    self.m_AmmoDefinition = p_AmmoDefinition
    self.m_WeaponTier = p_WeaponTier
end

return {
    ["AK-74M"] = BRItemWeaponDefinition(
        "AK-74M", 
        "The AK-74M is the latest modernized version of the classic AK-47."
        "UI/Art/Persistence/Weapons/Fancy/ak74m",
        {
            Partition = Guid("F365F081-D11B-B278-F6E3-062116758181"),
            Instance = Guid("8940BC20-0F27-1C19-58E6-CB07E1ADA643")
        },
        {
            Partition = Guid("A7C73A1A-ECD7-11DF-9B09-83A1F299B70D"),
            Instance = Guid("3AC0B0C2-BA58-9D83-F5EC-102A37A550BF")
        },
        m_AmmoDefinitions["556mm"],
        WeaponTier.Tier1
    ),
    ["PP-2000"] = BRItemWeaponDefinition(
        "PP-2000", 
        "The PP-2000 is a Russian machine pistol designed by the KBP Instrument Design Bureau and is classified as a Personal Defense Weapon (PDW)."
        "UI/Art/Persistence/Weapons/Fancy/pp2000",
        {
            Partition = Guid("BCAF822E-48AA-055F-E617-ECDD89799E22"),
            Instance = Guid("BE6743C4-8558-52DA-3AFE-5D5EAA7E188F")
        },
        {
            Partition = Guid("144442BD-173B-11E0-B7E4-E4E608316920"),
            Instance = Guid("4B357FE8-2B48-3238-D1CD-7DC2A200F5D5")
        },
        m_AmmoDefinitions["9mm"],
        WeaponTier.Tier1
    ),
}
