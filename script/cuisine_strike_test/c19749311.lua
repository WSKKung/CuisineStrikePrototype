---@version 5.3
---@module "edopro_typehint_helper"
---fork trap

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local damage_amount = 500

function s.initial_effect(c)

	CuisineStrike.InitializeActionEffects(c)

	local e1 = CuisineStrike.CreateActionActivationEffect(c, {
		condition = function (e, tp, eg, ep, ev, re, r, rp)
			return Duel.GetAttacker():IsControler(1-tp)
		end,
		operation = function (e, tp, eg, ep, ev, re, r, rp)
			local at = Duel.GetAttacker()
			if at and at:IsRelateToBattle() then
				CuisineStrike.Damage(at, damage_amount)
			end
		end
	})
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e1)
	
end