local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	cs.initial_dish_effect(c)
	cs.initial_dish_classes(c, cs.CLASS_MEAT, cs.CLASS_BREAD)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, cs.CARD_PIG_FAIRY, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_EGG))
	

end