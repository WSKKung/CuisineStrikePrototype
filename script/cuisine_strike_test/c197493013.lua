---@version 5.3
---@module "edopro_typehint_helper"
---Card: Pizzaestro Pepperoni

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.hp_cost = 300

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_SUMMONING_CRUST, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT))

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
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local reset = RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END
	local bonus_grade = CS.GetBonusGrade(c)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
	if tc then
		tc:AddPiercing(reset, c)
		tc:UpdateAttack(bonus_grade * 100, reset, c)
	end
end