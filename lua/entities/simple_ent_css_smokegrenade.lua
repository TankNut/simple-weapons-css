AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_ent_grenade_base")

ENT.Base = "simple_ent_grenade_base"

ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")

function ENT:Think()
	if CLIENT then
		return
	end

	if self.Detonate and self.Detonate <= CurTime() and self:GetVelocity():Length() < 0.1 then
		self:Explode()
		self:NextThink(math.huge)

		return true
	end

	self:NextThink(CurTime() + 0.1)

	return true
end

function ENT:Explode()
	self:EmitSound("BaseSmokeEffect.Sound")

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())

	local filter = RecipientFilter()
	filter:AddAllPlayers()

	util.Effect("simple_effect_css_smokegrenade", effect, true, filter)

	self:Remove()
end
