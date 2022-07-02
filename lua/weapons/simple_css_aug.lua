AddCSLuaFile()

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "AUG"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_aug.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_aug.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 23,

	Range = 1600,
	Accuracy = 12,

	RangeModifier = 0.98,

	Recoil = {
		MinAng = Angle(1, -0.4, 0),
		MaxAng = Angle(1.2, 0.4, 0),
		Punch = 0.4,
		Ratio = 0.4
	},

	Sound = "Weapon_AUG.Single",
	TracerName = "Tracer"
}

SWEP.ScopeZoom = 3
SWEP.ScopeSound = "Default.Zoom"

function SWEP:GetDelay()
	return self:GetScopeIndex() > 0 and 60 / 429 or 60 / 666
end
