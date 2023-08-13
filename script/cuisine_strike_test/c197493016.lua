---@version 5.3
---@module "edopro_typehint_helper"
---Card: Summoning Crust

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.hp_cost = 500
s.ingredient_set_max_grade = 2

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 200)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_GRAIN), 1, 2)

	local set_ingredient_e = Effect.CreateEffect(c)
	set_ingredient_e:SetType(EFFECT_TYPE_IGNITION)
	set_ingredient_e:SetRange(LOCATION_SZONE)
	set_ingredient_e:SetCondition(s.condition)
	set_ingredient_e:SetCost(s.cost)
	set_ingredient_e:SetTarget(s.target)
	set_ingredient_e:SetOperation(s.operation)
	set_ingredient_e:SetCountLimit(1)
	c:RegisterEffect(set_ingredient_e)

end

---@type CardFilterFunction
function s.ingredient_set_filter(c)
	return CS.IsIngredientCard(c) and CS.GetGrade(c) <= s.ingredient_set_max_grade and (c:IsRace(CS.CLASS_CHEESE) or c:IsRace(CS.CLASS_MEAT) or c:IsRace(CS.CLASS_VEGETABLE))
end

---@type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(CS.IsDishCard, tp, 0, LOCATION_MZONE, 1, nil)
end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp) > s.hp_cost end
	Duel.PayLPCost(tp, s.hp_cost)
end

---@type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ingredient_set_filter, tp, LOCATION_GRAVE, 0, 1, nil) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 end
end

---@type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.SelectMatchingCard(tp, s.ingredient_set_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil):GetFirst()
	if tc then
		Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	end
end