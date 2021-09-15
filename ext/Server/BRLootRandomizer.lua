class "BRLootRandomizer"

require "__shared/Enums/ItemEnums"

local m_Logger = Logger("BRLootRandomizer", true)

local m_ItemDatabase = require "Types/BRItemDatabase"
local m_LootPickupDatabase = require "Types/BRLootPickupDatabase"

local m_AmmoDefinitions = require "__shared/Items/Definitions/BRItemAmmoDefinition"
local m_ArmorDefinitions = require "__shared/Items/Definitions/BRItemArmorDefinition"
local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"
local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_HelmetDefinitions = require "__shared/Items/Definitions/BRItemHelmetDefinition"
local m_WeaponDefinitions = require "__shared/Items/Definitions/BRItemWeaponDefinition"
local m_GadgetDefinitions = require "__shared/Items/Definitions/BRItemGadgetDefinition"

local m_MapHelper = require "__shared/Utils/MapHelper"

require "__shared/Utils/BRItemFactory"

function BRLootRandomizer:__init()
end

function BRLootRandomizer:Spawn(p_Point)
    if p_Point == nil then
        return
    end

    -- Randomize the type first
    local s_RandomTypeIndex = self:Randomizer(RandomWeightsTable)

    
    if s_RandomTypeIndex == nil then
        m_Logger:Write("No type found.")
        return
    end
    
    local s_RandomTier = nil
    if RandomWeightsTable[s_RandomTypeIndex].Tiers ~= nil then
        -- If there are tiers then we should randomize it as well
        s_RandomTier = self:Randomizer(RandomWeightsTable[s_RandomTypeIndex].Tiers)
    end

    local s_Point = p_Point
    local s_RandomItemDefinition = nil
    local s_RandomItemQuantity = 1
    if s_RandomTypeIndex == "Nothing" then
        m_Logger:Write("Nothing to spawn.")
        return
    else
        if s_RandomTypeIndex == ItemType.Weapon then
            -- If we want to spawn a weapon we should randomize an ammo and an attachment or two ammos or nothing just the weapon
            s_RandomItemDefinition = self:Randomizer(m_WeaponDefinitions, true, s_RandomTier)

            -- Get a randomized attachment
            s_AttachmentDefinition = self:Randomizer(m_AttachmentDefinitions, true, nil, s_RandomItemDefinition.m_EbxAttachments)

            -- Get the ammo definition
            s_AmmoDefinition = s_RandomItemDefinition.m_AmmoDefinition

            s_Patterns = m_MapHelper:Keys(RandomWeaponPatterns)
            s_WeaponSpawnPattern = math.random(#s_Patterns)
            if s_WeaponSpawnPattern == RandomWeaponPatterns.WeaponWithAmmo then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_AmmoDefinition, s_AmmoDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                ), {s_AddedItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x - 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            elseif s_WeaponSpawnPattern == RandomWeaponPatterns.WeaponWithAttachment then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_AttachmentDefinition)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                ), {s_AddedItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x - 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            elseif s_WeaponSpawnPattern == RandomWeaponPatterns.WeaponWithAttachmentAndAmmo then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_AttachmentDefinition)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z + 0.35
                ), {s_AddedItem})

                local s_AddedSecondItem = m_ItemDatabase:CreateItem(s_AmmoDefinition, s_AmmoDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z - 0.35
                ), {s_AddedSecondItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            elseif s_WeaponSpawnPattern == RandomWeaponPatterns.WeaponWithTwoAmmo then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_AmmoDefinition, s_AmmoDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z + 0.35
                ), {s_AddedItem})

                local s_AddedSecondItem = m_ItemDatabase:CreateItem(s_AmmoDefinition, s_AmmoDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z - 0.35
                ), {s_AddedSecondItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            end
        elseif s_RandomTypeIndex == ItemType.Attachment then
            s_RandomItemDefinition = self:Randomizer(m_AttachmentDefinitions, true)
        elseif s_RandomTypeIndex == ItemType.Helmet then
            s_RandomItemDefinition = self:Randomizer(m_HelmetDefinitions, true, s_RandomTier)
        elseif s_RandomTypeIndex == ItemType.Armor then
            s_RandomItemDefinition = self:Randomizer(m_ArmorDefinitions, true, s_RandomTier)
        elseif s_RandomTypeIndex == ItemType.Gadget then
            s_RandomItemDefinition = self:Randomizer(m_GadgetDefinitions, true)
        elseif s_RandomTypeIndex == ItemType.Consumable then
            s_RandomItemDefinition = self:Randomizer(m_ConsumableDefinitions, true)
        elseif s_RandomTypeIndex == ItemType.Consumable then
            s_RandomItemDefinition = self:Randomizer(m_AmmoDefinition, true)

            if s_RandomItemDefinition == nil then
                m_Logger:Write("No item definition found.")
                return
            end

            s_RandomItemQuantity = s_RandomItemDefinition.m_MaxStack

            s_Patterns = m_MapHelper:Keys(RandomAmmoPatterns)
            s_WeaponSpawnPattern = math.random(#s_Patterns)
            if s_WeaponSpawnPattern == RandomAmmoPatterns.TwoItems then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_RandomItemDefinition, s_RandomItemDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                ), {s_AddedItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x - 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            elseif s_WeaponSpawnPattern == RandomAmmoPatterns.ThreeItems then
                local s_AddedItem = m_ItemDatabase:CreateItem(s_RandomItemDefinition, s_RandomItemDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z + 0.35
                ), {s_AddedItem})

                local s_AddedSecondItem = m_ItemDatabase:CreateItem(s_RandomItemDefinition, s_RandomItemDefinition.m_MaxStack)
                m_LootPickupDatabase:CreateBasicLootPickup(Vec3(
                    s_Point.trans.x - 0.35,
                    s_Point.trans.y,
                    s_Point.trans.z - 0.35
                ), {s_AddedSecondItem})

                s_Point.trans = Vec3(
                    s_Point.trans.x + 0.5,
                    s_Point.trans.y,
                    s_Point.trans.z
                )
            end
        end
    end

    if s_RandomItemDefinition == nil then
        m_Logger:Write("No item definition found.")
        return
    end

    local s_Item = m_ItemDatabase:CreateItem(s_RandomItemDefinition, s_RandomItemQuantity)
    m_LootPickupDatabase:CreateBasicLootPickup(s_Point, {s_Item})
end

function BRLootRandomizer:Randomizer(p_LevelOrDefinitions, p_IsItem, p_Tier, p_Attachments)
    local s_AttachmentsTable = {}
    if p_Attachments ~= nil then
        s_AttachmentsTable = m_MapHelper:Keys(p_Attachments)
    end
    
    local s_WeightTable = {}
    local s_AccumulatedWeight = 0
    for l_Index, l_Value in pairs(p_LevelOrDefinitions) do
        if p_IsItem == true then
            if p_Tier ~= nil and l_Value.m_Tier ~= p_Tier then
                goto continue
            end

            if p_Attachments ~= nil then
                if not m_MapHelper:Contains(s_AttachmentsTable, l_Value.m_AttachmentId) then
                    goto continue
                end
            end

            s_AccumulatedWeight = s_AccumulatedWeight + l_Value.m_RandomWeight
        else
            s_AccumulatedWeight = s_AccumulatedWeight + l_Value.RandomWeight
        end

		s_WeightTable[l_Index] = s_AccumulatedWeight

        ::continue::
	end

    local s_Random = math.random(0, s_AccumulatedWeight)
    for l_Index, l_Weight in pairs(s_WeightTable) do
        if s_Random <= l_Weight then
            if p_IsItem == true then
                return p_LevelOrDefinitions[l_Index]
            end

            return l_Index
        end
    end



    return nil
end

-- define global
if g_BRLootRandomizer== nil then
    g_BRLootRandomizer = BRLootRandomizer()
end

return g_BRLootRandomizer
