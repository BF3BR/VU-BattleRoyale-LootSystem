class "BRLooting"

local m_Debug = require "Debug"
local m_Logger = Logger("BRLooting", true)
local m_MapHelper = require "__shared/Utils/MapHelper"
local m_BRLootPickupDatabase = require "Types/BRLootPickupDatabase"

function BRLooting:__init()
	self.m_LastDelta = 0
	self.m_LastSelectedLootPickup = nil

	self.m_TimeToUpdateLootUi = 0.15
end

-- =============================================
-- Events
-- =============================================

function BRLooting:OnClientUpdateInput(p_Delta)
	self.m_LastDelta = self.m_LastDelta + p_Delta

	-- Make sure we have a local player and an alive soldier.
	local s_Player = PlayerManager:GetLocalPlayer()

	if s_Player == nil or s_Player.soldier == nil then
		return
	end

	-- InputManager:IsKeyDown(InputDeviceKeys.IDK_E) and
	if self.m_LastDelta >= self.m_TimeToUpdateLootUi then
		self.m_LastDelta = 0.0

		local s_Entity = self:OnRaycast()
		if s_Entity ~= nil then
			local s_LootPickup = m_BRLootPickupDatabase:GetByInstanceId(s_Entity.instanceId)
			if s_LootPickup ~= nil then
				self.m_LastSelectedLootPickup = s_LootPickup
				if m_MapHelper:HasSingleItem(s_LootPickup.m_Items) then
					local s_SingleItem = m_MapHelper:Item(s_LootPickup.m_Items)
					self:OnSendOverlayLoot(s_SingleItem, false)
				else
					self:OnSendOverlayLoot(s_LootPickup.m_Type, true)
				end
			else
				self:OnSendOverlayLoot(nil, false)
				self.m_LastSelectedLootPickup = nil
			end
		else
			self:OnSendOverlayLoot(nil, false)
			self.m_LastSelectedLootPickup = nil
		end

		if InputManager:IsKeyDown(InputDeviceKeys.IDK_E) and self.m_LastSelectedLootPickup ~= nil then
			local s_LootPickup = self.m_LastSelectedLootPickup
			if m_MapHelper:HasSingleItem(s_LootPickup.m_Items) then
				NetEvents:Send(
					InventoryNetEvent.PickupItem,
					s_LootPickup.m_Id,
					m_MapHelper:Item(s_LootPickup.m_Items).m_Id
				)
			else
				self:OnSendOverlayLootBox(s_LootPickup.m_Id, s_LootPickup.m_Items)
			end
		end
	end
end

function BRLooting:OnUpdateLootPickup(p_LootPickupData)
	-- update LootPickup in database
	local s_LootPickup = m_BRLootPickupDatabase:Update(p_LootPickupData)
	if s_LootPickup == nil then
		return
	end

	-- update LootPickup in WebUI if needed
	if self.m_LastSelectedLootPickup ~= nil and 
		self.m_LastSelectedLootPickup.m_Id == s_LootPickup.m_Id then
		self:OnSendOverlayLootBox(s_LootPickup.m_Id, s_LootPickup.m_Items)
	end
end

function BRLooting:OnUnregisterLootPickup(p_LootPickupId)
	if not m_BRLootPickupDatabase:RemoveById(p_LootPickupId) then
		return
	end

	-- update LootPickup in WebUI if needed
	if self.m_LastSelectedLootPickup ~= nil and 
		self.m_LastSelectedLootPickup.m_Id == p_LootPickupId then
		self:OnSendOverlayLootBox(nil, false)
		self.m_LastSelectedLootPickup = nil
	end
end

