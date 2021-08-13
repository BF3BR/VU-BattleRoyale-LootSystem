class "PostReloadEvent"

local m_Logger = Logger("PostReloadEvent", true)

function PostReloadEvent:__init()
    self.m_WeaponAmmo = {}

    Events:Subscribe("Player:Reload", self, self.OnPlayerReload)
    Events:Subscribe("WeaponFiring:Update", self, self.OnWeaponFiring)
end

function PostReloadEvent:OnPlayerReload(p_Player, p_WeaponName, p_Position)
    if p_Player == nil or p_Player.soldier == nil then
        return
    end

    local s_CurrentWeapon = p_Player.soldier.weaponsComponent.currentWeapon

    -- Save pre reload ammo
    self.m_WeaponAmmo[s_CurrentWeapon.weaponFiring.instanceId] = {
        PlayerId = p_Player.id,
        Ammo = s_CurrentWeapon.primaryAmmo
    }
end

function PostReloadEvent:OnWeaponFiring(p_WeaponFiring)
    if p_WeaponFiring.weaponState == WeaponState.Reload or
        p_WeaponFiring.weaponState == WeaponState.ReloadDelay or
        self.m_WeaponAmmo[p_WeaponFiring.instanceId] == nil then
        return
    end

    -- get current reload data and clear reference
    local s_Data = self.m_WeaponAmmo[p_WeaponFiring.instanceId]
    self.m_WeaponAmmo[p_WeaponFiring.instanceId] = nil

    -- Event parameters
    local s_Player = PlayerManager:GetPlayerById(s_Data.PlayerId)
    local s_PreviousPrimaryAmmo = s_Data.Ammo
    local s_AmmoAdded = s_Player.soldier.weaponsComponent.currentWeapon.primaryAmmo - s_Data.Ammo

    -- fix for shotguns shooting while reloading
    if p_WeaponFiring.weaponState == WeaponState.PrimarySingle then
        s_AmmoAdded = s_AmmoAdded + 1
    end

    -- Dispatch custom post reload event
    if s_AmmoAdded > 0 then
        Events:Dispatch("Player:PostReload", s_Player, s_PreviousPrimaryAmmo, s_AmmoAdded)
    end
end

PostReloadEvent()
