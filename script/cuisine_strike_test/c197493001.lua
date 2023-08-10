---@version 5.3
---@module "edopro_typehint_helper"
---Card: Rib-Eyes Steak Dragon

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.aoe_damage_amount = 200

function s.initial_effect(c)
	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMix(c, true, true, CS.CARD_COWVERN, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MEAT))

	-- damage all
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
	if #g > 0 then
		g:ForEach(function (tc)
			CS.Damage(tc, s.aoe_damage_amount)
		end)
	end
end