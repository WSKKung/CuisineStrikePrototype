---@version 5.3
---@module "edopro_typehint_helper"
---bacon saber sandwitch

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local power_boost_multiplier = 100

function s.initial_effect(c)

	CuisineStrike.InitializeDishEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CuisineStrike.CARD_PIG_FAIRY, aux.FilterBoolFunctionEx(Card.IsRace, CuisineStrike.CLASS_BREAD))

	-- give power to a dish
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
		Duel.DiscardDeck(tp, 1, REASON_COST)
	end)

	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil) end
	end)

	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
		if #g > 0 then
			local tc = g:GetFirst()
			local boost_amount = c:GetLevel() * power_boost_multiplier

			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(boost_amount)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e1)
		end
	end)

	c:RegisterEffect(e1)

end

function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end