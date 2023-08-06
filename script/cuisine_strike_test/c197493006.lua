---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bun Gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, s.material_filter)
end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_GRAIN) or c:IsRace(CS.CLASS_BREAD)
end