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
        Name = 'Basic',
        Mesh = 'case_mesh', -- TODO: Fix
        Transform = LinearTransform(), -- Do we need a transfrom?
        CheckPrice = false,
    },
    Chest = {
        Name = 'Chest',
        Mesh = 'chest_mesh', -- TODO: Fix
        Transform = LinearTransform(), -- Do we need a transfrom?
        CheckPrice = false,
    },
    Airdrop = {
        Name = 'Airdrop',
        Mesh = nil, -- TODO: Fix
        Transform = LinearTransform(),
        CheckPrice = false,
    },
    Shop = {
        Name = 'Shop',
        Mesh = 'shop_case_mesh', -- TODO: Fix
        Transform = LinearTransform(), -- Do we need a transfrom?
        CheckPrice = true,
    },
}
