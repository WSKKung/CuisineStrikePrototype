-- plate return

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	cs.InitializeActionEffects(c)

	local e1 = cs.CreateActionActivationEffect(c, {
		condition = function (e, tp, eg, ep, ev, re, r, rp)
			return eg and eg:IsExists(s.destroyed_card_filter, 1, nil, tp)
		end,
		operation = function (e, tp, eg, ep, ev, re, r, rp)
			local tg = eg:Filter(s.destroyed_card_filter, nil, tp)
			if #tg > 0 then
				local tc = tg:Select(tp, 1, 1, false, nil):GetFirst()
				if Duel.SendtoDeck(tc, tp, 0, REASON_EFFECT) > 0 and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
					local tg2 = Duel.SelectMatchingCard(tp, s.ingredient_set_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil, tp, tc:GetRace())
					if #tg2 > 0 then
						local tc2 = tg2:GetFirst()
						Duel.MoveToField(tc2, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
					end
				end
			end
		end
	})
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROY)
	c:RegisterEffect(e1)

end

function s.destroyed_card_filter(c, tp)
	return cs.IsDishCard(c) and c:IsControler(tp)
end

function s.ingredient_set_filter(c, tp, race)
	return cs.IsIngredientCard(c) and c:GetLevel() <= 2 and c:IsControler(tp) and c:IsRace(race)
end