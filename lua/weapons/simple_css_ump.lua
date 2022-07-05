AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "UMP-45"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_ump45.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_ump45.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "SMG1",
	Cost = 1,

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 16,
	Delay = 60 / 571,

	Range = 900,
	Accuracy = 12,

	RangeModifier = 0.75,

	Recoil = {
		MinAng = Angle(0.5, -0.3, 0),
		MaxAng = Angle(0.7, 0.3, 0),
		Punch = 0.6,
		Ratio = 0.4
	},

	Sound = "Weapon_UMP45.Single",
	TracerName = "Tracer"
}