function BRLooting:OnRaycast()
	-- Make sure we have a local player.
	local s_Player = PlayerManager:GetLocalPlayer()

	if s_Player == nil or s_Player.soldier == nil then
		return nil
	end

	-- Our prop-picking ray will start at what the camera is looking at and
	-- extend forward by 3.0m.
	local s_Transform = ClientUtils:GetCameraTransform()
	local s_Direction = Vec3(s_Transform.forward.x * -1, s_Transform.forward.y * -1, s_Transform.forward.z * -1)

	if s_Transform.trans == Vec3(0,0,0) then
		return
	end

	local s_From = Vec3(
		s_Transform.trans.x,
		s_Transform.trans.y,
		s_Transform.trans.z
	)

	-- We get the raycast end transform with the calculated direction and the max distance.
	local s_Target = Vec3(
		s_Transform.trans.x + (s_Direction.x * 3.0),
		s_Transform.trans.y + (s_Direction.y * 3.0),
		s_Transform.trans.z + (s_Direction.z * 3.0)
	)

	-- Do a spatial raycast and a normal raycast.
	-- We use the spatial raycast to find available props and the normal raycast
	-- to see if there's anything between us and that prop and also help us select
	-- the prop to pick.
	local s_Entities = RaycastManager:SpatialRaycast(s_From, s_Target, SpatialQueryFlags.AllGrids)
	local s_Hit = RaycastManager:Raycast(s_From, s_Target, RayCastFlags.CheckDetailMesh | RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll)

	local s_HitDistance = 3.0

	if s_Hit ~= nil then
		s_HitDistance = s_From:Distance(s_Hit.position)

		-- Add 1.5cm to account for innacuracies.
		s_HitDistance = s_HitDistance + 0.015
	end

	local s_RaycastObjects = {}
	local s_Candidates = {}

	local s_Heading = s_Target - s_From
	local s_Direction = s_Heading:Normalize()

	local s_WallHit = s_From + (s_Direction * s_HitDistance)
	m_Debug:setWallHit(s_WallHit)

	for _, l_Entity in pairs(s_Entities) do
		-- We only care about spatial entities.
		if not l_Entity:Is("SpatialEntity") then
			goto continue
		end

		local l_Mesh = self:GetMesh(l_Entity)

		if l_Mesh == nil then
			goto continue
		end

		-- Now we need to do our own ray-tracing because the entities we get back do
		-- not necessarily intersect with our selection ray.
		local l_SpatialEntity = SpatialEntity(l_Entity)

		local l_Aabb = l_SpatialEntity.aabb
		local l_AabbTrans = l_SpatialEntity.aabbTransform

		-- Try to get an intersection point between our ray and this entity's OBB.
		local l_Intersection = self:Intersect(s_From, s_Target, l_Aabb, l_AabbTrans, 3.0)

		-- No intersection found
		if l_Intersection == false then
			table.insert(s_RaycastObjects, { l_Aabb, l_AabbTrans, l_Mesh.name, nil, nil, false })
			goto continue
		end

		-- We have an intersection! Add to a list of entities to process.
		table.insert(s_Candidates, { l_Mesh, l_SpatialEntity, l_Intersection })

		-- Add to debug render list.
		local s_IntersectStart = s_From + (s_Direction * l_Intersection[1])
		local s_IntersectEnd = s_From + (s_Direction * l_Intersection[2])

		table.insert(s_RaycastObjects, { l_Aabb, l_AabbTrans, l_Mesh.name, s_IntersectStart, s_IntersectEnd, false })

		::continue::
	end

	-- Process our candidates to find the best one.
	local s_SelectedProp = nil

	-- Find the prop whose intersection point is closest to the raycast hit.
	for _, l_Candidate in pairs(s_Candidates) do
		local s_IntersectStart = l_Candidate[3][1]

		if s_IntersectStart <= s_HitDistance then
			if s_SelectedProp == nil then
				s_SelectedProp = l_Candidate
			end

			if s_IntersectStart > s_SelectedProp[3][1] then
				s_SelectedProp = l_Candidate
			end
		end
	end

	-- If we have selected a prop then add it to the debug render list.
	if s_SelectedProp ~= nil then
		local s_IntersectStart = s_From + (s_Direction * s_SelectedProp[3][1])
		local s_IntersectEnd = s_From + (s_Direction * s_SelectedProp[3][2])

		table.insert(s_RaycastObjects, { 
			s_SelectedProp[2].aabb, 
			s_SelectedProp[2].aabbTransform, 
			s_SelectedProp[1].name, 
			s_IntersectStart, 
			s_IntersectEnd, 
			true 
		})
	end

	-- Send debug draw commands.
	m_Debug:setRaycastObjects(s_RaycastObjects)
	m_Debug:setRaycastLine(s_From, s_Target)

	if s_SelectedProp ~= nil then
		return s_SelectedProp[2]
	end

	return nil
end

function BRLooting:GetMesh(entity)
	local data = entity.data

	if data == nil then
		return nil
	end

	if data:Is("StaticModelEntityData") then
		data = StaticModelEntityData(data)
		return data.mesh
	end

	return nil
end

