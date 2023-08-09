---@version 5.3
---@module "edopro_typehint_helper"
---Card: Burger Dragon

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 300, 100)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_COWVERN, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_BREAD))

end