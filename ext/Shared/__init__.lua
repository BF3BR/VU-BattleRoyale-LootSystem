class "VuBattleRoyaleLootSystemShared"

require "__shared/Enums/ItemEnums"

require "__shared/Types/BRLootPickup"
require "__shared/Types/BRInventory"

require "__shared/Items/BRItemWeapon"
require "__shared/Items/BRItemAmmo"

local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"
local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
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
    local s_TestInventory = BRInventory(nil)

    local s_ItemPP2000 = BRItemWeapon(nil, m_WeaponDefinitions["PP-2000"])
    local s_ItemAK = BRItemWeapon(nil, m_WeaponDefinitions["AK-74M"])
    m_ItemDatabase:RegisterItem(s_ItemPP2000)
    m_ItemDatabase:RegisterItem(s_ItemAK)

    s_TestInventory:AddItem(s_ItemPP2000.m_Id)
    s_TestInventory:AddItem(s_ItemAK.m_Id)

    local s_ItemAmmo1 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"])
    local s_ItemAmmo2 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"])
    local s_ItemAmmo3 = BRItemAmmo(nil, m_AmmoDefinitions["5.56mm"])
    m_ItemDatabase:RegisterItem(s_ItemAmmo1)
    m_ItemDatabase:RegisterItem(s_ItemAmmo2)
    m_ItemDatabase:RegisterItem(s_ItemAmmo3)

    s_TestInventory:AddItem(s_ItemAmmo1.m_Id)
    s_TestInventory:AddItem(s_ItemAmmo2.m_Id)
    s_TestInventory:AddItem(s_ItemAmmo3.m_Id)

    print(s_TestInventory.m_Slots)

    --[[ if m_ItemDatabase:AddItem(s_Item) then
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
    end]]

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
