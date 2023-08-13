---@version 5.3
---@module "edopro_typehint_helper"
---Card: Milksludge

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.heal_amount = 500

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- heal
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)

end

---@type CardFilterFunction
function s.cost_filter(c)
	return CS.IsIngredientCard(c)
end

---@type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetLP(tp) < Duel.GetLP(1-tp)
end

---@type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cost_filter, tp, LOCATION_GRAVE, 0, 1, nil) end
	local tc = Duel.SelectMatchingCard(tp, s.cost_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil):GetFirst()
	if tc then
		Duel.SendtoDeck(tc, nil, SEQ_DECKSHUFFLE, REASON_COST)
	end
end

---@type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return CS.IsPlayerAbleToHeal(tp) end
end

---@type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	CS.HealPlayer(tp, s.heal_amount)
end