function BRLooting:Intersect(from, to, aabb, transform, maxDist)
	local tmin = 0.0
	local tmax = maxDist

	local heading = to - from
	local direction = heading:Normalize()

	local delta = transform.trans - from

	local function checkAxis(axis, min, max)
		local e = axis:Dot(delta)
		local f = direction:Dot(axis)

		if math.abs(f) > math.epsilon then
			local t1 = (e + min) / f
			local t2 = (e + max) / f

			if t1 > t2 then
				local temp = t1
				t1 = t2
				t2 = temp
			end

			if t2 < tmax then
				tmax = t2
			end

			if t1 > tmin then
				tmin = t1
			end

			if tmax < tmin then
				return false
			end
		else
			if min - e > 0.0 or max - e < 0.0 then
				return false
			end
		end

		return true
	end

	if not checkAxis(transform.left, aabb.min.x, aabb.max.x) then
		return false
	end

	if not checkAxis(transform.up, aabb.min.y, aabb.max.y) then
		return false
	end

	if not checkAxis(transform.forward, aabb.min.z, aabb.max.z) then
		return false
	end

	return { tmin, tmax }
end

--==============================
-- UI related functions
--==============================

function BRLooting:OnSendOverlayLoot(p_Item, p_MultiItem)
	if p_Item == nil then
		WebUI:ExecuteJS(string.format("SyncOverlayLoot(%s);", nil))
		return
	end

	if p_MultiItem then
		WebUI:ExecuteJS(string.format("SyncOverlayLoot(%s);", json.encode(p_Item.Name)))
		return
	end

	local s_ReturnVal = {
		Id = p_Item.m_Id,
		UId = p_Item.m_Definition.m_UId,
		Name = p_Item.m_Definition.m_Name,
		Type = p_Item.m_Definition.m_Type,
		Description = p_Item.m_Definition.m_Description,
		UIIcon = p_Item.m_Definition.m_UIIcon,
		Price = p_Item.m_Definition.m_Price,
		Quantity = p_Item.m_Quantity
	}

	if p_Item.m_Definition.m_Type == ItemType.Weapon then
		s_ReturnVal.Tier = p_Item.m_Definition.m_Tier
		s_ReturnVal.AmmoName = p_Item.m_Definition.m_AmmoDefinition.m_Name
	elseif p_Item.m_Definition.m_Type == ItemType.Helmet or p_Item.m_Definition.m_Type == ItemType.Armor then
		s_ReturnVal.Tier = p_Item.m_Definition.m_Tier
		s_ReturnVal.Durability = p_Item.m_Definition.m_Durability
		s_ReturnVal.CurrentDurability = p_Item.m_CurrentDurability
	elseif p_Item.m_Definition.m_Type == ItemType.Consumable then
		s_ReturnVal.TimeToApply = p_Item.m_Definition.m_TimeToApply
	end

	WebUI:ExecuteJS(string.format("SyncOverlayLoot(%s);", json.encode(s_ReturnVal)))
end

function BRLooting:OnSendOverlayLootBox(p_LootPickupId, p_Items)
	if p_Items == nil then
		WebUI:ExecuteJS(string.format("SyncOverlayLootBox(%s, %s);", nil, nil))
		return
	end

	local s_ReturnVal = { }
	for l_Index, l_Item in pairs(p_Items) do
		local l_ReturnVal = { }
		l_ReturnVal = {
			Id = l_Item.m_Id,
			UId = l_Item.m_Definition.m_UId,
			Name = l_Item.m_Definition.m_Name,
			Type = l_Item.m_Definition.m_Type,
			Description = l_Item.m_Definition.m_Description,
			UIIcon = l_Item.m_Definition.m_UIIcon,
			Price = l_Item.m_Definition.m_Price,
			Quantity = l_Item.m_Quantity
		}
	
		if l_Item.m_Definition.m_Type == ItemType.Weapon then
			l_ReturnVal.Tier = l_Item.m_Definition.m_Tier
			l_ReturnVal.AmmoName = l_Item.m_Definition.m_AmmoDefinition.m_Name
		elseif l_Item.m_Definition.m_Type == ItemType.Helmet or l_Item.m_Definition.m_Type == ItemType.Armor then
			l_ReturnVal.Tier = l_Item.m_Definition.m_Tier
			l_ReturnVal.Durability = l_Item.m_Definition.m_Durability
			l_ReturnVal.CurrentDurability = l_Item.m_CurrentDurability
		elseif l_Item.m_Definition.m_Type == ItemType.Consumable then
			l_ReturnVal.TimeToApply = l_Item.m_Definition.m_TimeToApply
		end

		table.insert(s_ReturnVal, l_ReturnVal)
    end

	WebUI:ExecuteJS(string.format("SyncOverlayLootBox('%s', %s);", p_LootPickupId, json.encode(s_ReturnVal)))
end
