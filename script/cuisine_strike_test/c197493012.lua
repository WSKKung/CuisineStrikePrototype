---@version 5.3
---@module "edopro_typehint_helper"
---Card: Spaghettiara Salsa Di Pomodoro

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 200, 0)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_TOMATOAD, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_PASTA), aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT))

	-- double attack
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetLP(tp) < Duel.GetLP(1-tp)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local double_attack_e = Effect.CreateEffect(c)
	double_attack_e:SetDescription(3201)
	double_attack_e:SetType(EFFECT_TYPE_SINGLE)
	double_attack_e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CLIENT_HINT)
	double_attack_e:SetCode(EFFECT_EXTRA_ATTACK)
	double_attack_e:SetValue(1)
	double_attack_e:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	c:RegisterEffect(double_attack_e)
end