---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bun Gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	-- shield
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(CS.EFFECT_UPDATE_ARMOR_VALUE)
	e1:SetValue(100)
	c:RegisterEffect(e1)
end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_GRAIN)
end