AddCSLuaFile()

simple_weapons.Include("Convars.css")

DEFINE_BASECLASS("simple_ent_grenade_base")

ENT.Base = "simple_ent_grenade_base"

ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

local damage = 4

function ENT:Explode()
	self:EmitSound("Flashbang.Explode")

	local origin = self:GetPos() + Vector(0, 0, 1)
	local radius = FlashRange:GetFloat()
	local falloff = damage / radius

	for _, v in pairs(player.GetAll()) do
		local pos = v:EyePos()
		local dist = pos:DistToSqr(origin)

		if dist > radius * radius then
			continue
		end

		local tr = util.TraceLine({
			start = origin,
			endpos = pos,
			mask = MASK_VISIBLE,
			filter = self,
			collisiongroup = COLLISION_GROUP_NONE
		})

		if tr.Fraction < 1 and tr.Entity != v then
			continue
		end

		if hook.Run("SimpleCanBeFlashed", v) == false then
			continue
		end

		local diff = origin - pos
		local severity = (damage - (diff):Length() * falloff) * FlashSeverity:GetFloat()

		local dot = diff:GetNormalized():Dot(v:GetAimVector())

		local fadeTime = 0
		local fadeHold = 0
		local alpha = 255

		if dot >= 0.5 then
			fadeTime = severity * 2.5
			fadeHold = severity * 1.25
		elseif dot >= -0.5 then
			fadeTime = severity * 1.75
			fadeHold = severity * 0.8
		else
			fadeTime = severity
			fadeHold = severity * 0.75
			alpha = 200
		end

		local curTime = CurTime()

		local oldUntil = v.sw_blindUntilTime or 0
		local data = {}

		v.sw_blindUntilTime = math.max(curTime + fadeHold + 0.5 * fadeTime)
		v.sw_blindStartTime = curTime

		fadeTime = fadeTime / 1.4

		if curTime > oldUntil then
			v.sw_flFlashDuration = fadeTime
			data.m_flFlashDuration = v.sw_flFlashDuration

			v.sw_flFlashMaxAlpha = alpha
			data.m_flFlashMaxAlpha = v.sw_flFlashMaxAlpha
		else
			local remaining = oldUntil + v.sw_flFlashDuration - curTime

			v.sw_flFlashDuration = math.max(remaining, fadeTime)
			data.m_flFlashDuration = v.sw_flFlashDuration

			v.sw_flFlashMaxAlpha = math.max(v.sw_flFlashMaxAlpha, alpha)
			data.m_flFlashMaxAlpha = v.sw_flFlashMaxAlpha
		end

		net.Start("simple_ent_css_flashbang")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteVector(self:GetPos())
			net.WriteTable(data)
		net.Send(v)

		local dspRange = radius / 3

		if dist <= dspRange * dspRange then
			v:SetDSP(35)
		end
	end

	self:Remove()
end

if SERVER then
	util.AddNetworkString("simple_ent_css_flashbang")
else
	net.Receive("simple_ent_css_flashbang", function()
		local ply = LocalPlayer()

		local index = net.ReadUInt(16)
		local pos = net.ReadVector()

		local light = DynamicLight(index)

		light.pos = pos
		light.r = 255
		light.g = 255
		light.b = 255
		light.brightness = 2
		light.radius = 400
		light.decay = 768
		light.DieTime = CurTime() + 0.1

		local data = net.ReadTable()

		if not ply.sw_flash or (ply.sw_flash.m_flFlashDuration != data.m_flFlashDuration and data.m_flFlashDuration > 0) then
			data.m_flFlashAlpha = 1
			data.newTexture = true
		end

		data.m_flFlashBangTime = CurTime() + data.m_flFlashDuration

		ply.sw_flash = data
	end)

	local rt = GetRenderTarget("simple_flashbang_rt", ScrW(), ScrH(), true)

	local mat = CreateMaterial("simple_flashbang", "unlitgeneric", {
		["$basetexture"] = "simple_flashbang_rt",
		["$translucent"] = 1,
		["$additive"] = 1,
		["$vertexalpha"] = 1
	})

	local mat2 = Material("effects/flashbang_white")

	hook.Add("RenderScreenspaceEffects", "simple_ent_css_flashbang", function()
		local data = LocalPlayer().sw_flash

		if not data then
			return
		end

		local curTime = CurTime()

		if data.m_flFlashBangTime < curTime then
			return
		end

		surface.SetMaterial(mat)

		if data.newTexture then
			data.newTexture = nil

			render.CopyTexture(render.GetScreenEffectTexture(0), rt)
		end

		if data.m_flFlashAlpha < data.m_flFlashMaxAlpha then
			data.m_flFlashAlpha = math.min(data.m_flFlashAlpha + 45, data.m_flFlashMaxAlpha)

			mat:SetFloat("$alpha", data.m_flFlashAlpha / 255)

			-- Overkill but it's how valve did it

			surface.SetDrawColor(data.m_flFlashAlpha, data.m_flFlashAlpha, data.m_flFlashAlpha)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(data.m_flFlashAlpha, data.m_flFlashAlpha, data.m_flFlashAlpha)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		else
			local alpha = math.Clamp(data.m_flFlashMaxAlpha * (data.m_flFlashBangTime - curTime) / data.m_flFlashDuration, 0, data.m_flFlashMaxAlpha)

			mat:SetFloat("$alpha", alpha / 255)

			surface.SetDrawColor(alpha, alpha, alpha)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(alpha, alpha, alpha)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end

		surface.SetMaterial(mat2)

		local alpha = 255

		if data.m_flFlashAlpha < data.m_flFlashMaxAlpha then
			alpha = data.m_flFlashAlpha
		else
			local timeLeft = data.m_flFlashBangTime - curTime
			local alphaMult = 1

			if timeLeft > 3 then
				alphaMult = 1
			else
				alphaMult = timeLeft / 3

				alphaMult = alphaMult * alphaMult
			end

			alpha = math.Clamp(alphaMult * data.m_flFlashMaxAlpha, 0, data.m_flFlashMaxAlpha)
		end

		surface.SetDrawColor(alpha, alpha, alpha, alpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end)
end
