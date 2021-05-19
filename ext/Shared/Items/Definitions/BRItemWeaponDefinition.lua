require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"
require "__shared/Types/DataContainer"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"

class("BRItemWeaponDefinition", BRItemDefinition)

function BRItemWeaponDefinition:__init(
    p_UId,
    p_Name,
    p_Description,
    p_UIIcon,
    p_Mesh,
    p_SoldierWeaponBlueprint,
    p_AmmoDefinition,
    p_Tier,
    p_EbxName,
    p_EbxAttachments
)
    BRItemDefinition.__init(self)

    self.m_Type = ItemType.Weapon
    self.m_UId = p_UId
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
    self.m_Tier = p_Tier
    self.m_EbxName = p_EbxName
    self.m_EbxAttachments = p_EbxAttachments
end

return {
    ["weapon-ak74m"] = BRItemWeaponDefinition(
        "weapon-ak74m",
        "AK-74M", 
        "The AK-74M is the latest modernized version of the classic AK-47.",
        "UI/Art/Persistence/Weapons/Fancy/ak74m",
        DC(Guid("F365F081-D11B-B278-F6E3-062116758181"), Guid("8940BC20-0F27-1C19-58E6-CB07E1ADA643")),
        DC(Guid("1556281A-0F0B-4EB3-B280-661018F8D52F"), Guid("3BA55147-6619-4697-8E2B-AC6B1D183C0E")),
        m_AmmoDefinitions["ammo-556mm"],
        Tier.Tier2,
        "Weapons/AK74M/AK74",
        {
			[g_AttachmentIds.EOTech] = DC(Guid("AE7B4C7E-3908-11E0-A679-E62A6140CBF0"), Guid("53B10FA8-2C64-BDB5-B195-6676EA575730")),
			[g_AttachmentIds.HeavyBarrel] = DC(Guid("2EA1A91D-39E7-11E0-9147-AA6D7C274595"), Guid("970517DD-DF94-9F1E-D246-4BBC923ADD4C")),
			[g_AttachmentIds.Foregrip] = DC(Guid("203AADED-39E7-11E0-9147-AA6D7C274595"), Guid("FFA22B1E-633E-537F-BE15-A58BCA32DCFC")),
			[g_AttachmentIds.PKA] = DC(Guid("D223FD17-3908-11E0-A679-E62A6140CBF0"), Guid("F5983896-20AE-125F-1B3E-8F422DBBF54C")),
			[g_AttachmentIds.PSO_1] = DC(Guid("F431D1CF-3908-11E0-A679-E62A6140CBF0"), Guid("E0FBAD99-AA15-38F0-BB9C-AB55A086014E")),
			[g_AttachmentIds.RifleScope] = DC(Guid("A5079A2B-3908-11E0-A679-E62A6140CBF0"), Guid("81024C65-D91A-9546-5D47-EDD4C847604E")),
			[g_AttachmentIds.PK_AS] = DC(Guid("DC7BF41D-3908-11E0-A679-E62A6140CBF0"), Guid("5ADC39D6-4957-1C4B-682A-D5040ADF6DC1")),
			[g_AttachmentIds.M145] = DC(Guid("C86B361A-3908-11E0-A679-E62A6140CBF0"), Guid("518454FA-2DC5-4A7F-FC95-4F21B7D6CF1D")),
			[g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
			[g_AttachmentIds.FlashSuppressor] = DC(Guid("CB3FF95E-390A-11E0-A679-E62A6140CBF0"), Guid("B0570767-B072-E4E4-069F-10046DF54988")),
			[g_AttachmentIds.PKS_07] = DC(Guid("E91AF196-3908-11E0-A679-E62A6140CBF0"), Guid("EC5A4B40-C4CD-3762-CB59-86897006B7C3")),
			[g_AttachmentIds.Flashlight] = DC(Guid("8100643D-39E7-11E0-9147-AA6D7C274595"), Guid("BDB563CE-C598-3107-65E7-151456A4958D")),
			[g_AttachmentIds.Kobra] = DC(Guid("C0F46F65-3908-11E0-A679-E62A6140CBF0"), Guid("880E0A7B-514C-4A22-09AF-B56D246FE2AE")),
			[g_AttachmentIds.TargetPointer] = DC(Guid("1159529C-39E7-11E0-9147-AA6D7C274595"), Guid("8761FF1B-4832-51AE-527E-1C59D161D50A")),
			[g_AttachmentIds.Silencer] = DC(Guid("1E7B5542-3909-11E0-A679-E62A6140CBF0"), Guid("ED2F3BF1-71F6-A4C3-20A8-A9ADDBACE6A6")),
			[g_AttachmentIds.Acog] = DC(Guid("24C4A78E-3A7B-11E0-9147-AA6D7C274595"), Guid("AF1F6E3C-32EE-F56C-619D-671A9B1C24C5")),
			[g_AttachmentIds.IRNV] = DC(Guid("B79705D0-3908-11E0-A679-E62A6140CBF0"), Guid("DC2D38D6-D065-CBE2-B9CD-1C1EE6419FD1")),
			[g_AttachmentIds.Bipod] = DC(Guid("5E6BD6BC-390E-11E0-A679-E62A6140CBF0"), Guid("049B5E44-9CA2-9567-0CEE-37B1FB6449D8")),
		}
    ),
    ["weapon-pp2000"] = BRItemWeaponDefinition(
        "weapon-pp2000",
        "PP-2000", 
        "The PP-2000 is a Russian machine pistol designed by the KBP Instrument Design Bureau and is classified as a Personal Defense Weapon (PDW).",
        "UI/Art/Persistence/Weapons/Fancy/pp2000",
        DC(Guid("BCAF822E-48AA-055F-E617-ECDD89799E22"), Guid("BE6743C4-8558-52DA-3AFE-5D5EAA7E188F")),
        DC(Guid("E104EF1F-807C-4576-A22A-CC849AE3EDB9"), Guid("50849B49-F3DA-4C92-9830-D4A2932BC9E7")),
        m_AmmoDefinitions["ammo-9mm"],
        Tier.Tier1,
        "Weapons/PP2000/PP2000",
        {
			[g_AttachmentIds.EOTech] = DC(Guid("F2D12B69-4A45-11E0-AA9B-CBCA7495985E"), Guid("7F8F73B8-AEF7-241F-2559-C37941DC4565")),
			[g_AttachmentIds.FlashSuppressor] = DC(Guid("10A2CBFD-8541-432D-921A-8BBD8110AF78"), Guid("B0D26918-D834-4BCE-997C-E9A1EC06B950")),
			[g_AttachmentIds.Acog] = DC(Guid("EA29121A-4A45-11E0-AA9B-CBCA7495985E"), Guid("15906BC5-A637-C139-A084-DE64814593CE")),
			[g_AttachmentIds.PKA] = DC(Guid("1BC7F87B-4A46-11E0-AA9B-CBCA7495985E"), Guid("42941B54-01FE-CDDC-9F67-64B919E62AD0")),
			[g_AttachmentIds.RX01] = DC(Guid("30B741AD-4A46-11E0-AA9B-CBCA7495985E"), Guid("4A95992B-D8E3-8CAF-4C4E-97D8B8C76127")),
			[g_AttachmentIds.PK_AS] = DC(Guid("23D75EA9-4A46-11E0-AA9B-CBCA7495985E"), Guid("EBDEEB65-6646-A050-ADF5-9DC4E6800001")),
			[g_AttachmentIds.M145] = DC(Guid("157AFB75-4A46-11E0-AA9B-CBCA7495985E"), Guid("B1408CA8-C458-EDFD-EF82-693D7138E4BA")),
			[g_AttachmentIds.ExtendedMag] = DC(Guid("982D4CDC-4A47-11E0-AA9B-CBCA7495985E"), Guid("E9123253-8A49-13FE-BA9B-6D99546F965E")),
			[g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
			[g_AttachmentIds.Flashlight] = DC(Guid("FA4EC854-4A45-11E0-AA9B-CBCA7495985E"), Guid("8AF58E26-4335-F57F-1723-D79915DF3599")),
			[g_AttachmentIds.Kobra] = DC(Guid("0E91BC94-4A46-11E0-AA9B-CBCA7495985E"), Guid("8F36AA18-9076-737A-7306-BD1D107EED5B")),
			[g_AttachmentIds.TargetPointer] = DC(Guid("40537397-4A46-11E0-AA9B-CBCA7495985E"), Guid("CC011055-8FDB-D785-D579-9F6F6A96B850")),
			[g_AttachmentIds.IRNV] = DC(Guid("05052EA8-4A46-11E0-AA9B-CBCA7495985E"), Guid("00B0B8B5-6FEC-D91E-3278-5BE193A7EF37")),
			[g_AttachmentIds.Silencer] = DC(Guid("38C5AA18-4A46-11E0-AA9B-CBCA7495985E"), Guid("FE2DF152-BCE9-0AB8-6C03-5B4D16D8E526")),
		}
    ),
}
