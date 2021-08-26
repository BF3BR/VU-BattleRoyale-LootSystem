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
    p_Transform,
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
    self.m_Transform = p_Transform
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
    -- AR
    ["weapon-ak74m"] = BRItemWeaponDefinition(
        "weapon-ak74m",
        "AK-74M", 
        "The AK-74M is the latest modernized version of the classic AK-47.",
        "UI/Art/Persistence/Weapons/Fancy/ak74m",
        DC(Guid("F365F081-D11B-B278-F6E3-062116758181"), Guid("8940BC20-0F27-1C19-58E6-CB07E1ADA643")),
        LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0.04, -0.5)
        ),
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
    -- SMG
    ["weapon-pp2000"] = BRItemWeaponDefinition(
        "weapon-pp2000",
        "PP-2000", 
        "The PP-2000 is a Russian machine pistol designed by the KBP Instrument Design Bureau and is classified as a Personal Defense Weapon (PDW).",
        "UI/Art/Persistence/Weapons/Fancy/pp2000",
        DC(Guid("BCAF822E-48AA-055F-E617-ECDD89799E22"), Guid("BE6743C4-8558-52DA-3AFE-5D5EAA7E188F")),
        LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0.04, -0.5)
        ),
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
    -- Shotgun
    ["weapon-r870"] = BRItemWeaponDefinition(
        "weapon-r870",
        "Model 870", 
        "The Remington Model 870 is an American 12-gauge pump-action shotgun designed by Remington in 1951.",
        "UI/Art/Persistence/Weapons/Fancy/remington870",
        DC(Guid("244BD656-B62A-715A-FC6E-BCE517D4CE95"), Guid("B72B2A83-8B14-F5B3-3A31-844B2EC15EB6")),
        LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0.04, -0.5)
        ),
        DC(Guid("0B1B0AF6-75F5-4CA4-A945-372090333A83"), Guid("07A4C87A-D325-4A73-8C5A-C001ACD13334")),
        m_AmmoDefinitions["ammo-12-gauge"],
        Tier.Tier1,
        "Weapons/Remington870/Remington870MCS",
        {
			[g_AttachmentIds.Acog] = DC(Guid("71C5B115-4A29-11E0-A181-90CCED4B9CC9"), Guid("CEE0438E-062B-E1BF-582C-20DB3F413DDC")),
			[g_AttachmentIds.TargetPointer] = DC(Guid("D1BBE266-4A29-11E0-A181-90CCED4B9CC9"), Guid("88960C54-8753-975D-3254-95435B285084")),
			[g_AttachmentIds.EOTech] = DC(Guid("E17A3036-4A29-11E0-A181-90CCED4B9CC9"), Guid("4E616BB3-FC59-4700-6B9F-06BA21A2B47C")),
			[g_AttachmentIds.PKA] = DC(Guid("A05EDC46-4A29-11E0-A181-90CCED4B9CC9"), Guid("CBC40AC4-8415-0614-76BD-B933CF8BF2DB")),
			[g_AttachmentIds.RX01] = DC(Guid("CACC8636-4A29-11E0-A181-90CCED4B9CC9"), Guid("9C3F4908-6ADD-9A92-2ED6-813D4F1BAA7C")),
			[g_AttachmentIds.BuckshotShells] = DC(Guid("9F96740B-CE02-4120-B280-6A52A5BFE67B"), Guid("F2D71573-79F6-47FF-ADC4-305C24ADF81F")),
			[g_AttachmentIds.ExtendedMag] = DC(Guid("91B6C3F6-4A2A-11E0-A181-90CCED4B9CC9"), Guid("524F4B44-EABF-494F-9A1C-87A790CA65E6")),
			[g_AttachmentIds.IRNV] = DC(Guid("8B94E666-4A29-11E0-A181-90CCED4B9CC9"), Guid("1BAFE04F-AC41-C351-F9C3-038480696D75")),
			[g_AttachmentIds.PK_AS] = DC(Guid("A7B20356-4A29-11E0-A181-90CCED4B9CC9"), Guid("A4AFE9ED-5453-008B-31FD-537E061E74DF")),
			[g_AttachmentIds.M145] = DC(Guid("98901C96-4A29-11E0-A181-90CCED4B9CC9"), Guid("7450CDA7-067B-9A23-05C6-16D644DE3D12")),
			[g_AttachmentIds.Flashlight] = DC(Guid("83776A76-4A29-11E0-A181-90CCED4B9CC9"), Guid("1235B4DE-9880-0776-0E55-220F0D63553A")),
			[g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
			[g_AttachmentIds.FlechetteShells] = DC(Guid("D2A1E1EE-4997-11E0-B2FF-C5C18AA9A698"), Guid("B948A3F4-6278-E8A5-D025-B19363194AD7")),
			[g_AttachmentIds.FragShells] = DC(Guid("D7A678C1-4997-11E0-B2FF-C5C18AA9A698"), Guid("47D5B1CD-1852-9B0C-40E2-8BC55C7E0D0B")),
			[g_AttachmentIds.PKS_07] = DC(Guid("B2034F36-4A29-11E0-A181-90CCED4B9CC9"), Guid("08D5F51A-BC5C-9115-9B99-B3DD6DD6EF40")),
			[g_AttachmentIds.Silencer] = DC(Guid("64812092-D8E8-499E-8C0A-16C8424755EA"), Guid("83254D90-7E94-4D0B-A9AC-ACC57862C495")),
			[g_AttachmentIds.Kobra] = DC(Guid("92DC2696-4A29-11E0-A181-90CCED4B9CC9"), Guid("068E3303-FC3C-93C1-49E7-89EE4E00C86D")),
			[g_AttachmentIds.RifleScope] = DC(Guid("7A32FAB6-4A29-11E0-A181-90CCED4B9CC9"), Guid("30B8A845-6B34-D2EB-11C8-21C98EE5C3F6")),
			[g_AttachmentIds.FlashSuppressor] = DC(Guid("C9D7477D-4AF6-11E0-BE58-A4565229B5AA"), Guid("46BAA012-B1F4-9821-17A8-1557A08419C1")),
			[g_AttachmentIds.RifleScope] = DC(Guid("C31AEB76-4A29-11E0-A181-90CCED4B9CC9"), Guid("276362CA-4588-75F7-F9C2-7AE89D8907DA")),
			[g_AttachmentIds.PSO_1] = DC(Guid("B875DA46-4A29-11E0-A181-90CCED4B9CC9"), Guid("8927BB0B-F533-44A9-6A81-DE7511845715")),
			[g_AttachmentIds.SlugShells] = DC(Guid("DC41C10F-4997-11E0-B2FF-C5C18AA9A698"), Guid("DF5BC116-2245-E2AD-0A97-BB8DA7452208")),
		}
    ),
    -- Sniper
    ["weapon-m98b"] = BRItemWeaponDefinition(
        "weapon-m98b",
        "M98B", 
        "The M98B is a bolt-action sniper rifle produced by Barrett Firearms Manufacturing.",
        "UI/Art/Persistence/Weapons/Fancy/m98b",
        DC(Guid("4167372B-8261-610E-464F-E3666AF6DFF7"), Guid("7FC60BE5-28DC-F4A4-4176-508F73727830")),
        LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0.04, -0.6)
        ),
        DC(Guid("D61A38DA-17D0-4146-9305-100183EB3E5F"), Guid("05EB2892-8B51-488E-8956-4350C3D2BA27")),
        m_AmmoDefinitions["ammo-762mm"],
        Tier.Tier3,
        "Weapons/Model98B/Model_98B",
        {
			[g_AttachmentIds.Silencer] = DC(Guid("0E247925-4F08-11E0-A005-82E878F0C038"), Guid("67FA4E38-8810-517C-4F42-AD6BB737EAAB")),
			[g_AttachmentIds.TargetPointer] = DC(Guid("1F451FB8-4F09-11E0-A005-82E878F0C038"), Guid("9705B0BD-45F9-2504-8534-39F637EC2101")),
			[g_AttachmentIds.Acog] = DC(Guid("61E36091-4F05-11E0-A005-82E878F0C038"), Guid("CA1465A6-1673-3A89-2440-7DDE3CA410FB")),
			[g_AttachmentIds.EOTech] = DC(Guid("51717F91-4F06-11E0-A005-82E878F0C038"), Guid("501EF3B1-DEDB-3DC7-3BDC-4DA84CA1FE23")),
			[g_AttachmentIds.PKA] = DC(Guid("06FD81E1-4F07-11E0-A005-82E878F0C038"), Guid("513DD3D0-4C24-A1BF-5F79-9211CBA43C22")),
			[g_AttachmentIds.RX01] = DC(Guid("9C5E5821-4F07-11E0-A005-82E878F0C038"), Guid("50488EBC-7051-F594-C134-04421CC3D17B")),
			[g_AttachmentIds.RifleScope] = DC(Guid("2B46EDCE-4F06-11E0-A005-82E878F0C038"), Guid("1E77ED99-3D8C-0E1C-1CE5-FD337F6F9A0D")),
			[g_AttachmentIds.PK_AS] = DC(Guid("6B78AF06-78CF-481B-A0D6-BBE58660EFC6"), Guid("2D3F8FE0-8B46-4AFA-946A-99E06DFFAC33")),
			[g_AttachmentIds.M145] = DC(Guid("E12FB880-4F06-11E0-A005-82E878F0C038"), Guid("A9409FBA-972E-8723-B4EA-0E27FD4D6B71")),
			[g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
			[g_AttachmentIds.PKS_07] = DC(Guid("630760EB-4F07-11E0-A005-82E878F0C038"), Guid("37D07698-5EDB-B9C6-8D87-0501C6FEABCD")),
			[g_AttachmentIds.Flashlight] = DC(Guid("116FF9A6-4F09-11E0-A005-82E878F0C038"), Guid("2B60142D-8A73-657B-746A-A24E859E2626")),
			[g_AttachmentIds.Kobra] = DC(Guid("AB351812-4F06-11E0-A005-82E878F0C038"), Guid("F14AA4AE-1F4D-1693-6A11-F8A806B04CC7")),
			[g_AttachmentIds.StraightPullBolt] = DC(Guid("08BE1D7E-CA23-4536-A4A4-EBEE42F7FB99"), Guid("4753B64F-EED4-428A-8E9A-18218D23029E")),
			[g_AttachmentIds.PSO_1] = DC(Guid("7930236E-4F07-11E0-A005-82E878F0C038"), Guid("2AAFF0F1-A2B7-F23C-523A-982B3F4C1F47")),
			[g_AttachmentIds.IRNV] = DC(Guid("74324C88-4F06-11E0-A005-82E878F0C038"), Guid("F27793AE-0FFA-CD1B-BA01-C9213DFC24B9")),
			[g_AttachmentIds.Bipod] = DC(Guid("EC6B82FF-4F07-11E0-A005-82E878F0C038"), Guid("2872282D-7596-6D36-A99E-936AF3BE4977")),
		}
    ),
}
