---@version 5.3
---@module "edopro_typehint_helper"
---pepperonyx

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_boost_multiplier = 100

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)

	-- grade up & buff dishes in the same column
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		if chk==0 then return Duel.IsExistingMatchingCard(s.cost_filter, tp, LOCATION_GRAVE, 0, 1, nil) end
		local g = Duel.SelectMatchingCard(tp, s.cost_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
		local tc = g:GetFirst()
		if tc then
			Duel.SendtoDeck(tc, tp, SEQ_DECKSHUFFLE, REASON_COST)
			e:SetLabel(tc:GetLevel())
		end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		local c = e:GetHandler()
		local cost_grade = e:GetLabel()
		local reset_flag = RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END
		-- grade up 
		local grade_up_eff = Effect.CreateEffect(c)
		grade_up_eff:SetCategory(CATEGORY_LVCHANGE)
		grade_up_eff:SetType(EFFECT_TYPE_SINGLE)
		grade_up_eff:SetCode(EFFECT_UPDATE_LEVEL)
		grade_up_eff:SetValue(cost_grade)
		grade_up_eff:SetReset(reset_flag)
		c:RegisterEffect(grade_up_eff)
		-- buff dishes
		local dish_buff_eff = Effect.CreateEffect(c)
		dish_buff_eff:SetCategory(CATEGORY_ATKCHANGE)
		dish_buff_eff:SetType(EFFECT_TYPE_FIELD)
		dish_buff_eff:SetCode(EFFECT_UPDATE_ATTACK)
		dish_buff_eff:SetTargetRange(LOCATION_MZONE, 0)
		dish_buff_eff:SetTarget(s.buff_target)
		dish_buff_eff:SetRange(LOCATION_SZONE)
		dish_buff_eff:SetValue(function (e)
			return e:GetHandler():GetLevel() * power_boost_multiplier
		end)
		dish_buff_eff:SetReset(reset_flag)
		c:RegisterEffect(dish_buff_eff)

	end)

	c:RegisterEffect(e1)
end

function s.cost_filter(c)
	return c:IsRace(CuisineStrike.CLASS_MEAT) and c:IsAbleToDeckAsCost()
end

function s.buff_target(e, tc)
	local c = e:GetHandler()
	local tp = e:GetHandlerPlayer()
	return tc:IsColumn(c:GetSequence(), tp, LOCATION_MZONE)
end