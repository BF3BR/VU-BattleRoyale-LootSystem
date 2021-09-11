require "__shared/Items/Definitions/BRItemDefinition"
require "__shared/Enums/ItemEnums"

class("BRItemAmmoDefinition", BRItemDefinition)

function BRItemAmmoDefinition:__init(p_UId, p_Name, p_Options)
    p_Options = p_Options or {}

    -- set fixed shared option values for ammo
    p_Options.Type = ItemType.Ammo
    p_Options.Stackable = true
    p_Options.Price = 0

    -- call super's constructor and set shared options
    BRItemDefinition.__init(self, p_UId, p_Name, p_Options)
end

return {
    ["ammo-556mm"] = BRItemAmmoDefinition(
        "ammo-556mm",
        "5.56mm",
        {
            Description = "The 5.56mm ammo is used for ARs.",
            RandomWeight = 25,
            Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
            UIIcon = "__ammo_556mm",
            MaxStack = 60,
        }
    ),
    ["ammo-9mm"] = BRItemAmmoDefinition(
        "ammo-9mm",
        "9mm",
        {
            Description = "The 9mm ammo is used for SMGs and Pistols.",
            RandomWeight = 25,
            Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
            UIIcon = "__ammo_9mm",
            MaxStack = 90,
        }
    ),
    ["ammo-762mm"] = BRItemAmmoDefinition(
        "ammo-762mm",
        "7.62mm",
        {
            Description = "The 7.62mm ammo is used for Snipers.",
            RandomWeight = 25,
            Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
            UIIcon = "__ammo_762mm",
            MaxStack = 15,
        }
    ),
    ["ammo-12-gauge"] = BRItemAmmoDefinition(
        "ammo-12-gauge",
        "12 Gauge", 
        {
            Description = "The 7.62mm ammo is used for Snipers.",
            RandomWeight = 25,
            Mesh = DC(Guid("50BB59D3-DFAB-C286-EBAC-B5CF4BAB7AC0"), Guid("6412D2CA-7AF5-A459-E048-688143B6E35B")),
            UIIcon = "__ammo_12-gauge",
            MaxStack = 30,
        }
    ),
}
