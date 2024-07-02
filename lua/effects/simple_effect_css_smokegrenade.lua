simple_weapons.Include("Convars.css")

local ROTATION_SPEED = 0.1

local SMOKEGRENADE_PARTICLERADIUS = 80
local SMOKESPHERE_EXPAND_TIME = 1
local NUM_PARTICLES_PER_DIMENSION = 4
local SMOKEPARTICLE_OVERLAP = 20
local SMOKEPARTICLE_SIZE = 80

local mat = CreateMaterial("simple_effect_css_smokegrenade", "unlitgeneric", {
	["$basetexture"] = "particle/particle_smokegrenade_thick",
	["$vertexcolor"] = "1",
	["$vertexalpha"] = "1",
	["$translucent"] = "1"
})

local function vec2index(x, y, z)
	return z * NUM_PARTICLES_PER_DIMENSION * NUM_PARTICLES_PER_DIMENSION + y * NUM_PARTICLES_PER_DIMENSION + x
end

function EFFECT:Init(data)
	self:SetPos(data:GetOrigin())
	self:SetRenderBounds(vector_origin, vector_origin, Vector(50, 50, 50))

	self.StartTime = CurTime()
	self.FadeAlpha = 1

	self.ExpandTime = 0
	self.ExpandRadius = 0

	self.Particles = {}

	self.SpacingRadius = (SMOKEGRENADE_PARTICLERADIUS - SMOKEPARTICLE_OVERLAP) * NUM_PARTICLES_PER_DIMENSION * 0.5

	local invNumPerDim = 1 / (NUM_PARTICLES_PER_DIMENSION - 1)
	local emitter = ParticleEmitter(data:GetOrigin(), false)

	local origin = data:GetOrigin()
	local pos = Vector()

	for x = 0, NUM_PARTICLES_PER_DIMENSION - 1 do
		pos.x = origin.x + (x * invNumPerDim) * self.SpacingRadius * 2 - self.SpacingRadius

		for y = 0, NUM_PARTICLES_PER_DIMENSION - 1 do
			pos.y = origin.y + (y * invNumPerDim) * self.SpacingRadius * 2 - self.SpacingRadius

			for z = 0, NUM_PARTICLES_PER_DIMENSION - 1 do
				pos.z = origin.z + (z * invNumPerDim) * self.SpacingRadius * 2 - self.SpacingRadius

				local particle = emitter:Add(mat, pos)

				particle.StoredPos = pos - data:GetOrigin()
				particle.RandOffset = VectorRand(-5, 5)

				particle.ColorRand = math.Rand(0, 255)

				particle:SetStartSize(SMOKEPARTICLE_SIZE)
				particle:SetEndSize(SMOKEPARTICLE_SIZE)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetRoll(math.Rand(-6, 6))
				particle:SetRollDelta(math.Rand(-ROTATION_SPEED, ROTATION_SPEED))

				particle:SetLighting(false)

				particle:SetDieTime(5)

				self.Particles[vec2index(x, y, z)] = particle
			end
		end
	end

	emitter:Finish()
end

local minColor = Vector(0.5, 0.5, 0.5)
local maxColor = Vector(0.6, 0.6, 0.6)

function EFFECT:Think()
	local lifetime = CurTime() - self.StartTime

	local FADE_START = SmokeDuration:GetFloat()
	local FADE_END = FADE_START + SmokeFade:GetFloat()

	if lifetime < FADE_START then
		self.FadeAlpha = 1
	elseif lifetime < FADE_END then
		local fade = (lifetime - FADE_START) / (FADE_END - FADE_START)

		self.FadeAlpha = math.cos(fade * 3.14159) * 0.5 + 0.5;
	else
		return false
	end

	self.FadeAlpha = self.FadeAlpha * self.ExpandRadius / (self.SpacingRadius * 2)

	self.ExpandTime = math.min(lifetime, SMOKESPHERE_EXPAND_TIME)
	self.ExpandRadius = (self.SpacingRadius * 2) * math.sin(self.ExpandTime * math.pi * 0.5 / SMOKESPHERE_EXPAND_TIME)

	for k, v in pairs(self.Particles) do
		v:SetLifeTime(0)

		local len = v.StoredPos:Length()
		local rand = Vector(util.SharedRandom(k, -1, 1, 1), util.SharedRandom(k, -1, 1, 2), util.SharedRandom(k, -1, 1, 3))

		if len > self.ExpandRadius * 0.5 then
			v:SetPos(self:GetPos() + v.RandOffset + (v.StoredPos * (self.ExpandRadius * 0.5)) / len + rand)
		else
			v:SetPos(self:GetPos() + v.RandOffset + v.StoredPos + rand)
		end

		local alpha = 1 - len / self.ExpandRadius

		if alpha > 0.3 then
			alpha = 1
		else
			alpha = alpha / 0.3
		end

		alpha = math.min(math.abs(alpha * self.FadeAlpha), 1)

		v:SetStartAlpha(alpha * 255)

		local color = minColor + (maxColor - minColor) * (v.ColorRand / 255.1)

		color = (color + Vector(0.25, 0.25, 0.25)) / 2

		v:SetColor(color.x * 255, color.y * 255, color.z * 255)
	end

	local dist = EyePos():Distance(self:GetPos());
	local core = self.ExpandRadius * 0.3

	if dist < self.ExpandRadius then
		if dist < core then
			simple_weapons.SmokeOverlay = simple_weapons.SmokeOverlay + self.FadeAlpha
		else
			simple_weapons.SmokeOverlay = simple_weapons.SmokeOverlay + (1 - (dist - core) / (self.ExpandRadius - core)) * self.FadeAlpha
		end
	end

	return true
end

function EFFECT:Render()
end

local overlayMat = Material("particle/screenspace_fog")
local overlayColor = 0.3 * 255

simple_weapons.SmokeOverlay = 0

hook.Add("RenderScreenspaceEffects", "simple_effect_css_smokegrenade", function()
	surface.SetMaterial(overlayMat)
	surface.SetDrawColor(overlayColor, overlayColor, overlayColor, math.Clamp(simple_weapons.SmokeOverlay, 0, 1) * 255)
	surface.DrawTexturedRect(-1, -1, ScrW() + 1, ScrH() + 1)

	simple_weapons.SmokeOverlay = 0
end)
