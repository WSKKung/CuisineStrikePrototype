---@version 5.3
---@module "edopro_typehint_helper"
---ricatta

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)
end