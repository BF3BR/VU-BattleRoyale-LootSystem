class "VuBattleRoyaleLootSystemShared"

require "__shared/Enums/Attachments"

require "__shared/Utils/Logger"
require "__shared/Utils/PostReloadEvent"

require "__shared/Types/DataContainer"

local m_AirdropObjectBlueprint = DC(Guid("344790FB-C800-11E0-BD5B-D85FACD7C899"), Guid("DE3ABA3C-D0D1-9863-50FB-D48577340978"))
local m_RigidMesh = DC(Guid("DA504C92-911F-87DD-0D84-944BD542E835"), Guid("B5CE760E-5220-29BA-3316-23EA12244E88"))
local m_HavokAsset = DC(Guid("A80588DC-4471-11DE-B7E8-80A76CACD9DC"), Guid("CB8BB4E2-E1F4-EA1D-E815-3DFD8765447B"))
local m_SmokeColorData = DC(Guid("5CE988C3-6622-11DE-9DCF-A96EA7FB2539"), Guid("0302E7F2-51CE-4089-817C-2DCDC9114BF4"))

local m_Logger = Logger("VuBattleRoyaleLootSystemShared", true)

function VuBattleRoyaleLootSystemShared:__init()
	-- TODO: This is already inside the main mod, no need to move
    Events:Subscribe("Level:LoadResources", self, self.OnLevelLoadResources)
    
    -- TODO: Move this to the main BR mod
    Hooks:Install("ResourceManager:LoadBundles", 100, function(hook, bundles, compartment)
        if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
            bundles = {
                bundles[1],
                "levels/coop_003/coop_003",
                "levels/coop_003/ab03_parent",
				"Levels/XP1_004/XP1_004",
            }
            hook:Pass(bundles, compartment)
        end
    end)

	-- TODO: Move this to the main BR mod
	m_AirdropObjectBlueprint:RegisterLoadHandler(self, self.CreateObjectBlueprint)
	m_SmokeColorData:RegisterLoadHandler(self, self.ModifySmokeColorData)
end

function VuBattleRoyaleLootSystemShared:OnLevelLoadResources(p_MapName, p_GameModeName, p_DedicatedServer)
    ResourceManager:MountSuperBundle("spchunks")
    ResourceManager:MountSuperBundle("levels/coop_003/coop_003")
	ResourceManager:MountSuperBundle("XP1Chunks")
	ResourceManager:MountSuperBundle("Levels/XP1_004/XP1_004")
end

function VuBattleRoyaleLootSystemShared:CreateObjectBlueprint(p_ObjectBlueprint)
    local s_Partition = p_ObjectBlueprint.partition
	local s_Registry = RegistryContainer()

	local s_ObjectBlueprint = ObjectBlueprint(p_ObjectBlueprint:Clone(Guid("261E43BF-259B-BF3B-41D2-0000BBBDBBBF")))
	local s_BangerEntityData = BangerEntityData(s_ObjectBlueprint.object)

	s_BangerEntityData:MakeWritable()
	s_BangerEntityData.mesh = m_RigidMesh:GetInstance()
	s_BangerEntityData.timeToLive = 0.0

	m_HavokAsset:RegisterLoadHandlerOnce({ s_BangerEntityData }, function(p_Table, p_Instance)
		local s_PhysicsData = PhysicsEntityData(s_BangerEntityData.physicsData)
		s_PhysicsData:MakeWritable()
		s_PhysicsData.scaledAssets:clear()
		s_PhysicsData.scaledAssets:add(p_Instance)
		
		local s_RigidBodyData = RigidBodyData(s_PhysicsData.rigidBodies[1])
		s_RigidBodyData:MakeWritable()
		s_RigidBodyData.mass = 750
		s_RigidBodyData.linearVelocityDamping = 0.25
	end)

	s_Partition:AddInstance(s_ObjectBlueprint)

	s_Registry.blueprintRegistry:add(s_ObjectBlueprint)
	s_Registry.entityRegistry:add(s_BangerEntityData)

	ResourceManager:AddRegistry(s_Registry, ResourceCompartment.ResourceCompartment_Game)

	m_Logger:Write("Custom airdrop BangerEntityData created")
end

function VuBattleRoyaleLootSystemShared:ModifySmokeColorData(p_PolynomialColorInterpData)
	p_PolynomialColorInterpData.color0 = Vec3(0.9,0.1,0.1)
	p_PolynomialColorInterpData.color1 = Vec3(0.8,0.1,0.1)
	p_PolynomialColorInterpData.coefficients = Vec4(0,0,-1.3197676,1.0089285)
end

return VuBattleRoyaleLootSystemShared()
