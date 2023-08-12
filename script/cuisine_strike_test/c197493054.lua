---@version 5.3
---@module "edopro_typehint_helper"
---Card: Barbarleyian

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.str_gain_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- buff str & add piercing
	local str_gain_e = Effect.CreateEffect(c)
	str_gain_e:SetType(EFFECT_TYPE_IGNITION)
	str_gain_e:SetCategory(CATEGORY_ATKCHANGE)
	str_gain_e:SetRange(LOCATION_SZONE)
	str_gain_e:SetTarget(s.target)
	str_gain_e:SetOperation(s.operation)
	str_gain_e:SetCountLimit(1)
	c:RegisterEffect(str_gain_e)
end

--- @type CardFilterFunction
function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type CardFilterFunction
function s.tohand_filter(c)
	return c:IsCode(CS.CARD_PIERCING_STRIKE)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil) end
end

--- @type ConditionFunction
function s.tohand_condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.tohand_filter, tp, LOCATION_GRAVE, 0, 1, nil) and Duel.GetLP(tp) < Duel.GetLP(1-tp)
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
	if tc then
		if tc:UpdateAttack(s.str_gain_amount, RESET_EVENT + RESETS_STANDARD_DISABLE, e:GetHandler()) == 0 then return end
		if s.tohand_condition(e, tp, eg, ep, ev, re, r, rp) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
			local tg2 = Duel.SelectMatchingCard(tp, s.tohand_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
			if #tg2 > 0 then
				Duel.SendtoHand(tg2, tp, REASON_EFFECT)
			end
		end
	end
end