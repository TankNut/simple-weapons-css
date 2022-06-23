AddCSLuaFile()

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "G3SG1"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_g3sg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_g3sg1.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 20,
	DefaultClip = 20,

	Damage = 60,
	Delay = 60 / 240,

	Range = 3000,
	Accuracy = 12,

	RangeModifier = 0.98,

	Recoil = {
		MinAng = Angle(2, -0.6, 0),
		MaxAng = Angle(3, 0.6, 0),
		Punch = 0.4,
		Ratio = 0.6
	},

	Sound = "Weapon_G3SG1.Single",
	TracerName = "Tracer"
}

SWEP.ScopeZoom = {2, 6}
SWEP.ScopeSound = "Default.Zoom"
