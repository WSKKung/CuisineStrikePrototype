cs = {}

-- common card ids
cs.CARD_BUN_GARDNA = 19749301
cs.CARD_PIG_FAIRY = 19749302
cs.CARD_COWVERN = 19749303
cs.CARD_METEGGOR = 19749314

-- common classes (race aliases)
cs.CLASS_MEAT = RACE_BEAST
cs.CLASS_BREAD = RACE_ROCK
cs.CLASS_EGG = RACE_REPTILE

--- 
--- @param c Card
--- @param amount integer
--- @return integer 
function cs.GetBonusGrade(c)
	return c:GetLevel() - c:GetOriginalLevel()
end

--- 
--- @param c Card
--- @param amount integer
--- @return boolean 
function cs.IsAbleToHeal(c)
	return c:GetDefense() < c:GetBaseDefense()
end


--- 
--- @param c Card
--- @return boolean 
function cs.IsDishCard(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION)
end

--- 
--- @param c Card
--- @return boolean 
function cs.IsIngredientCard(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EXTRA)
end

--- 
--- @param c Card
--- @return boolean 
function cs.IsActionCard(c)
	return c:IsType(TYPE_TRAP)
end

--- 
--- @param c Card
--- @param amount integer
--- @return integer 
function cs.Heal(c, amount)

	local max_health = c:GetBaseDefense()
	local cur_health = c:GetDefense()
	local healed_health = cur_health + amount
	
	if healed_health > max_health then
		amount = max_health - cur_health
	end

	if amount > 0 then
		local e1 = Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DEFCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
		e1:SetValue(amount)
		c:RegisterEffect(e1)
	end

	return amount
end

--- 
--- @param c Card
--- @param amount integer
--- @return integer 
function cs.Damage(c, amount)

	local cur_health = c:GetDefense()

	if amount > cur_health then
		amount = cur_health
	end

	if amount > 0 then
		local e1 = Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DEFCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
		e1:SetValue(-amount)
		c:RegisterEffect(e1)
	end

	return amount
end

--- 
--- @param c Card
--- @param grade integer
--- @param props {grade: integer}
function cs.InitializeIngredientEffects(c, props)

	local grade = 0
	if props["grade"] ~= nil then grade = props["grade"] end

	-- disallow all summons
	c:EnableUnsummonable()

	-- place into spell/trap zone
	local set_backrow_eff=Effect.CreateEffect(c)
	set_backrow_eff:SetType(EFFECT_TYPE_IGNITION)
	set_backrow_eff:SetRange(LOCATION_HAND)

	local cost_filter = function(c)
		return c:IsType(TYPE_MONSTER) and c:GetLevel() >= (grade - 1)
	end
	
	local cost_check = function(e, tp)
		if grade > 1 then
			return Duel.IsExistingMatchingCard(cost_filter, tp, LOCATION_SZONE, 0, 1, nil)
		else
			return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		end
	end

	set_backrow_eff:SetCost(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return cost_check(e, tp) end
		if grade > 1 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
			local g = Duel.SelectMatchingCard(tp, cost_filter, tp, LOCATION_SZONE, 0, 1, 1, nil):GetFirst()
			Duel.SendtoGrave(g, REASON_COST)
		end
	end)

	set_backrow_eff:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local tc = e:GetHandler()
		if tc then
			Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
			
		end
	end)

	c:RegisterEffect(set_backrow_eff)
end


