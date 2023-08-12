---@version 5.3
---@module "edopro_typehint_helper"
---Card: Mr. Spaghettinora

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_GRAIN), 1, 2)

end