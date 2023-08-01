-- quiche gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local health_base = 600
local health_boost_multiplier = 300

function s.initial_effect(c)

	cs.initial_dish_effect(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, cs.CARD_BUN_GARDNA, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_EGG))
	
	-- increase atk
	local hp_boost_eff = Effect.CreateEffect(c)
	hp_boost_eff:SetType(EFFECT_TYPE_SINGLE)
	hp_boost_eff:SetCode(EFFECT_SET_BASE_DEFENSE)
	hp_boost_eff:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	hp_boost_eff:SetRange(LOCATION_MZONE)
	hp_boost_eff:SetValue(function(e, c)
		return health_base + cs.GetBonusGrade(c) * health_boost_multiplier
	end)
	c:RegisterEffect(hp_boost_eff)

end