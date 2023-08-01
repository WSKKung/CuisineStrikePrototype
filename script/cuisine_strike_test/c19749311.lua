-- fork trap

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local damage_amount = 500

function s.initial_effect(c)

	cs.initial_action_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)

	e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp)
		if Duel.GetCurrentChain(true) > 0 then return false end
		return Duel.GetAttacker():IsControler(1-tp)
	end)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk==0 then return c:IsDiscardable() end
		Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
	end)

	e1:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return true end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local at = Duel.GetAttacker()
		if at and at:IsRelateToBattle() then
			cs.Damage(at, damage_amount)
		end
	end)
	c:RegisterEffect(e1)

end