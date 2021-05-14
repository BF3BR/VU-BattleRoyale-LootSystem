ItemType = {
    Default = 1,
    Weapon = 2,
    Attachment = 3,
    Ammo = 4,
    Consumable = 5,
    Armor = 6,
    Helmet = 7,
    Gadget = 8,
}

WeaponTier = {
    Tier1 = 1,
    Tier2 = 1,
    Tier3 = 1,
}

LootPickupType = {
    Basic = {
        Name = "Basic",
        Mesh = DC(Guid("6519E1BF-BB39-8B7F-47D9-1B4C365318D9"), Guid("BC6154A0-CDFC-D402-ECCA-444811062765")),
        CheckPrice = false,
    },
    Chest = {
        Name = "Chest",
        Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
        CheckPrice = false,
    },
    Airdrop = {
        Name = "Airdrop",
        Mesh = nil,
        CheckPrice = false,
    },
    Shop = {
        Name = "Shop",
        Mesh = nil,
        CheckPrice = true,
    },
}
