---@version 5.3
---@module "edopro_typehint_helper"
---Card: Bacon Squire

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.stat_boost_min_grade = 2
s.stat_boost_amount = 100

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, s.material_filter, 1, 2)

	local str_boost_e = Effect.CreateEffect(c)
	str_boost_e:SetType(EFFECT_TYPE_FIELD)
	str_boost_e:SetCode(EFFECT_UPDATE_ATTACK)
	str_boost_e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	str_boost_e:SetRange(LOCATION_SZONE)
	str_boost_e:SetTargetRange(LOCATION_MZONE, 0)
	str_boost_e:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
		return CS.GetGrade(e:GetHandler()) >= s.stat_boost_min_grade
	end)
	str_boost_e:SetValue(s.stat_boost_amount)
	c:RegisterEffect(str_boost_e)

	local def_boost_e = str_boost_e:Clone()
	def_boost_e:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(def_boost_e)

end

---
---@param c Card
---@returns boolean
function s.material_filter(c)
	return c:IsRace(CS.CLASS_MEAT)
end