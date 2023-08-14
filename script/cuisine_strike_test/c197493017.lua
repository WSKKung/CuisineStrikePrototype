---@version 5.3
---@module "edopro_typehint_helper"
---Card: Mrs. Spaghettinora

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.hp_cost = 300
s.mill_cost_count = 3

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_GRAIN), 1, 2)

	-- draw
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)

end

---@type CardFilterFunction
function s.filter(c)
	return CS.IsDishCard(c)
end

---@type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil)
end


---@type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp) > s.hp_cost and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) >= s.mill_cost_count + 1 end
	Duel.PayLPCost(tp, s.hp_cost)
	Duel.DiscardDeck(tp, s.mill_cost_count, REASON_COST)
end

---@type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp, 1) end
end

---@type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 1, REASON_EFFECT)
end