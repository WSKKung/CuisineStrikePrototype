-- dragon wheellington

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local heal_multiplier = 100

function s.initial_effect(c)

	cs.initial_dish_effect(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, cs.CARD_BUN_GARDNA, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_MEAT))
	
	-- heal
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
		Duel.DiscardDeck(tp, 1, REASON_COST)
	end)
	
	e1:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return cs.IsAbleToHeal(e:GetHandler()) end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		cs.Heal(c, c:GetLevel() * heal_multiplier)
	end)

	c:RegisterEffect(e1)

end