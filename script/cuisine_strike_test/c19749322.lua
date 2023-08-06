---@version 5.3
---@module "edopro_typehint_helper"
---meowzzarella

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_reduce_amount = 200

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)

	local power_reduc_e = Effect.CreateEffect(c)
	power_reduc_e:SetType(EFFECT_TYPE_FIELD)
	power_reduc_e:SetCode(EFFECT_UPDATE_ATTACK)
	power_reduc_e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	power_reduc_e:SetRange(LOCATION_SZONE)
	power_reduc_e:SetTargetRange(0, LOCATION_MZONE)
	power_reduc_e:SetValue(-power_reduce_amount)
	c:RegisterEffect(power_reduc_e)
end