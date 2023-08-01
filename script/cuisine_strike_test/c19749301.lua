-- bun gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local damage_reduc_amoount = 200

function s.initial_effect(c)
	cs.initial_ingredient_effect(c, {grade=2})

	local damage_reduc_e = Effect.CreateEffect(c)
	damage_reduc_e:SetType(EFFECT_TYPE_FIELD)
	damage_reduc_e:SetCode(EFFECT_CHANGE_DAMAGE)
	damage_reduc_e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	damage_reduc_e:SetRange(LOCATION_SZONE)
	damage_reduc_e:SetTargetRange(1, 0)
	damage_reduc_e:SetValue(function (e, re, val, r, rp, rc)
		if val > damage_reduc_amoount then
			return val - damage_reduc_amoount
		else
			return 0
		end
	end)
	c:RegisterEffect(damage_reduc_e)

end