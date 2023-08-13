---@version 5.3
---@module "edopro_typehint_helper"
---Card: Pizzaestro Grande Margherita

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 200, 0)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_TOMATOAD, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_BREAD), aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_CHEESE))

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
	local c = e:GetHandler()
	local hp_cost = CS.GetGrade(c) * 100
	if chk==0 then return Duel.GetLP(tp) > hp_cost end
	Duel.PayLPCost(tp, hp_cost)
	e:SetLabel(hp_cost)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local hp_cost = e:GetLabel()
	local c = e:GetHandler()
	c:UpdateAttack(hp_cost)
end