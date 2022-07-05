AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "P228"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_p228.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_p228.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Pistol",
	Cost = 1,

	ClipSize = 20,
	DefaultClip = 40,

	Damage = 18,
	Delay = 60 / 400,

	Range = 1200,
	Accuracy = 12,

	RangeModifier = 0.9,

	Recoil = {
		MinAng = Angle(1.4, -0.3, 0),
		MaxAng = Angle(1.8, 0.3, 0),
		Punch = 0.3,
		Ratio = 0.5
	},

	Sound = "Weapon_P228.Single",
	TracerName = "Tracer"
}
