---@version 5.3
---@module "edopro_typehint_helper"
---Card: Plate Return

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

--- @type ActionEffectOptions
s.action_effect_options = {
	type = "trigger",
	code = EVENT_DESTROY,
	properties = EFFECT_FLAG_DAMAGE_STEP,
	condition = function (e, tp, eg, ep, ev, re, r, rp)
		return eg and eg:IsExists(s.destroyed_card_filter, 1, nil, tp)
	end,
	operation = function (e, tp, eg, ep, ev, re, r, rp)
		local tg = eg:Filter(s.destroyed_card_filter, nil, tp)
		if #tg > 0 then
			-- select one of dishes to return to deck
			local tc = tg:Select(tp, 1, 1, false, nil):GetFirst()
			if tc and Duel.SendtoDeck(tc, nil, SEQ_DECKTOP, REASON_EFFECT) > 0 and s.ingredient_set_condition(e, tp, eg, ep, ev, re, r, rp, tc) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
				-- set one matching ingredients from trash
				local tc2 = Duel.SelectMatchingCard(tp, s.ingredient_set_filter, tp, LOCATION_GRAVE, 0, 1, 1, false, nil, tc):GetFirst()
				if tc2 then
					Duel.MoveToField(tc2, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
				end
			end
		end
	end
}

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	local e1 = CS.CreateActionEffect(c, s.action_effect_options)
	c:RegisterEffect(e1)

end

function s.destroyed_card_filter(c, tp)
	return CS.IsDishCard(c) and c:IsControler(tp)
end

function s.ingredient_set_condition(e, tp, eg, ep, ev, re, r, rp, ec)
	return Duel.IsExistingMatchingCard(s.ingredient_set_filter, tp, LOCATION_GRAVE, 0, 1, nil, ec) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
end

function s.ingredient_set_filter(c, ec)
	if not CS.IsIngredientCard(c) then return false end
	local grade = CS.GetGrade(c)
	local recycled_base_grade = CS.GetBaseGrade(ec)
	return grade <= 2 and grade <= recycled_base_grade
end