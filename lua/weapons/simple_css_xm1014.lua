AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "XM1014"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_shot_xm1014.mdl")
SWEP.WorldModel = Model("models/weapons/w_shot_xm1014.mdl")

SWEP.HoldType = "shotgun"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Buckshot",

	ClipSize = 7,
	DefaultClip = 7,

	Damage = 18,
	Count = 6,

	Delay = 60 / 240,

	Spread = Spread(200),

	Recoil = {
		MinAng = Angle(2, -0.7, 0),
		MaxAng = Angle(3, 0.7, 0),
		Punch = 0.5,
		Ratio = 0
	},

	Reload = {
		Amount = 1,
		Shotgun = true
	},

	Sound = "Weapon_XM1014.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
