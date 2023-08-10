---@version 5.3
---@module "edopro_typehint_helper"
---Card: Meteggor

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_amount = 300

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- aoe damage
	local aoe_dmg_e = Effect.CreateEffect(c)
	aoe_dmg_e:SetCategory(CATEGORY_DEFCHANGE)
	aoe_dmg_e:SetType(EFFECT_TYPE_IGNITION)
	aoe_dmg_e:SetRange(LOCATION_SZONE)
	aoe_dmg_e:SetCountLimit(1)
	aoe_dmg_e:SetCost(s.cost)
	aoe_dmg_e:SetTarget(s.target)
	aoe_dmg_e:SetOperation(s.operation)
	c:RegisterEffect(aoe_dmg_e)
end

function s.filter(c)
	return CS.IsDishCard(c)
end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk, ...)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c, REASON_COST)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
	tg:ForEach(function (tc)
		CS.Damage(tc, s.damage_amount, REASON_EFFECT, e:GetHandler(), tp)
	end)
end