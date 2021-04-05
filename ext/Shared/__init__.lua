class "VuBattleRoyaleLootSystemShared"

require "__shared/Enums/ItemEnums"
require "__shared/Types/BRLootPickup"
require "__shared/Items/BRItem"

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"

function VuBattleRoyaleLootSystemShared:__init()
    Events:Subscribe("Extension:Loaded", self, self.OnExtensionLoaded)
end

function VuBattleRoyaleLootSystemShared:OnExtensionLoaded()
    self:RegisterEvents()
end

function VuBattleRoyaleLootSystemShared:RegisterEvents()
    Events:Subscribe("Level:Loaded", self, self.OnLevelLoaded)
end

function VuBattleRoyaleLootSystemShared:OnLevelLoaded()
    BRLootPickup:BasicPickup(
        LinearTransform(
            Vec3(1.0, 0.0, 0.0), 
            Vec3(0.0, 1.0, 0.0), 
            Vec3(0.0, 0.0, 1.0),
            Vec3(526.175720, 155.705505, -822.253479)
        ),
        {
            BRItem(
                "RandomUID_1",
                m_WeaponDefinitions["PP-2000"]
            ),
        }
    )

    BRLootPickup:ChestPickup(
        LinearTransform(
            Vec3(1.0, 0.0, 0.0), 
            Vec3(0.0, 1.0, 0.0), 
            Vec3(0.0, 0.0, 1.0),
            Vec3(522.175720, 155.705505, -822.253479)
        ),
        {
            BRItem(
                "RandomUID_2",
                m_WeaponDefinitions["AK-74M"]
            ),
        }
    )
end

return VuBattleRoyaleLootSystemShared()
