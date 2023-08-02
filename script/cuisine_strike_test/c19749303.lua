---@version 5.3
---@module "edopro_typehint_helper"
---cowvern

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_boost_amount = 100

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)

	local power_boost_e = Effect.CreateEffect(c)
	power_boost_e:SetType(EFFECT_TYPE_FIELD)
	power_boost_e:SetCode(EFFECT_UPDATE_ATTACK)
	power_boost_e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	power_boost_e:SetRange(LOCATION_SZONE)
	power_boost_e:SetTargetRange(LOCATION_MZONE, 0)
	power_boost_e:SetValue(power_boost_amount)
	c:RegisterEffect(power_boost_e)
end