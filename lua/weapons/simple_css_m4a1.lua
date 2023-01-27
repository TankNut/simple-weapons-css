AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.PrintName = "M4A1"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_m4a1.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_m4a1.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 22,
	Delay = 60 / 666,

	Range = 1200,
	Accuracy = 12,

	RangeModifier = 0.98,

	Recoil = {
		MinAng = Angle(1, -0.3, 0),
		MaxAng = Angle(1.3, 0.3, 0),
		Punch = 0.4,
		Ratio = 0.4
	},

	TracerName = "Tracer"
}

SWEP.NPCData = {
	Burst = {2, 5},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_css_m4a1", title = "Simple Weapons: " .. SWEP.PrintName})

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:AddNetworkVar("Bool", "Suppressed")
end

function SWEP:CanAltFire()
	return not self:IsReloading()
end

function SWEP:AltFire()
	self.Primary.Automatic = false

	local suppressed = not self:GetSuppressed()

	self:SetSuppressed(suppressed)
	self:SendTranslatedWeaponAnim(suppressed and ACT_VM_ATTACH_SILENCER or ACT_VM_DETACH_SILENCER)

	-- Dynamic Weapon Reverb support
	self.dwr_customIsSuppressed = self:GetSuppressed()

	local duration = CurTime() + self:SequenceDuration()

	self:SetNextFire(duration)
	self:SetNextIdle(duration)
end

if CLIENT then
	function SWEP:UpdateReverb(bool)
		self.dwr_customIsSuppressed = tobool(bool)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self:GetSuppressed() and "Weapon_M4A1.Silenced" or "Weapon_M4A1.Single")
end

function SWEP:ModifyBulletTable(bullet)
	if self:GetSuppressed() then
		bullet.Tracer = 0
	end
end

local replace = {
	[ACT_VM_DRAW] = ACT_VM_DRAW_SILENCED,
	[ACT_VM_PRIMARYATTACK] = ACT_VM_PRIMARYATTACK_SILENCED,
	[ACT_VM_IDLE] = ACT_VM_IDLE_SILENCED,
	[ACT_VM_RELOAD] = ACT_VM_RELOAD_SILENCED
}

function SWEP:TranslateWeaponAnim(act)
	if self:GetSuppressed() then
		return replace[act] or act
	end

	return act
end

if CLIENT then
	function SWEP:DrawWorldModel(flags)
		self:SetModel(self:GetSuppressed() and "models/weapons/w_rif_m4a1_silencer.mdl" or "models/weapons/w_rif_m4a1.mdl")

		BaseClass.DrawWorldModel(self, flags)
	end
end

function SWEP:FireAnimationEvent(_, _, event)
	if self:GetSuppressed() and (event == 5001 or event == 5003) then
		return true
	end

	if CLIENT and (event == 5001 or event == 5011 or event == 5021 or event == 5031) then
		local data = EffectData()

		data:SetFlags(0)
		data:SetEntity(self:GetOwner():GetViewModel())
		data:SetAttachment(math.floor((event - 4991) / 10))
		data:SetScale(1)

		util.Effect(self.CSMuzzleX and "CS_MuzzleFlash_X" or "CS_MuzzleFlash", data)

		return true
	end
end
