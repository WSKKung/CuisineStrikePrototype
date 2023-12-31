---@version 5.3
---@module "edopro_typehint_helper"
---Card: Eggbot

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

s.damage_amount = 300

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- damage
	local dmg_e = Effect.CreateEffect(c)
	dmg_e:SetCategory(CATEGORY_DEFCHANGE)
	dmg_e:SetType(EFFECT_TYPE_IGNITION)
	dmg_e:SetRange(LOCATION_SZONE)
	dmg_e:SetCountLimit(1)
	dmg_e:SetCost(s.cost)
	dmg_e:SetTarget(s.target)
	dmg_e:SetOperation(s.operation)
	c:RegisterEffect(dmg_e)
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
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil):GetFirst()
	if tc then
		CS.Damage(tc, s.damage_amount, REASON_EFFECT, e:GetHandler(), tp)
	end
end