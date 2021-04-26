class "VuBattleRoyaleLootSystemShared"

require "__shared/Enums/ItemEnums"
require "__shared/Types/BRLootPickup"
require "__shared/Items/BRItemWeapon"

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"
local m_ItemDatabase = require "__shared/Types/BRItemDatabase"

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
    local s_Item = BRItemWeapon(m_WeaponDefinitions["PP-2000"])
    if m_ItemDatabase:AddItem(s_Item) then
        BRLootPickup:BasicPickup(
            LinearTransform(
                Vec3(1.0, 0.0, 0.0), 
                Vec3(0.0, 1.0, 0.0), 
                Vec3(0.0, 0.0, 1.0),
                Vec3(526.175720, 155.705505, -822.253479)
            ),
            {
                s_Item,
            }
        )
    end

    --[[BRLootPickup:ChestPickup(
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
    )]]
end

return VuBattleRoyaleLootSystemShared()
