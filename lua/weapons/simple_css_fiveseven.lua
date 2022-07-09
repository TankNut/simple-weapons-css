AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "Five-seven"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_fiveseven.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_fiveseven.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 20,
	DefaultClip = 40,

	Damage = 17,
	Delay = 60 / 400,

	Range = 1600,
	Accuracy = 12,

	RangeModifier = 0.81,

	Recoil = {
		MinAng = Angle(1.4, -0.3, 0),
		MaxAng = Angle(1.8, 0.3, 0),
		Punch = 0.3,
		Ratio = 0.6
	},

	Sound = "Weapon_FiveSeven.Single",
	TracerName = "Tracer"
}

SWEP.NPCData = {
	Burst = {2, 3},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_css_fiveseven", title = "Simple Weapons: " .. SWEP.PrintName})
