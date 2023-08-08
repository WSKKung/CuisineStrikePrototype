---@version 5.3
---@module "edopro_typehint_helper"
---Card: Fork trap

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_amount = 500

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
		if Duel.GetCurrentChain(true) > 0 then return false end
		return Duel.GetAttacker():IsControler(1-tp)
	end)
	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		local c = e:GetHandler()
		if chk==0 then return c:IsDiscardable() end
		Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
	end)
	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		local at = Duel.GetAttacker()
		if at and at:IsRelateToBattle() then
			CuisineStrike.Damage(at, s.damage_amount)
		end
	end)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e1)

end