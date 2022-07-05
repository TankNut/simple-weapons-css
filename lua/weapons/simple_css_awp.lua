AddCSLuaFile()

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "AWP"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_awp.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_awp.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "XBowBolt",
	Cost = 1,

	ClipSize = 10,
	DefaultClip = 10,

	Damage = 85,
	Delay = -1,

	Range = 4000,
	Accuracy = 12,

	RangeModifier = 0.99,

	Recoil = {
		MinAng = Angle(2, -0.8, 0),
		MaxAng = Angle(3, 0.8, 0),
		Punch = 0.6,
		Ratio = 0.2
	},

	Sound = "Weapon_AWP.Single",
	TracerName = "Tracer"
}

SWEP.ScopeZoom = {2.25, 9}
SWEP.ScopeSound = "Default.Zoom"
