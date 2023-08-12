---@version 5.3
---@module "edopro_typehint_helper"
---Card: Pizzaestro Quattro Formaggi

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.hp_cost = 400
s.damage_amount = 400

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 200, 0)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_CHEESE), 1, 2, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_BREAD))

	-- gain atk
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLP(tp) > s.hp_cost end
	Duel.PayLPCost(tp, s.hp_cost)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, 0, LOCATION_MZONE, 1, 1, nil):GetFirst()
	if tc then
		CS.Damage(tc, s.damage_amount, REASON_EFFECT, c, tp)
	end
end