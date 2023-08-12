---@version 5.3
---@module "edopro_typehint_helper"
---Card: Dragon Wheellington

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.extra_def_min_def = 500
s.extra_def_multiplier = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 100)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_BUN_GARDNA, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT))

	-- gain extra def
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

end

--- @type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetDefense() <= s.extra_def_min_def
end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
	local tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
	if CS.IsIngredientCard(tc) then
		e:SetLabel(CS.GetGrade(tc))
	else
		e:SetLabel(0)
	end
	Duel.DiscardDeck(tp, 1, REASON_COST)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local cost_grade = e:GetLabel()
	if cost_grade > 0 then
		local extra_def_e = Effect.CreateEffect(c)
		extra_def_e:SetType(EFFECT_TYPE_SINGLE)
		extra_def_e:SetCode(EFFECT_UPDATE_DEFENSE)
		extra_def_e:SetRange(LOCATION_MZONE)
		extra_def_e:SetValue(function (e)
			return cost_grade * s.extra_def_multiplier
		end)
		extra_def_e:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
		c:RegisterEffect(extra_def_e)
	end
end