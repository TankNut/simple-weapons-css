AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.PrintName = "USP-S"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_usp.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_usp.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 12,
	DefaultClip = 24,

	Damage = 17,
	Delay = 60 / 400,

	Range = 1400,
	Accuracy = 12,

	RangeModifier = 0.9,

	Recoil = {
		MinAng = Angle(1.4, -0.3, 0),
		MaxAng = Angle(1.8, 0.3, 0),
		Punch = 0.3,
		Ratio = 0.4
	},

	TracerName = "Tracer"
}

SWEP.NPCData = {
	Burst = {2, 3},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_css_usp", title = "Simple Weapons: " .. SWEP.PrintName})

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Bool", "Suppressed")
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

	if game.SinglePlayer() then
		self:CallOnClient("UpdateReverb", tostring(suppressed))
	end

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
	self:EmitSound(self:GetSuppressed() and "Weapon_USP.SilencedShot" or "Weapon_USP.Single")
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
		self:SetModel(self:GetSuppressed() and "models/weapons/w_pist_usp_silencer.mdl" or "models/weapons/w_pist_usp.mdl")

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
