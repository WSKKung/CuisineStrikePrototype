-- steak startare

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local damage_multiplier = 100

function s.initial_effect(c)

	cs.InitializeDishEffects(c)

	-- cook summon procedure
	Fusion.AddProcMix(c, true, true, cs.CARD_METEGGOR, aux.FilterBoolFunctionEx(Card.IsRace, cs.CLASS_MEAT))

	-- damage all
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	end)

	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, 0, LOCATION_MZONE, 1, 1, nil)
		if #g > 0 then
			local tc = g:GetFirst()
			cs.Damage(tc, c:GetLevel() * damage_multiplier)
			
			local no_attack_e = Effect.CreateEffect(c)
			no_attack_e:SetType(EFFECT_TYPE_SINGLE)
			no_attack_e:SetCode(EFFECT_CANNOT_ATTACK)
			no_attack_e:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			c:RegisterEffect(no_attack_e)
		end
	end)

	c:RegisterEffect(e1)

end

function s.filter(c)
	return c:IsMonster() and c:IsFaceup()
end