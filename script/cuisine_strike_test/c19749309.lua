-- bacon saber & egg

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_boost_multiplier = 100

function s.initial_effect(c)

	cs.InitializeDishEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, cs.CARD_PIG_FAIRY, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_EGG))

	local pow_boost_eff = Effect.CreateEffect(c)
	pow_boost_eff:SetType(EFFECT_TYPE_FIELD)
	pow_boost_eff:SetCode(EFFECT_UPDATE_ATTACK)
	pow_boost_eff:SetRange(LOCATION_MZONE)
	pow_boost_eff:SetTargetRange(LOCATION_MZONE, 0)
	pow_boost_eff:SetTarget(aux.TRUE)
	pow_boost_eff:SetValue(function (e, c)
		return cs.GetBonusGrade(e:GetHandler()) * power_boost_multiplier
	end)
	c:RegisterEffect(pow_boost_eff)

end