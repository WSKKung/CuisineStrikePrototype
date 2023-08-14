---@version 5.3
---@module "edopro_typehint_helper"
---Card: Fettuciara Alfredo

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 100)

	Fusion.AddProcMix(c, true, true, aux.FilterBoolFunction(Card.IsRace, CS.CLASS_PASTA), aux.FilterBoolFunction(Card.IsRace, CS.CLASS_CHEESE))

	-- gain attack
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.atk_src_filter(c)
	return CS.IsDishCard(c) and c:GetDefense() > 0
end

function s.atk_target_filter(c)
	return CS.IsDishCard(c)
end

--- @type ConditionFunction
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetLP(tp) < Duel.GetLP(1-tp)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atk_src_filter, tp, 0, LOCATION_MZONE, 1, nil) and Duel.IsExistingMatchingCard(s.atk_target_filter, tp, LOCATION_MZONE, 0, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	-- select target to gain str from
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 0))
	local src_c = Duel.SelectMatchingCard(tp, s.atk_src_filter, tp, 0, LOCATION_MZONE, 1, 1, false, nil):GetFirst()
	if not src_c then return end

	Duel.ConfirmCards(1-tp, src_c)

	-- select target to give str to
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 1))
	local dest_c = Duel.SelectMatchingCard(tp, s.atk_target_filter, tp, LOCATION_MZONE, 0, 1, 1, false, nil):GetFirst()
	if not dest_c then return end

	Duel.ConfirmCards(1-tp, dest_c)

	dest_c:UpdateAttack(src_c:GetDefense(), RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END, c)

end