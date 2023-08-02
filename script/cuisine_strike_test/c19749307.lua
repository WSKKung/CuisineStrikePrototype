-- rib-eyes steak dragon

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local aoe_damage_amount = 200

function s.initial_effect(c)

	cs.InitializeDishEffects(c)

	-- cook summon procedure
	Fusion.AddProcMixN(c, true, true, cs.CARD_COWVERN, 2)

	-- damage all
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 end
		Duel.DiscardHand(tp, aux.TRUE, 1, 1, REASON_COST, nil)
	end)

	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	end)

	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
		if #g > 0 then
			g:ForEach(function (tc)
				cs.Damage(tc, aoe_damage_amount)
			end)
		end
	end)

	c:RegisterEffect(e1)

end

function s.filter(c)
	return c:IsMonster() and c:IsFaceup()
end