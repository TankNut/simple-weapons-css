AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_ent_grenade_base")

ENT.Base = "simple_ent_grenade_base"

ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")

ENT.Damage = 70

function ENT:Explode()
	local pos = self:WorldSpaceCenter()

	local explo = ents.Create("env_explosion")
	explo:SetOwner(self:GetOwner())
	explo:SetPos(pos)
	explo:SetKeyValue("iMagnitude", self.Damage * DamageMult:GetFloat())
	explo:SetKeyValue("spawnflags", 32)
	explo:Spawn()
	explo:Activate()
	explo:Fire("Explode")

	self:Remove()
end
