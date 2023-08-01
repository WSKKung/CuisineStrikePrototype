-- pig fairy

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	cs.initial_ingredient_effect(c, {grade=1})
end