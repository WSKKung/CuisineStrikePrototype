---@version 5.3
---@module "edopro_typehint_helper"
---meowzzarella

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local heal_amount = 200

function s.initial_effect(c)
	CuisineStrike.InitializeIngredientEffects(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp)
		return Duel.GetAttacker():IsControler(1-tp) and CuisineStrike.IsPlayerAbleToHeal(tp)
	end)
	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp, ...)
		CuisineStrike.HealPlayer(tp, heal_amount)
	end)
	c:RegisterEffect(e1)

end