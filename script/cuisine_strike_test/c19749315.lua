---@version 5.3
---@module "edopro_typehint_helper"
---chickatoo

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)
	
	-- recycle & grade up ingredient
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	
	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk==0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 and c:IsAbleToGraveAsCost() end
		Duel.DiscardHand(tp, aux.TRUE, 1, 1, REASON_COST, nil)
		Duel.SendtoGrave(c, REASON_COST)
	end)

	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, e:GetHandler()) end
	end)

	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_GRAVE, 0, 1, 1, c)
		if #g > 0 then
			local tc = g:GetFirst()
			if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
				local e1 = Effect.CreateEffect(tc)
				e1:SetCategory(CATEGORY_LVCHANGE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
				e1:SetValue(2)
				tc:RegisterEffect(e1)
			end
		end
	end)

	c:RegisterEffect(e1)
end

function s.filter(c)
	return CuisineStrike.IsIngredientCard(c) and c:IsRace(CuisineStrike.CLASS_MEAT) and c:GetLevel() <= 2
end