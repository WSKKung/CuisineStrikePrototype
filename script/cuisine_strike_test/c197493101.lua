---@version 5.3
---@module "edopro_typehint_helper"
---Card: Fork trap

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_amount = 500

--- @type ActionEffectOptions
s.action_effect_options = {
	type = "trigger",
	code = EVENT_ATTACK_ANNOUNCE,
	condition = function (e, tp, eg, ep, ev, re, r, rp, ...)
		return Duel.GetAttacker():IsControler(1-tp)
	end,
	operation = function (e, tp, eg, ep, ev, re, r, rp, ...)
		local at = Duel.GetAttacker()
		if at and at:IsRelateToBattle() then
			CS.Damage(at, s.damage_amount)
		end
	end
}

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	local e1 = CS.CreateActionEffect(c, s.action_effect_options)
	c:RegisterEffect(e1)

end
