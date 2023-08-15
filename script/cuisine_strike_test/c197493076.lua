---@version 5.3
---@module "edopro_typehint_helper"
---Card: Tomatoad

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)
	CS.InitCommonEffects(c)

	-- heal
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

end

--- @type CostFunction
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) end
	local tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
	if CS.IsIngredientCard(tc) then
		e:SetLabel(CS.GetGrade(tc))
	else
		e:SetLabel(0)
	end
	Duel.DiscardDeck(tp, 1, REASON_COST)
end

--- @type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return CS.IsPlayerAbleToHeal(tp) end
end

--- @type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local cost_grade = e:GetLabel()
	if cost_grade > 0 then
		CS.HealPlayer(tp, cost_grade * 100)
	end
end
