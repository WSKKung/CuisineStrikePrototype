---@version 5.3
---@module "edopro_typehint_helper"
---Card: Appetizing Aura

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

--- @type ActionEffectOptions
s.action_effect_options = {
	type = "active",
	target = function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.target_filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) and CS.IsPlayerAbleToHeal(tp) end
	end,
	operation = function (e, tp, eg, ep, ev, re, r, rp)
		local g = Duel.SelectMatchingCard(tp, s.target_filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
		local tc = g:GetFirst()
		if tc then
			CS.HealPlayer(tp, tc:GetAttack())
		end
	end
}

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	local e1 = CS.CreateActionEffect(c, s.action_effect_options)
	c:RegisterEffect(e1)

end

function s.target_filter(c)
	return CS.IsDishCard(c)
end