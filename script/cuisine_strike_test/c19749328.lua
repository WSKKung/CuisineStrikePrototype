---@version 5.3
---@module "edopro_typehint_helper"
---pizzastero quattro formaggi

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local hp_cost = 400
local target_damage_amount = 400
local burn_damage_amount = 400

function s.initial_effect(c)

	CuisineStrike.InitializeDishEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CuisineStrike.CARD_MEOWZZARELA, aux.FilterBoolFunctionEx(Card.IsRace, CuisineStrike.CLASS_BREAD))

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	
	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		if chk==0 then return Duel.GetLP(tp) > hp_cost end
		Duel.PayLPCost(tp, hp_cost)
	end)

	e1:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		if chk==0 then return Duel.IsExistingMatchingCard(s.target_filter, tp, 0, LOCATION_MZONE, 1, nil) end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		local c = e:GetHandler()
		local grade = c:GetLevel()
		local g = Duel.SelectMatchingCard(tp, s.target_filter, tp, 0, LOCATION_MZONE, 1, 1, nil)
		local tc = g:GetFirst()
		if tc then
			if CuisineStrike.Damage(tc, target_damage_amount) <= 0 then return end
			if grade >= 4 and Duel.SelectEffectYesNo(tp, c, aux.Stringid(id, 0)) then
				Duel.Damage(1-tp, burn_damage_amount, REASON_EFFECT)
			end
		end
	end)

	c:RegisterEffect(e1)

end

function s.target_filter(c)
	return CuisineStrike.IsDishCard(c)
end