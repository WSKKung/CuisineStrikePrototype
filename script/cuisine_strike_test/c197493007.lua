---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bacon Squire

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.stat_boost_min_grade = 2
s.stat_boost_multiplier = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	local str_boost_e = Effect.CreateEffect(c)
	str_boost_e:SetDescription(aux.Stringid(id, 0))
	str_boost_e:SetType(EFFECT_TYPE_IGNITION)
	str_boost_e:SetRange(LOCATION_MZONE)
	str_boost_e:SetCondition(s.condition)
	str_boost_e:SetCost(s.cost)
	str_boost_e:SetOperation(s.operation)
	c:RegisterEffect(str_boost_e)

end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_MEAT) and not CS.IsDishCard(c)
end

--- @type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp, ...)
	return CS.GetGrade(e:GetHandler()) >= s.stat_boost_min_grade
end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
	local tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
	if tc and CS.IsIngredientCard(tc) then
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
	local discard_grade = e:GetLabel()
	if discard_grade > 0 then
		local str_boost_amount = discard_grade * s.stat_boost_multiplier
		e:GetHandler():UpdateAttack(str_boost_amount, RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END)
	end
end