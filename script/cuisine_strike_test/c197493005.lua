---@version 5.3
---@module "edopro_typehint_helper"
---Card: Quiche gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 200)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_GRAIN), aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_EGG))

end