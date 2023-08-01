-- dragon burger

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_boost_multiplier = 300

function s.initial_effect(c)

	cs.initial_dish_effect(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, cs.CARD_COWVERN, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_BREAD))
	
	-- increase atk
	local atk_boost_eff = Effect.CreateEffect(c)
	atk_boost_eff:SetType(EFFECT_TYPE_SINGLE)
	atk_boost_eff:SetCode(EFFECT_UPDATE_ATTACK)
	atk_boost_eff:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	atk_boost_eff:SetRange(LOCATION_MZONE)
	atk_boost_eff:SetValue(function(e, c)
		return cs.GetBonusGrade(c) * power_boost_multiplier
	end)
	c:RegisterEffect(atk_boost_eff)

end