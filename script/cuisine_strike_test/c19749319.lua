-- the sun's upside

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local min_power_destroy_target = 400

function s.initial_effect(c)

	cs.InitializeDishEffects(c)

	-- cook summon procedure
	Fusion.AddProcMixN(c, true, true, cs.CARD_METEGGOR, 2)

	-- destroy
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 2) end
		Duel.DiscardDeck(tp, 2, REASON_COST)
	end)

	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	end)

	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, 0, LOCATION_MZONE, 1, 1, nil)
		if #g > 0 then
			Duel.Destroy(g, REASON_EFFECT)
		end
	end)

	c:RegisterEffect(e1)

end

function s.filter(c)
	return cs.IsDishCard(c) and c:IsFaceup() and c:GetAttack() <= min_power_destroy_target
end