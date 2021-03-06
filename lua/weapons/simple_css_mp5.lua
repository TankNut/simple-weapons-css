AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "MP5"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_mp5.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_mp5.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "SMG1",

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 14,
	Delay = 60 / 750,

	Range = 600,
	Accuracy = 12,

	RangeModifier = 0.87,

	Recoil = {
		MinAng = Angle(0.5, -0.3, 0),
		MaxAng = Angle(0.7, 0.3, 0),
		Punch = 0.6,
		Ratio = 0.6
	},

	Sound = "Weapon_MP5Navy.Single",
	TracerName = "Tracer"
}

SWEP.NPCData = {
	Burst = {3, 6},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_css_mp5", title = "Simple Weapons: " .. SWEP.PrintName})
