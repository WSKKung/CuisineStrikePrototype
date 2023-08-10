---@version 5.3
---@module "edopro_typehint_helper"
---Card: Dragon Wheellington

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.extra_def_multiplier = 100

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 200)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_BUN_GARDNA, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT))

	-- gain extra def
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
		if chk==0 then return true end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local extra_def_e = Effect.CreateEffect(c)
		extra_def_e:SetType(EFFECT_TYPE_SINGLE)
		extra_def_e:SetCode(EFFECT_UPDATE_DEFENSE)
		extra_def_e:SetRange(LOCATION_MZONE)
		extra_def_e:SetValue(function (e)
			return CS.GetGrade(e:GetHandler()) * s.extra_def_multiplier
		end)
		extra_def_e:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
		c:RegisterEffect(extra_def_e)
	end)

	c:RegisterEffect(e1)

end