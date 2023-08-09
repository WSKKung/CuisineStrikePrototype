---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bun Gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_reduc_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	-- shield
	local shield_e = Effect.CreateEffect(c)
	shield_e:SetType(EFFECT_TYPE_SINGLE)
	shield_e:SetRange(LOCATION_MZONE)
	shield_e:SetCode(CS.EFFECT_UPDATE_ARMOR_VALUE)
	shield_e:SetValue(100)
	c:RegisterEffect(shield_e)

	-- damage reduction
	local damage_reduc_e = Effect.CreateEffect(c)
	damage_reduc_e:SetType(EFFECT_TYPE_FIELD)
	damage_reduc_e:SetCode(EFFECT_CHANGE_DAMAGE)
	damage_reduc_e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	damage_reduc_e:SetRange(LOCATION_SZONE)
	damage_reduc_e:SetTargetRange(1, 0)
	damage_reduc_e:SetValue(function (e, re, val, r, rp, rc)
		if val > s.damage_reduc_amount then
			return val - s.damage_reduc_amount
		else
			return 0
		end
	end)
	c:RegisterEffect(damage_reduc_e)
end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_GRAIN)
end