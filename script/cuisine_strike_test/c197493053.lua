---@version 5.3
---@module "edopro_typehint_helper"
---Card: Barleyfin

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.str_gain_amount = 100

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- damage reduction
	local def_gain_e = Effect.CreateEffect(c)
	def_gain_e:SetType(EFFECT_TYPE_IGNITION)
	def_gain_e:SetCategory(CATEGORY_ATKCHANGE)
	def_gain_e:SetRange(LOCATION_SZONE)
	def_gain_e:SetTarget(s.target)
	def_gain_e:SetOperation(s.operation)
	def_gain_e:SetCountLimit(1)
	c:RegisterEffect(def_gain_e)
end

--- @type CardFilterFunction
function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
	if tc then
		tc:UpdateAttack(s.str_gain_amount, RESET_EVENT + RESETS_STANDARD_DISABLE, e:GetHandler())
	end
end