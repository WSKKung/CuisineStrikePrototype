---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bun Gardna

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.armor_min_grade = 3

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 0)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	-- shield
	local shield_e = Effect.CreateEffect(c)
	shield_e:SetType(EFFECT_TYPE_SINGLE)
	shield_e:SetRange(LOCATION_MZONE)
	shield_e:SetCode(CS.EFFECT_UPDATE_ARMOR_VALUE)
	shield_e:SetCondition(s.armor_condition)
	shield_e:SetValue(100)
	c:RegisterEffect(shield_e)

end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_GRAIN)
end

--- @type ConditionFunction
function s.armor_condition(e, tp, eg, ep, ev, re, r, rp)
	return CS.GetGrade(e:GetHandler()) >= s.armor_min_grade
end