--- 
--- @param c Card
function cs.InitializeDishEffects(c)

	local function special_summon_limit(e, se, sp, st)
		return (st & SUMMON_TYPE_FUSION) == SUMMON_TYPE_FUSION
	end
	
	local function cook_summon_condition(tp)
		return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost, tp, LOCATION_SZONE, 0, nil)
	end
	
	--- @param g Group
	--- @param tp integer
	--- @param c Card
	local function cook_summon_operation(g, tp, c)

		local sumlvl = g:GetSum(Card.GetLevel)

		-- mix ingredients grade and apply to summoned dish as new grade
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(sumlvl)
		c:RegisterEffect(e1)

		Duel.SendtoGrave(g, REASON_COST + REASON_MATERIAL)

	end
	-- cook summon procedure
	c:EnableReviveLimit()
	--Fusion.AddProcMix(c, true, true, s.CARD_COWVERN, aux.FilterBoolFunctionEx(Card.IsRace, s.CLASS_BREAD))
	Fusion.AddContactProc(c, cook_summon_condition, cook_summon_operation, special_summon_limit, nil, nil, nil, false)

	-- health simulation effs

	-- lower def after damage calculation
	local hp_sim_eff=Effect.CreateEffect(c)
	hp_sim_eff:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	hp_sim_eff:SetCode(EVENT_BATTLED)
	hp_sim_eff:SetRange(LOCATION_MZONE)
	
	hp_sim_eff:SetCondition(function (e, tp, eg, ep, ev, re, r, rp)
		local bc = e:GetHandler():GetBattleTarget()
		return bc and bc:GetAttack() > 0
	end)

	hp_sim_eff:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then return true end
		-- calculate received damage before applying to avoid battle target whose atk are modified leaves the field before applying damage to this card
		local c = e:GetHandler()
		local tc = c:GetBattleTarget()
		local damage = -tc:GetAttack()
		e:SetLabel(damage)
	end)

	hp_sim_eff:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local damage = e:GetLabel()
		cs.Damage(c, -damage)
	end)

	c:RegisterEffect(hp_sim_eff)

	--destroy if hp reaches zero
	local destroy_when_no_hp_eff = Effect.CreateEffect(c)
	destroy_when_no_hp_eff:SetType(EFFECT_TYPE_SINGLE)
	destroy_when_no_hp_eff:SetRange(LOCATION_MZONE)
	destroy_when_no_hp_eff:SetCode(EFFECT_SELF_DESTROY)
	destroy_when_no_hp_eff:SetCondition(function (e, tp, eg, ep, ev, re, r, rp)
		return e:GetHandler():GetDefense() <= 0
	end)
	c:RegisterEffect(destroy_when_no_hp_eff)

	-- prevent destruction by battle
	-- will use hp system to destroy in battle instead
	local indestructible_in_battle_eff = Effect.CreateEffect(c)
	indestructible_in_battle_eff:SetType(EFFECT_TYPE_SINGLE)
	indestructible_in_battle_eff:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	indestructible_in_battle_eff:SetValue(true)
	c:RegisterEffect(indestructible_in_battle_eff)
	
	--prevent battle damage
	local no_battle_damage_eff=Effect.CreateEffect(c)
	no_battle_damage_eff:SetType(EFFECT_TYPE_SINGLE)
	no_battle_damage_eff:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	no_battle_damage_eff:SetValue(1)
	c:RegisterEffect(no_battle_damage_eff)
end


--- 
--- @param c Card
function cs.InitializeActionEffects(c)

	local cannot_set_eff=Effect.CreateEffect(c)
	cannot_set_eff:SetType(EFFECT_TYPE_FIELD)
	cannot_set_eff:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	cannot_set_eff:SetCode(EFFECT_CANNOT_SSET)
	cannot_set_eff:SetRange(LOCATION_HAND)
	cannot_set_eff:SetTargetRange(1,0)
	cannot_set_eff:SetTarget(function (e, c)
		return c == e:GetHandler()
	end)
	c:RegisterEffect(cannot_set_eff)

	local use_from_hand_eff = Effect.CreateEffect(c)
	use_from_hand_eff:SetType(EFFECT_TYPE_SINGLE)
	use_from_hand_eff:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(use_from_hand_eff)

end

--- 
--- @param c Card
--- @return Effect
function cs.CreateShieldEffect(c)
	--- @type Effect
	local e1 = Effect.CreateEffect(c)
	--e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp)
		return true --ep == 1-tp and re:IsHasCategory(CATEGORY_DEFCHANGE) and re:GetLabel() < 0
	end)
	e1:SetTarget(function (e, tp, eg, ep, ev, re, r, rp, chk)
		if chk==0 then
			return re:IsHasCategory(CATEGORY_DEFCHANGE) and re:GetLabel() < 0
		end
	end)
	e1:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local original_damage = re:GetLabel()
		local new_damage = original_damage + 100
		re:SetLabel(new_damage)
	end)
	return e1
end

--- 
--- @param c Card
--- @param params {cost: function, condition: function, target: function, operation: function}
--- @return Effect
function cs.CreateActionActivationEffect(c, params)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)

	if params.condition then
		e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
			if Duel.GetCurrentChain(true) > 0 then return false end
			return params.condition(e, tp, eg, ep, ev, re, r, rp)
		end)
	else
		e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
			return Duel.GetCurrentChain(true) > 0
		end)
	end

	if params.cost then
		e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
			local c = e:GetHandler()
			if chk==0 then return c:IsDiscardable() and params.cost(e, tp, eg, ep, ev, re, r, rp, chk, ...) end
			Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
			params.cost(e, tp, eg, ep, ev, re, r, rp, chk, ...)
		end)
	else
		e1:SetCost(function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
			local c = e:GetHandler()
			if chk==0 then return c:IsDiscardable() end
			Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
		end)
	end

	if params.target then
		e1:SetTarget(params.target)
	end

	if params.operation then
		e1:SetOperation(params.operation)
	end

	return e1

end