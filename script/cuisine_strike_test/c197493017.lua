---@version 5.3
---@module "edopro_typehint_helper"
---Card: Mrs. Spaghettinora

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 100, 100)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_GRAIN), 1, 2)

	-- heal
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)

end

---@type CardFilterFunction
function s.filter(c)
	return CS.IsDishCard(c) and (c:GetAttack() > 0 or c:GetDefense() > 0)
end

---@type TargetFunction
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, c) and CS.IsPlayerAbleToHeal(tp) end
end

---@type OperationFunction
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, c):GetFirst()
	if not tc then return end

	local heal_value = 0
	if tc:GetAttack() == 0 then heal_value = tc:GetDefense()
	elseif tc:GetDefense() == 0 then heal_value = tc:GetAttack()
	else
		local choice = Duel.SelectOption(tp, true, aux.Stringid(id, 1), aux.Stringid(id, 2))
		-- select atk
		if choice == 0 then
			heal_value = tc:GetAttack()
		-- select def
		else
			heal_value = tc:GetDefense()
		end
	end

	if heal_value > 0 then
		CS.HealPlayer(tp, heal_value)
	end
end