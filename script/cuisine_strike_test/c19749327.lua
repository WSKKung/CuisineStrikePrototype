---@version 5.3
---@module "edopro_typehint_helper"
---pizzastero ultimo margherita

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local hp_cost_multiplier = 100

function s.initial_effect(c)

	CuisineStrike.InitializeDishEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CuisineStrike.CARD_TOMANTO, aux.FilterBoolFunctionEx(Card.IsRace, CuisineStrike.CLASS_CHEESE), aux.FilterBoolFunctionEx(Card.IsRace, CuisineStrike.CLASS_BREAD))

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	
	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		local grade = e:GetHandler():GetLevel()
		local hp_cost = hp_cost_multiplier * grade
		if chk==0 then return Duel.GetLP(tp) > hp_cost end
		Duel.PayLPCost(tp, hp_cost)
		e:SetLabel(hp_cost)
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		local c = e:GetHandler()
		local hp_cost = e:GetLabel()
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END)
		e1:SetValue(hp_cost)
		c:RegisterEffect(e1)
	end)

	c:RegisterEffect(e1)
end