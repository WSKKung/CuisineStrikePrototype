---@version 5.3
---@module "edopro_typehint_helper"
---Card: Wheatsel

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_reduc_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- damage reduction
	local damage_reduc_e = Effect.CreateEffect(c)
	damage_reduc_e:SetType(EFFECT_TYPE_FIELD)
	damage_reduc_e:SetCode(EFFECT_CHANGE_DAMAGE)
	damage_reduc_e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	damage_reduc_e:SetRange(LOCATION_SZONE)
	damage_reduc_e:SetTargetRange(1, 0)
	damage_reduc_e:SetValue(s.value)
	c:RegisterEffect(damage_reduc_e)
end

function s.value(e, re, val, r, rp, rc)
	if val > s.damage_reduc_amount then
		return val - s.damage_reduc_amount
	else
		return 0
	end
end