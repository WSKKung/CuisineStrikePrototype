---@version 5.3
---@module "edopro_typehint_helper"
---Card: Princess Omelizabette

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.stat_boost_min_grade = 2
s.stat_boost_amount = 100

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	local heal_e = Effect.CreateEffect(c)
	heal_e:SetDescription(aux.Stringid(id, 0))
	heal_e:SetType(EFFECT_TYPE_IGNITION)
	heal_e:SetRange(LOCATION_MZONE)
	heal_e:SetCost(s.cost)
	heal_e:SetTarget(s.target)
	heal_e:SetOperation(s.operation)
	heal_e:SetCountLimit(1)
	c:RegisterEffect(heal_e)

end

---@type CardFilterFunction
function s.material_filter(c)
	return c:IsRace(CS.CLASS_EGG) and not CS.IsDishCard(c)
end

--- @type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp, ...)
	return CS.GetGrade(e:GetHandler()) >= s.stat_boost_min_grade
end

---@type CardFilterFunction
function s.cost_filter(c)
	return CS.IsIngredientCard(c)
end

---@type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cost_filter, tp, LOCATION_GRAVE, 0, 1, nil) end
	local tc = Duel.SelectMatchingCard(tp, s.cost_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil):GetFirst()
	if tc and Duel.SendtoDeck(tc, tp, SEQ_DECKSHUFFLE, REASON_COST) then
		e:SetLabel(CS.GetGrade(tc))
	end
end

---@type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return CS.IsPlayerAbleToHeal(tp) end
end

---@type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local cost_grade = e:GetLabel()
	CS.HealPlayer(tp, cost_grade * 100)
end