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

Tier = {
    Tier1 = 1,
    Tier2 = 2,
    Tier3 = 3,
}

LootPickupType = {
    Basic = {
        Name = "Basic",
        Mesh = DC(Guid("6519E1BF-BB39-8B7F-47D9-1B4C365318D9"), Guid("BC6154A0-CDFC-D402-ECCA-444811062765")),
        CheckPrice = false,
        Transform = LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0, 0)
        )
    },
    Chest = {
        Name = "Chest",
        Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
        CheckPrice = false,
        Transform = LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0, 0)
        )
    },
    Airdrop = {
        Name = "Airdrop",
        Mesh = nil,
        CheckPrice = false,
        Transform = LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0, 0)
        )
    },
    Shop = {
        Name = "Shop",
        Mesh = nil,
        CheckPrice = true,
        Transform = LinearTransform(
            Vec3(1, 0, 0),
            Vec3(0, 1, 0),
            Vec3(0, 0, 1),
            Vec3(0, 0, 0)
        )
    },
}

AttachmentType = {
    Optics = 1,
    Barrel = 2,
    Other = 3
}

InventorySlot = {
    -- PrimaryWeapon slots
    PrimaryWeapon = 1,
    PrimaryWeaponAttachmentOptics = 2,
    PrimaryWeaponAttachmentBarrel = 3,
    PrimaryWeaponAttachmentOther = 4,
    -- SecondaryWeapon slots
    SecondaryWeapon = 5,
    SecondaryWeaponAttachmentOptics = 6,
    SecondaryWeaponAttachmentBarrel = 7,
    SecondaryWeaponAttachmentOther = 8,
    -- Gadget slots
    Armor = 9,
    Helmet = 10,
    Gadget = 11,
    -- Backpack slots
    Backpack1 = 12,
    Backpack2 = 13,
    Backpack3 = 14,
    Backpack4 = 15,
    Backpack5 = 16,
    Backpack6 = 17,
    Backpack7 = 18,
    Backpack8 = 19,
    Backpack9 = 20
}
