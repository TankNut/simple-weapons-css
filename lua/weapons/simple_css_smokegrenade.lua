AddCSLuaFile()

if CLIENT then
	language.Add("simple_css_smokegrenade_ammo", "Smoke Grenades")
end

game.AddAmmoType({name = "simple_css_smokegrenade", maxcarry = 5})

SWEP.Base = "simple_base_throwing"

SWEP.PrintName = "Smoke Grenade"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.Slot = 4

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_eq_smokegrenade.mdl")
SWEP.WorldModel = Model("models/weapons/w_eq_smokegrenade.mdl")

SWEP.HoldType = "melee"

SWEP.Primary = {
	Ammo = "simple_css_smokegrenade",

	ThrowAct = {ACT_VM_PULLBACK_HIGH, ACT_VM_THROW},
	LobAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK},
	RollAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK}
}

function SWEP:CreateEntity()
	local ent = ents.Create("simple_ent_css_smokegrenade")
	local ply = self:GetOwner()

	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:EyeAngles())
	ent:SetOwner(ply)
	ent:Spawn()
	ent:Activate()

	ent:SetTimer(1.5)

	return ent
end
