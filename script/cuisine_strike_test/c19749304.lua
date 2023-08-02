-- toasty

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	cs.InitializeIngredientEffects(c, {grade=1})
end