require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"
require "__shared/Types/DataContainer"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"

class("BRItemWeaponDefinition", BRItemDefinition)

function BRItemWeaponDefinition:__init(p_UId, p_Name, p_Options)
    p_Options = p_Options or {}

    -- set fixed shared option values for weapons
    p_Options.Type = ItemType.Weapon
    p_Options.Stackable = false
    p_Options.MaxStack = nil
    p_Options.Price = 0

    -- call super's constructor and set shared options
    BRItemDefinition.__init(self, p_UId, p_Name, p_Options)

    self.m_SoldierWeaponBlueprint = p_Options.SoldierWeaponBlueprint
    self.m_AmmoDefinition = p_Options.AmmoDefinition
    self.m_Tier = p_Options.Tier
    self.m_EbxName = p_Options.EbxName
    self.m_EbxAttachments = p_Options.EbxAttachments
end

return {
    -- AR
    ["weapon-ak74m"] = BRItemWeaponDefinition(
        "weapon-ak74m",
        "AK-74M",
        {
            Description = "The AK-74M is the latest modernized version of the classic AK-47.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/ak74m",
            Mesh = DC(Guid("F365F081-D11B-B278-F6E3-062116758181"), Guid("8940BC20-0F27-1C19-58E6-CB07E1ADA643")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("1556281A-0F0B-4EB3-B280-661018F8D52F"), Guid("3BA55147-6619-4697-8E2B-AC6B1D183C0E")),
            AmmoDefinition = m_AmmoDefinitions["ammo-556mm"],
            Tier = Tier.Tier2,
            EbxName = "Weapons/AK74M/AK74",
            EbxAttachments = {
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
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-scar-h"] = BRItemWeaponDefinition(
        "weapon-scar-h",
        "SCAR-H",
        {
            Description = "The SCAR-H (SOF Combat Assault Rifle-Heavy), also designated Mk 17 Mod 0, is a modular Battle Rifle made by FN Herstal.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/scarh",
            Mesh = DC(Guid("219E7419-DAC8-57FA-1B75-4735722EA738"), Guid("8B9C95BC-03E6-DCF9-398F-193D543F1C55")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("26923311-294E-11E0-9658-B1395B1E88C3"), Guid("386F9329-7DE7-6FB9-1366-2877C698D9B7")),
            AmmoDefinition = m_AmmoDefinitions["ammo-556mm"],
            Tier = Tier.Tier2,
            EbxName = "Weapons/SCAR-H/SCAR-H",
            EbxAttachments = {
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("22D20A66-464D-11E0-8F08-8F7C75348787"), Guid("0C9E96BE-FE8D-AD08-2841-BF572E3ECC4F")),
                [g_AttachmentIds.RifleScope] = DC(Guid("C9A9842B-464A-11E0-8F08-8F7C75348787"), Guid("84AA1140-95AD-CD3F-0097-35EFB840F5E6")),
                [g_AttachmentIds.Foregrip] = DC(Guid("290834A6-464A-11E0-8F08-8F7C75348787"), Guid("ED28BFE1-36A6-18E9-E305-76041E959BFE")),
                [g_AttachmentIds.Acog] = DC(Guid("7337C95E-464A-11E0-8F08-8F7C75348787"), Guid("65454BA6-4B2D-0A0E-7B43-7B9432D9A312")),
                [g_AttachmentIds.EOTech] = DC(Guid("87E63A4A-464A-11E0-8F08-8F7C75348787"), Guid("27579A8F-2340-E21E-A87F-15457B5CE99A")),
                [g_AttachmentIds.PKA] = DC(Guid("AAA60146-464A-11E0-8F08-8F7C75348787"), Guid("398FB3F1-4790-C057-E867-D7B3228794EA")),
                [g_AttachmentIds.RX01] = DC(Guid("D05C88DC-464A-11E0-8F08-8F7C75348787"), Guid("77F0CF5F-E394-EDCA-4DEE-BD8268E6F370")),
                [g_AttachmentIds.IRNV] = DC(Guid("90EF1BE9-464A-11E0-8F08-8F7C75348787"), Guid("1B93C4E7-9872-5C94-5F4A-DD8652D7A236")),
                [g_AttachmentIds.PK_AS] = DC(Guid("EDF2B63D-C89F-4E20-9DC7-1BEAFEBC1194"), Guid("634C047E-0192-4530-8435-FF96293EC34C")),
                [g_AttachmentIds.M145] = DC(Guid("A3CEAC9D-464A-11E0-8F08-8F7C75348787"), Guid("41EB741A-B20A-090A-8774-192A62ECF441")),
                [g_AttachmentIds.BallisticScope] = DC(Guid("7FA3458D-464A-11E0-8F08-8F7C75348787"), Guid("0499421B-6C79-5685-5870-ABD4D112AB91")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.PKS_07] = DC(Guid("BBA5B074-464A-11E0-8F08-8F7C75348787"), Guid("85FC0273-5E9E-3FF4-CF24-4C01E524CCF8")),
                [g_AttachmentIds.Flashlight] = DC(Guid("507AADDD-464A-11E0-8F08-8F7C75348787"), Guid("FBA15CCA-F5A6-1D2F-9263-7B48EBF2C647")),
                [g_AttachmentIds.Kobra] = DC(Guid("9D1085A8-464A-11E0-8F08-8F7C75348787"), Guid("94F740BC-4D88-AED9-B38C-414499E3D85E")),
                [g_AttachmentIds.HeavyBarrel] = DC(Guid("635E86E9-464A-11E0-8F08-8F7C75348787"), Guid("5A2E2337-BDE9-37DE-78B5-DAA0020FB577")),
                [g_AttachmentIds.Silencer] = DC(Guid("59029B95-464A-11E0-8F08-8F7C75348787"), Guid("2B4F9046-42BE-F06B-6C17-34DF375A2335")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("47CBFCCB-464A-11E0-8F08-8F7C75348787"), Guid("2CA6EAA6-65B1-B9C5-96AA-06079FC5236E")),
                [g_AttachmentIds.PSO_1] = DC(Guid("C2D9597A-464A-11E0-8F08-8F7C75348787"), Guid("CABDF11F-75EA-8C55-6BB1-ACB3B8D65F03")),
                [g_AttachmentIds.Bipod] = DC(Guid("39CF85A5-464A-11E0-8F08-8F7C75348787"), Guid("23D119EF-C190-2BC1-EB01-97D050F62271")),
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-sg553lb"] = BRItemWeaponDefinition(
        "weapon-sg553lb",
        "SG553",
        {
            Description = "The SG553 is a slightly improved version of the SG552, the compact version of the SIG SG550, the standard rifle of the Swiss Army.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/sg553lb",
            Mesh = DC(Guid("C088B8E6-995D-A055-1600-2C04FF6EC76C"), Guid("BA91ABD1-6A01-102F-9416-0B941BE124F2")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("4217BE66-19E7-4AA6-A4AE-4B9AA3AD3172"), Guid("0733BF61-8EBC-4666-9610-7E27D7313791")),
            AmmoDefinition = m_AmmoDefinitions["ammo-556mm"],
            Tier = Tier.Tier1,
            EbxName = "Weapons/SG553LB/SG553LB",
            EbxAttachments = {
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("1211C3C1-489C-11E0-907E-DA79E000D689"), Guid("2C6740ED-0446-0F86-B5FC-0D62B6CF591E")),
                [g_AttachmentIds.RifleScope] = DC(Guid("87FD2706-489B-11E0-907E-DA79E000D689"), Guid("F0655F0D-5F77-40BB-A472-0A260CAA82E6")),
                [g_AttachmentIds.Foregrip] = DC(Guid("3BB3FE48-489C-11E0-907E-DA79E000D689"), Guid("379184A7-ECD6-06B3-3D4D-CC5ACF3213F3")),
                [g_AttachmentIds.Acog] = DC(Guid("01885B06-489A-11E0-907E-DA79E000D689"), Guid("9989E642-0ACC-66F5-C96D-B5C9CDF0A249")),
                [g_AttachmentIds.EOTech] = DC(Guid("5C07A7B2-489A-11E0-907E-DA79E000D689"), Guid("7AA2DC95-D840-35FC-96B5-FA0368E1918D")),
                [g_AttachmentIds.PKA] = DC(Guid("F2582C62-489A-11E0-907E-DA79E000D689"), Guid("41DE0842-07B5-25D2-2309-435DE1A863C8")),
                [g_AttachmentIds.RX01] = DC(Guid("B6D1910B-489B-11E0-907E-DA79E000D689"), Guid("32AD978A-12D7-105D-6AE6-4DB54234E44F")),
                [g_AttachmentIds.IRNV] = DC(Guid("8BE78C0D-489A-11E0-907E-DA79E000D689"), Guid("1DECBC87-0EEA-076E-76A8-0B838503CBD2")),
                [g_AttachmentIds.PK_AS] = DC(Guid("AB7AC69F-A81D-44D6-B051-3050C960ADC0"), Guid("F0D257E2-D9CA-4577-9FA1-240A2A8CCE72")),
                [g_AttachmentIds.M145] = DC(Guid("D813CB94-489A-11E0-907E-DA79E000D689"), Guid("8B67A567-9925-6900-6A17-48C2A7A471C4")),
                [g_AttachmentIds.BallisticScope] = DC(Guid("2DA4523B-489A-11E0-907E-DA79E000D689"), Guid("FD53F22C-A636-7EC6-E408-0DA7E977C076")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.PKS_07] = DC(Guid("CF32077A-48D2-11E0-8BC7-99E2959A5ACD"), Guid("8B807A68-854C-EFFB-33BA-EDB45D1A6ECE")),
                [g_AttachmentIds.Flashlight] = DC(Guid("22B9AD4D-48A2-11E0-907E-DA79E000D689"), Guid("BA658CA3-8DED-5EDA-299C-DA36ECFC12AD")),
                [g_AttachmentIds.Kobra] = DC(Guid("BA69DA6F-489A-11E0-907E-DA79E000D689"), Guid("656E32E7-A65D-1C76-239C-74F86EA197E7")),
                [g_AttachmentIds.HeavyBarrel] = DC(Guid("505BD9D3-48A4-11E0-907E-DA79E000D689"), Guid("2601C783-7A26-9153-A099-26FB729754BF")),
                [g_AttachmentIds.Silencer] = DC(Guid("D4370815-489B-11E0-907E-DA79E000D689"), Guid("B8D2AEF5-0E2C-26BB-3C06-516D3B1311DD")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("A4116B1A-48A2-11E0-907E-DA79E000D689"), Guid("5533E1A0-D9D6-2CDB-E98E-605AABD0087D")),
                [g_AttachmentIds.PSO_1] = DC(Guid("607A06CE-489B-11E0-907E-DA79E000D689"), Guid("B2C0BFA4-595C-5BC6-FBC6-D871212DC249")),
                [g_AttachmentIds.Bipod] = DC(Guid("26EE500C-489C-11E0-907E-DA79E000D689"), Guid("1D7AC7C8-5782-B63B-1D1D-3A5D6BD96504")),
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-an94"] = BRItemWeaponDefinition(
        "weapon-an94",
        "AN-94",
        {
            Description = "In service with elite Russian forces, the AN-94 offers a unique, highly accurate, 2 round burst feature. Compared to the standard AK series, the AN-94 requires a significantly higher degree of training. A skilled shooter can effectively engage targets at a longer range than typical Assault Rifles.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/an94",
            Mesh = DC(Guid("9CF3317A-3039-6BA0-0137-07A39C5DD153"), Guid("9B0A088E-364B-2A7D-B7DA-F06E2B43623E")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("AA415B68-DE3D-45D1-BBC6-BE7875E7AAB0"), Guid("65D4A9F9-0ACD-46FD-9AE2-3E9670DD22FB")),
            AmmoDefinition = m_AmmoDefinitions["ammo-556mm"],
            Tier = Tier.Tier1,
            EbxName = "Weapons/AN94/AN94",
            EbxAttachments = {
                [g_AttachmentIds.EOTech] = DC(Guid("7ED88526-43F1-11E0-8AED-CF7E2FF90416"), Guid("FD3468D4-AC00-FF42-78BC-11290BC980C0")),
                [g_AttachmentIds.HeavyBarrel] = DC(Guid("F99AB319-4410-11E0-9557-98D4E942F608"), Guid("063545C1-3E74-7E9E-6856-A8FA60C755D5")),
                [g_AttachmentIds.Foregrip] = DC(Guid("E2D46DC0-4406-11E0-8AED-CF7E2FF90416"), Guid("DB70D3E1-2482-DA06-5A4E-F5B7F99EEF2E")),
                [g_AttachmentIds.PKA] = DC(Guid("FE3DF319-43F1-11E0-8AED-CF7E2FF90416"), Guid("64CE5A15-61BB-FC70-3823-C17296F0204D")),
                [g_AttachmentIds.PSO_1] = DC(Guid("163A8C37-43F2-11E0-8AED-CF7E2FF90416"), Guid("BE6CAAF8-0AF8-9CE9-1D7E-6FF330ABA3CC")),
                [g_AttachmentIds.RifleScope] = DC(Guid("64BE9585-8D78-4149-B14E-8D4E3F7A8373"), Guid("0912DA98-886D-40BB-B54D-A8CE8C5C08C6")),
                [g_AttachmentIds.PK_AS] = DC(Guid("0501FECE-43F2-11E0-8AED-CF7E2FF90416"), Guid("5100E4E5-D18C-77BA-25A5-BE52347F0F56")),
                [g_AttachmentIds.M145] = DC(Guid("EAF64E52-43F1-11E0-8AED-CF7E2FF90416"), Guid("09D2BE6C-BD04-4D4F-0E57-691A255CFC57")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("B6F1D993-43F1-11E0-8AED-CF7E2FF90416"), Guid("1E6AB729-9F08-A3C7-AC5A-B6BF2C24FAB5")),
                [g_AttachmentIds.PKS_07] = DC(Guid("0E786AF0-43F2-11E0-8AED-CF7E2FF90416"), Guid("7BB5F0C6-6FCA-C083-144A-98CFD4B2B5BD")),
                [g_AttachmentIds.Flashlight] = DC(Guid("8A12F3FA-43F1-11E0-8AED-CF7E2FF90416"), Guid("EE4AD05F-DFE0-F135-D74C-D80842B8F8CD")),
                [g_AttachmentIds.Kobra] = DC(Guid("C968464F-43F1-11E0-8AED-CF7E2FF90416"), Guid("5B5C32A0-124A-9072-3411-4FFD30F74345")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("A1AA99F2-44B3-11E0-BB70-8A16583DD82F"), Guid("890FF6BD-8F31-DC33-0F58-E0E8ACE9AE83")),
                [g_AttachmentIds.Silencer] = DC(Guid("30EDCB9E-43F2-11E0-8AED-CF7E2FF90416"), Guid("4C26FC73-D47C-E78A-A87C-BB840BE77D5B")),
                [g_AttachmentIds.RX01] = DC(Guid("2964961D-43F2-11E0-8AED-CF7E2FF90416"), Guid("A1B6BF5B-DC08-3F8A-3C62-CF11AC8A8956")),
                [g_AttachmentIds.IRNV] = DC(Guid("BCD2AB69-43F1-11E0-8AED-CF7E2FF90416"), Guid("C499671A-DD3C-A5A3-861F-5ED8BE008766")),
                [g_AttachmentIds.Bipod] = DC(Guid("D73B61BF-4406-11E0-8AED-CF7E2FF90416"), Guid("1C8173B9-C962-E129-1F97-4BF7A6182B6D")),
                [g_AttachmentIds.Acog] = DC(Guid("76312E21-43F1-11E0-8AED-CF7E2FF90416"), Guid("38B8E412-68DE-9244-8156-5F196F053E11")),
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-famas"] = BRItemWeaponDefinition(
        "weapon-famas",
        "FAMAS",
        {
            Description = "Standard service rifle of the French military.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/XP1_FAMAS",
            Mesh = DC(Guid("A735154E-0510-ADA6-6F2E-83B5E6D830D2"), Guid("8F24FDE8-1C50-32A0-F6AB-BAE6C337D102")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.25)
            ),
            SoldierWeaponBlueprint = DC(Guid("A307F2D5-2649-42A9-99AE-8AA2CE3F0C4D"), Guid("9A97A9FE-DCE5-41E8-8D89-A421B103FA75")),
            AmmoDefinition = m_AmmoDefinitions["ammo-556mm"],
            Tier = Tier.Tier2,
            EbxName = "Weapons/XP1_FAMAS/FAMAS",
            EbxAttachments = {
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("4684DBC6-440B-11E0-A922-8C80A16DEDC4"), Guid("F6ED883F-8488-1FDA-425E-54C4EA79FCC5")),
                [g_AttachmentIds.HeavyBarrel] = DC(Guid("3E2C2E34-292D-49C2-A753-85CAEA503EAA"), Guid("5E6D30E7-3CCE-49A0-A76E-AF7507E7A9C8")),
                [g_AttachmentIds.Foregrip] = DC(Guid("A70250B3-440D-11E0-9F7E-F926C334D085"), Guid("BD081713-9879-4720-BBBF-406F876AD0EE")),
                [g_AttachmentIds.Acog] = DC(Guid("88A960A7-440A-11E0-818F-8858B7EFA47A"), Guid("55A8D1C2-CB3E-0A93-2A4D-BC4BB2516AC8")),
                [g_AttachmentIds.EOTech] = DC(Guid("B479B582-440A-11E0-818F-8858B7EFA47A"), Guid("5B0A17BB-465B-A3F8-6B11-B0AB42D6B83F")),
                [g_AttachmentIds.PKA] = DC(Guid("6796F885-440B-11E0-A922-8C80A16DEDC4"), Guid("5DD0C095-C79A-0EDE-86BC-B0620903900E")),
                [g_AttachmentIds.RX01] = DC(Guid("8F8D2DC3-440B-11E0-A922-8C80A16DEDC4"), Guid("2A322828-87E5-2D32-34F7-8DBC6113E2EF")),
                [g_AttachmentIds.IRNV] = DC(Guid("4C2F328F-440B-11E0-A922-8C80A16DEDC4"), Guid("CC0DEA5C-ACC5-2B2F-3F13-5902B514B395")),
                [g_AttachmentIds.PK_AS] = DC(Guid("A7C733BF-F339-4A28-95E0-27D5DD0D8CD2"), Guid("1F34B1FA-D0A2-4347-9B15-E4A7A7B95E5A")),
                [g_AttachmentIds.M145] = DC(Guid("58D32574-440B-11E0-A922-8C80A16DEDC4"), Guid("F4636ECF-EF95-75CC-EE3C-F272EBB3FC1A")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.PKS_07] = DC(Guid("7AD0E0D2-440B-11E0-A922-8C80A16DEDC4"), Guid("8975BAB6-EE06-3DEE-B444-A31C2FC739EE")),
                [g_AttachmentIds.Flashlight] = DC(Guid("3C2A728E-440B-11E0-A922-8C80A16DEDC4"), Guid("BC7527FF-17E4-D640-F84F-4A0064A41D0E")),
                [g_AttachmentIds.Kobra] = DC(Guid("52F33E05-440B-11E0-A922-8C80A16DEDC4"), Guid("5D879BA7-F8D5-614D-04F2-2E955F5F4DB8")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("A316E5EB-440B-11E0-A922-8C80A16DEDC4"), Guid("49CD4E11-AFE1-BD65-A2D1-52C11DAD37ED")),
                [g_AttachmentIds.Silencer] = DC(Guid("99DBFDEF-440B-11E0-A922-8C80A16DEDC4"), Guid("51311DDE-0E5A-021D-E5CD-3E603A529232")),
                [g_AttachmentIds.RifleScope] = DC(Guid("9952A2B4-440A-11E0-818F-8858B7EFA47A"), Guid("D65F736A-A8AA-FAD9-601C-E879611FC084")),
                [g_AttachmentIds.PSO_1] = DC(Guid("81113A39-440B-11E0-A922-8C80A16DEDC4"), Guid("06D9F699-8595-E9FA-8787-5DFC50ED90A7")),
                [g_AttachmentIds.Bipod] = DC(Guid("9FD6F507-440D-11E0-9F7E-F926C334D085"), Guid("811B61B8-3095-9189-3105-C829809DC0F6")),
            },
            RandomWeight = 15,
        }
    ),
    -- SMG
    ["weapon-pp2000"] = BRItemWeaponDefinition(
        "weapon-pp2000",
        "PP-2000", 
        {
            Description = "The PP-2000 is a Russian machine pistol designed by the KBP Instrument Design Bureau and is classified as a Personal Defense Weapon (PDW).",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/pp2000",
            Mesh = DC(Guid("BCAF822E-48AA-055F-E617-ECDD89799E22"), Guid("BE6743C4-8558-52DA-3AFE-5D5EAA7E188F")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("E104EF1F-807C-4576-A22A-CC849AE3EDB9"), Guid("50849B49-F3DA-4C92-9830-D4A2932BC9E7")),
            AmmoDefinition = m_AmmoDefinitions["ammo-9mm"],
            Tier = Tier.Tier1,
            EbxName = "Weapons/PP2000/PP2000",
            EbxAttachments = {
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
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-pp19"] = BRItemWeaponDefinition(
        "weapon-pp19",
        "PP-19", 
        {
            Description = "The PP-19 \"Bizon\" is a 9mm submachine gun developed in the early 1990s by a team headed by Victor Kalashnikov in the Izhevsk Machinebuilding Plant (now known as Kalashnikov Concern).",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/XP1_PP19",
            Mesh = DC(Guid("DAA8CB46-270B-44C3-87E3-9C0C34E036B6"), Guid("693A6341-B736-63D4-B531-0D6F79178F2D")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("773D1B6A-B8BC-4F9F-94FF-A6B531C9AD6F"), Guid("CECC74B7-403F-4BA1-8ECD-4A59FB5379BD")),
            AmmoDefinition = m_AmmoDefinitions["ammo-9mm"],
            Tier = Tier.Tier1,
            EbxName = "Weapons/XP1_PP-19/PP-19",
            EbxAttachments = {
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("1942EBE6-4579-11E0-85C8-A8D9337DE590"), Guid("4555697D-1BED-EB28-9364-B0B7F5B4AB27")),
                [g_AttachmentIds.Acog] = DC(Guid("0CD23A0B-457A-11E0-85C8-A8D9337DE590"), Guid("51627EC2-823B-DBAA-0B63-59CB6EB08E1C")),
                [g_AttachmentIds.EOTech] = DC(Guid("2461C2BB-457A-11E0-85C8-A8D9337DE590"), Guid("6C1F61A9-099D-4E2C-CD23-EC9B78675352")),
                [g_AttachmentIds.PKA] = DC(Guid("4C15273C-457A-11E0-85C8-A8D9337DE590"), Guid("0AF19A8F-9498-3912-12F0-0DD005760D58")),
                [g_AttachmentIds.RX01] = DC(Guid("A3EBCA7E-457A-11E0-85C8-A8D9337DE590"), Guid("9F75BA8B-25A7-2B7E-CC88-CD7A5003DEFF")),
                [g_AttachmentIds.PK_AS] = DC(Guid("531DA409-457A-11E0-85C8-A8D9337DE590"), Guid("8A6763C9-1BCA-1076-11D5-0EEF52F62164")),
                [g_AttachmentIds.M145] = DC(Guid("43038C5E-457A-11E0-85C8-A8D9337DE590"), Guid("C9AE4F92-20ED-4E27-B5EF-8A217C2CE901")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.Flashlight] = DC(Guid("0DBD8D08-4579-11E0-85C8-A8D9337DE590"), Guid("7CC5545E-DB90-31B8-9ABD-C8FB57851AB3")),
                [g_AttachmentIds.Kobra] = DC(Guid("34B4294A-457A-11E0-85C8-A8D9337DE590"), Guid("C0284CE8-CFC3-9953-995C-3FFE1A9DB808")),
                [g_AttachmentIds.IRNV] = DC(Guid("2C682B40-457A-11E0-85C8-A8D9337DE590"), Guid("8FF49186-DA06-3FF9-6518-862D060CB9FA")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("2EA4323B-4579-11E0-85C8-A8D9337DE590"), Guid("6C3C058E-8156-1320-1DC8-CF5D5D00E9F2")),
                [g_AttachmentIds.Silencer] = DC(Guid("23A06332-4579-11E0-85C8-A8D9337DE590"), Guid("F8E29AC5-4AA0-4E2F-8613-36C6D65A5008")),
            },
            RandomWeight = 15,
        }
    ),
    ["weapon-mp5k"] = BRItemWeaponDefinition(
        "weapon-mp5k",
        "MP5K", 
        {
            Description = "A tactical machine pistol based on one of the world's most successful submachine gun designs. With the shoulder stock completely removed and the shortened receiver, this ultra compact personal defense weapon is capable of very high rates of fire, as well as great stopping power at close range.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/XP2_MP5K",
            Mesh = DC(Guid("A9787E3D-E1C6-4FF9-BABF-7936AAC3C468"), Guid("D0D089BC-0006-0FB0-07E9-E125472D001F")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("87530EBC-4B95-4AEC-AFE1-0339D61A649A"), Guid("DFBF6EA5-39C5-4ABA-B2C6-CAA6AD6C3786")),
            AmmoDefinition = m_AmmoDefinitions["ammo-9mm"],
            Tier = Tier.Tier2,
            EbxName = "Weapons/XP2_MP5K/MP5K",
            EbxAttachments = {
                [g_AttachmentIds.Acog] = DC(Guid("83CD2C74-3D7D-4E7D-810E-84E8CE0638FF"), Guid("618ED5B2-B91A-4C3B-940F-39625BBD9C0F")),
                [g_AttachmentIds.EOTech] = DC(Guid("80C47242-6792-4902-8775-832D29F44E81"), Guid("94A78E81-6D03-4576-80B6-47259D052EFF")),
                [g_AttachmentIds.PKA] = DC(Guid("790D2823-FC85-4FE7-A633-2ED0E31BC491"), Guid("F6834D1C-21CE-49CA-A65B-9D0EC24FB305")),
                [g_AttachmentIds.RX01] = DC(Guid("17B5F7EA-2A17-4C56-BAD1-CE1D673D9EC2"), Guid("3F193DB8-E44F-42D9-96E8-AB249F3C3C7E")),
                [g_AttachmentIds.ExtendedMag] = DC(Guid("A77624D0-679E-11E1-B0C7-D7D9E922696A"), Guid("FD6209A4-D351-FBC1-45A8-22879F3729E2")),
                [g_AttachmentIds.PK_AS] = DC(Guid("A6BB9C1F-40D6-421B-ABE2-06A76746770D"), Guid("A0606EA1-8C03-4CF4-AD09-BAF013612D38")),
                [g_AttachmentIds.M145] = DC(Guid("FBD906F5-7605-4103-AD8A-556CE44FC5FE"), Guid("8275126A-E61E-46C5-8FD1-CD2060339472")),
                [g_AttachmentIds.NoOptics] = DC(Guid("6D3830F2-3528-11E0-B502-B15F9292C9B8"), Guid("A1AD1762-C856-F5D7-66B5-5E485460D3DF")),
                [g_AttachmentIds.FlashSuppressor] = DC(Guid("901F2B92-9BDA-4A13-8AEA-CDA727E74DAC"), Guid("CD61666B-CB81-4A05-9C35-FD265ACEB11C")),
                [g_AttachmentIds.Kobra] = DC(Guid("6D8ED736-FA11-4AC2-A286-F44BED230F36"), Guid("1E8DC345-C927-491A-B079-BD7D09E5BE54")),
                [g_AttachmentIds.TargetPointer] = DC(Guid("3C756D50-DEC9-442E-B951-2AFDCBF1D41B"), Guid("EA11AD00-8126-4D9E-9A63-7041A193B049")),
                [g_AttachmentIds.IRNV] = DC(Guid("F6A87E4A-0DAE-4919-A65C-7F93D2F65F12"), Guid("33388709-D0CC-4DD1-B2EF-250424727420")),
                [g_AttachmentIds.Silencer] = DC(Guid("6200256A-E267-4003-B86C-B9BD484360FD"), Guid("0C3A4024-17FF-4F90-BA37-D8EFA3059445")),
                [g_AttachmentIds.Flashlight] = DC(Guid("DF09E0B0-AFDF-44EB-9071-0DB00769CF4A"), Guid("6BDAFD17-EE48-4998-940F-3A251B757B53")),
            },
            RandomWeight = 15,
        }
    ),
    -- Shotgun
    ["weapon-r870"] = BRItemWeaponDefinition(
        "weapon-r870",
        "Model 870",
        {
            Description = "The Remington Model 870 is an American 12-gauge pump-action shotgun designed by Remington in 1951.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/remington870",
            Mesh = DC(Guid("244BD656-B62A-715A-FC6E-BCE517D4CE95"), Guid("B72B2A83-8B14-F5B3-3A31-844B2EC15EB6")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.5)
            ),
            SoldierWeaponBlueprint = DC(Guid("0B1B0AF6-75F5-4CA4-A945-372090333A83"), Guid("07A4C87A-D325-4A73-8C5A-C001ACD13334")),
            AmmoDefinition = m_AmmoDefinitions["ammo-12-gauge"],
            Tier = Tier.Tier1,
            EbxName = "Weapons/Remington870/Remington870MCS",
            EbxAttachments = {
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
            },
            RandomWeight = 15,
        }
    ),
    -- Sniper
    ["weapon-m98b"] = BRItemWeaponDefinition(
        "weapon-m98b",
        "M98B",
        {
            Description = "The M98B is a bolt-action sniper rifle produced by Barrett Firearms Manufacturing.",
            UIIcon = "UI/Art/Persistence/Weapons/Fancy/m98b",
            Mesh = DC(Guid("4167372B-8261-610E-464F-E3666AF6DFF7"), Guid("7FC60BE5-28DC-F4A4-4176-508F73727830")),
            Transform = LinearTransform(
                Vec3(0, -1, 0),
                Vec3(1, 0, 0),
                Vec3(0, 0, 1),
                Vec3(0, 0.04, -0.6)
            ),
            SoldierWeaponBlueprint = DC(Guid("D61A38DA-17D0-4146-9305-100183EB3E5F"), Guid("05EB2892-8B51-488E-8956-4350C3D2BA27")),
            AmmoDefinition = m_AmmoDefinitions["ammo-762mm"],
            Tier = Tier.Tier3,
            EbxName = "Weapons/Model98B/Model_98B",
            EbxAttachments = {
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
            },
            RandomWeight = 15,
        }
    ),
}
