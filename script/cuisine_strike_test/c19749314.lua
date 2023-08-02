-- meteggor

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

local damage_amount = 300

function s.initial_effect(c)
	cs.InitializeIngredientEffects(c, {grade=2})

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)

	e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk==0 then
			return c:IsAbleToGraveAsCost()
		end
		Duel.SendtoGrave(c, REASON_COST)
	end)

	e1:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		local tc = eg:GetFirst()
		if chk==0 then return ep == 1-tp and s.filter(tc) and tc:IsLocation(LOCATION_MZONE) end
	end)

	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local tg = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
		if #tg > 0 then
			tg:ForEach(function (tc)
				cs.Damage(tc, damage_amount)
			end)
		end
	end)

	c:RegisterEffect(e1)
end

function s.filter(c)
	return cs.IsDishCard(c) and c:IsFaceup()
end