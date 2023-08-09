---@version 5.3
---@module "edopro_typehint_helper"
---Card: Mold invasion

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.grade_reduc_amount = 1

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	local e1 = CS.CreateActionEffect(c, {
		type = "trigger",
		code = EVENT_MOVE,
		condition = function (e, tp, eg, ep, ev, re, r, rp)
			return eg and eg:IsExists(s.ingredient_set_filter, 1, nil, tp)
		end,
		cost = function (e, tp, eg, ep, ev, re, r, rp, chk)
			local c = e:GetHandler()
			if chk==0 then return Duel.GetMatchingGroupCount(Card.IsDiscardable, tp, LOCATION_HAND, 0, c) > 0 end
			local tg = Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, c)
			Duel.SendtoGrave(tg, REASON_COST + REASON_DISCARD)
		end,
		operation = function (e, tp, eg, ep, ev, re, r, rp)
			local tg = eg:Filter(s.ingredient_set_filter, nil, tp)
			local desg = Group.CreateGroup()
			tg:ForEach(function (tc)
				if tc:GetLevel() == 1 then
					desg:AddCard(tc)
				else
					local e2 = Effect.CreateEffect(tc)
					e2:SetCategory(CATEGORY_LVCHANGE)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UPDATE_LEVEL)
					e2:SetValue(-s.grade_reduc_amount)
					tc:RegisterEffect(e2)
				end
			end)
			if #desg > 0 then
				Duel.Destroy(desg, REASON_EFFECT)
			end
		end
	})
	c:RegisterEffect(e1)

end

function s.ingredient_set_filter(c, tp)
	return c:IsFaceup() and CS.IsIngredientCard(c) and c:IsPreviousLocation(LOCATION_HAND) and c:IsLocation(LOCATION_SZONE) and c:IsControler(1-tp) and c:GetSequence() < 5
end