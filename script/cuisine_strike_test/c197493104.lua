---@version 5.3
---@module "edopro_typehint_helper"
---Card: Chef's blessing

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

--- @type ActionEffectOptions
s.action_effect_options = {
	type = "active",
	cost = function (e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE, tp, LOCATION_HAND, 0, c) > 0 end
		Duel.DiscardHand(tp, aux.TRUE, 1, 1, REASON_COST, c)
	end,
	target = function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.target_filter, tp, LOCATION_MZONE, 0, 1, nil) end
	end,
	operation = function (e, tp, eg, ep, ev, re, r, rp)
		local g = Duel.SelectMatchingCard(tp, s.target_filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
		local tc = g:GetFirst()
		if tc then
			-- add grade
			local e1 = Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			-- add power
			local e2 = e1:Clone()
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(100)
			tc:RegisterEffect(e2)
			-- add helth
			local e3 = e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			e3:SetValue(100)
			tc:RegisterEffect(e3)
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