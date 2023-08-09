---@version 5.3
---@module "edopro_typehint_helper"
---Card: Wheatsel

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.def_boost_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT), aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_EGG))

	local def_boost_e = Effect.CreateEffect(c)
	def_boost_e:SetType(EFFECT_TYPE_FIELD)
	def_boost_e:SetCode(EFFECT_UPDATE_DEFENSE)
	def_boost_e:SetRange(LOCATION_SZONE)
	def_boost_e:SetTargetRange(LOCATION_MZONE, 0)
	def_boost_e:SetTarget(aux.TRUE)
	def_boost_e:SetValue(s.def_boost_amount)
	c:RegisterEffect(def_boost_e)
end
