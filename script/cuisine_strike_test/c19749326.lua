---@version 5.3
---@module "edopro_typehint_helper"
---pizzastero pepperoni

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local hp_cost = 300
local heal_multiplier = 100

function s.initial_effect(c)

	CuisineStrike.InitializeDishEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CuisineStrike.CARD_PEPPERONYX, aux.FilterBoolFunctionEx(Card.IsRace, CuisineStrike.CLASS_BREAD))

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		if chk==0 then return Duel.GetLP(tp) > hp_cost end
		Duel.PayLPCost(tp, hp_cost)
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		local c = e:GetHandler()
		local g = Duel.SelectMatchingCard(tp, s.target_filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
		local tc = g:GetFirst()
		local reset_flag = RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END
		if tc then
			tc:AddPiercing(reset_flag, c)
			local heal_amount = c:GetLevel() * heal_multiplier
			if CuisineStrike.IsAbleToHeal(tc) then
				CuisineStrike.Heal(tc, heal_amount)
			end
		end
	end)
	
	c:RegisterEffect(e1)

end

function s.target_filter(c)
	return CuisineStrike.IsDishCard(c)
end