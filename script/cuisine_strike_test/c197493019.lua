---@version 5.3
---@module "edopro_typehint_helper"
---Card: Meowzzarela

local s, id = GetID()

Duel.LoadScript("cuisine_strike_common.lua")

function s.initial_effect(c)

	CS.InitCommonEffects(c)
	CS.InitBonusStatEffects(c, 0, 200)

	-- cook summon procedures
	Fusion.AddProcMixRep(c, true, true, aux.FilterBoolFunctionEx(Card.IsRace, CS.CLASS_MILK), 1, 2)

	local debuff_e = Effect.CreateEffect(c)
	debuff_e:SetType(EFFECT_TYPE_FIELD)
	debuff_e:SetCode(EFFECT_UPDATE_ATTACK)
	debuff_e:SetRange(LOCATION_MZONE)
	debuff_e:SetTargetRange(0, LOCATION_MZONE)
	debuff_e:SetTarget(aux.TRUE)
	debuff_e:SetValue(s.value)
	c:RegisterEffect(debuff_e)

	local ingredient_debuff_e = debuff_e:Clone()
	ingredient_debuff_e:SetRange(LOCATION_SZONE)
	c:RegisterEffect(ingredient_debuff_e)

end

---comment
---@param e Effect
---@param tc Card
---@return integer
function s.value(e, tc)
	return -CS.GetGrade(e:GetHandler()) * 100
end