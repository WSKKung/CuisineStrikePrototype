---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bacon Saber & Egg

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.power_boost_multiplier = 100

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 200)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_BACON_SQUIRE, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_EGG))

	local pow_boost_eff = Effect.CreateEffect(c)
	pow_boost_eff:SetType(EFFECT_TYPE_FIELD)
	pow_boost_eff:SetCode(EFFECT_UPDATE_ATTACK)
	pow_boost_eff:SetRange(LOCATION_MZONE)
	pow_boost_eff:SetTargetRange(LOCATION_MZONE, 0)
	pow_boost_eff:SetTarget(aux.TRUE)
	pow_boost_eff:SetValue(s.value)
	c:RegisterEffect(pow_boost_eff)

end

function s.value(e, c)
	return CS.GetBonusGrade(e:GetHandler()) * s.power_boost_multiplier
end