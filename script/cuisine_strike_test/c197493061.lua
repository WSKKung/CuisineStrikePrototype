---@version 5.3
---@module "edopro_typehint_helper"
---Card: Pig Fairy

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.heal_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- heal hp
	local heal_e = Effect.CreateEffect(c)
	heal_e:SetType(EFFECT_TYPE_IGNITION)
	heal_e:SetRange(LOCATION_SZONE)
	heal_e:SetCountLimit(1)

	heal_e:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
		Duel.DiscardDeck(tp, 1, REASON_COST)
	end)

	heal_e:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return CS.IsPlayerAbleToHeal(tp) end
	end)

	heal_e:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		CS.HealPlayer(tp, s.heal_amount)
	end)

	c:RegisterEffect(heal_e)
end
