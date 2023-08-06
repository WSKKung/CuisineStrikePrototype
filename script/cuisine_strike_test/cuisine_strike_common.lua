---@version 5.3
---@module "edopro_typehint_helper"

CuisineStrike = {}
CS = CuisineStrike

-- common card types
CS.TYPE_INGREDIENT = TYPE_MONSTER + TYPE_EFFECT + TYPE_TUNER
CS.TYPE_DISH = TYPE_MONSTER + TYPE_EFFECT + TYPE_FUSION
CS.TYPE_ACTION = TYPE_TRAP

-- common card ids
CS.CARD_BUN_GARDNA = 19749301
CS.CARD_PIG_FAIRY = 19749302
CS.CARD_COWVERN = 19749303
CS.CARD_METEGGOR = 19749314
CS.CARD_TOMANTO = 19749321
CS.CARD_MEOWZZARELA = 19749322
CS.CARD_PEPPERONYX = 19749325

-- common classes (race aliases)
CS.CLASS_MEAT = RACE_BEAST
CS.CLASS_BREAD = RACE_ROCK
CS.CLASS_GRAIN = RACE_INSECT
CS.CLASS_EGG = RACE_REPTILE
CS.CLASS_VEGETABLE = RACE_PLANT
CS.CLASS_CHEESE = RACE_THUNDER

-- game rule constants
CuisineStrike.MAXIMUM_PLAYER_HP = 1500

--- 
--- @param c Card
--- @return integer 
function CuisineStrike.GetBonusGrade(c)
	return c:GetLevel() - c:GetOriginalLevel()
end

--- 
--- @param c Card
--- @return boolean 
function CuisineStrike.IsAbleToHeal(c)
	return c:GetDefense() < c:GetBaseDefense()
end

--- 
--- @param player Player
--- @return boolean 
function CuisineStrike.IsPlayerAbleToHeal(player)
	return Duel.GetLP(player) < CuisineStrike.MAXIMUM_PLAYER_HP
end


--- 
--- @param c Card
--- @return boolean 
function CS.IsDishCard(c)
	return (c:GetType() & CS.TYPE_DISH) == CS.TYPE_DISH
end

--- 
--- @param c Card
--- @return boolean 
function CS.IsIngredientCard(c)
	return (c:GetType() & CS.TYPE_INGREDIENT) == CS.TYPE_INGREDIENT
end

--- 
--- @param c Card
--- @return boolean 
function CS.IsActionCard(c)
	return (c:GetType() & CS.TYPE_ACTION) == CS.TYPE_ACTION
end

--- Heals a specified card Unit (c Card) with the given amount of Health (int amount)\
--- @param c Card
--- @param amount integer
--- @return integer The amount of Health healed
function CuisineStrike.Heal(c, amount)

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

--- Heals a player
--- @param player Player
--- @param amount integer
--- @return integer The amount of Health healed
function CuisineStrike.HealPlayer(player, amount)
	local max_hp = CuisineStrike.MAXIMUM_PLAYER_HP
	local cur_hp = Duel.GetLP(player)
	local healed_health = cur_hp + amount

	if healed_health > max_hp then
		amount = max_hp - cur_hp
	end

	if amount > 0 then
		Duel.Recover(player, amount, REASON_EFFECT)
	end

	return amount

end

--- Deals a damage to a specified card Unit (c Card) with the given amount (int amount)\
--- @param c Card
--- @param amount integer
--- @return integer The amount of damage dealt
function CuisineStrike.Damage(c, amount)

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

---Initialize common effects to a card appropiate to their card type value configured in the database as following\
---Ingredient card: Tuner Effect monster\
---Dish card: Fusion Effect monster (add Tuner type to signify that this card can be used as an Ingredient)\
---Action card: Trap
---@param c Card
function CS.InitCommonEffects(c)
	if CS.IsDishCard(c) then CS.InitializeDishEffects(c)
	elseif CS.IsIngredientCard(c) then CS.InitializeDishEffects(c)
	elseif CS.IsActionCard(c) then CS.InitializeActionEffects(c) end
end


--- Initialize all effects common to every ingredient cards to the given (c Card)
--- @param c Card
function CuisineStrike.InitializeIngredientEffects(c)

	-- disallow all summons
	c:EnableUnsummonable()

	-- place into spell/trap zone
	local set_backrow_eff=Effect.CreateEffect(c)
	set_backrow_eff:SetType(EFFECT_TYPE_IGNITION)
	set_backrow_eff:SetRange(LOCATION_HAND)

	set_backrow_eff:SetCost(function(e, tp, eg, ep, ev, re, r, rp, chk)
		local grade = e:GetHandler():GetLevel()
		---@type CardFilterFunction
		local cost_filter = function (c)
			return c:IsType(CS.TYPE_INGREDIENT) and c:GetLevel() >= (grade - 1)
		end
		if chk==0 then
			if grade > 1 then
				return Duel.IsExistingMatchingCard(cost_filter, tp, LOCATION_SZONE, 0, 1, nil)
			else
				return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
			end
		end
		if grade > 1 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
			local g = Duel.SelectMatchingCard(tp, cost_filter, tp, LOCATION_SZONE, 0, 1, 1, nil)
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


--- Initialize all effects common to every dish cards to the given (c Card)
--- @param c Card
function CuisineStrike.InitializeDishEffects(c)

	-- cook summon procedure
	c:EnableReviveLimit()
	--Fusion.AddProcMix(c, true, true, s.CARD_COWVERN, aux.FilterBoolFunctionEx(Card.IsRace, s.CLASS_BREAD))
	Fusion.AddContactProc(c,
		-- contact condition
		function (tp)
		return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost, tp, LOCATION_SZONE, 0, nil)
		end,
		-- contact operation
		function (mg, tp)
			local sumlvl = mg:GetSum(Card.GetLevel)
			-- mix ingredients grade and apply to summoned dish as new grade
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(sumlvl)
			c:RegisterEffect(e1)

			Duel.SendtoGrave(mg, REASON_COST + REASON_MATERIAL)
		end,
		-- contact limit
		function (e, c, tp, sumtype, pos, tgp, re)
			return (sumtype & SUMMON_TYPE_FUSION) == SUMMON_TYPE_FUSION and pos == POS_FACEUP_ATTACK
		end,
		nil, nil, nil, false
	)

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
		CuisineStrike.Damage(c, -damage)
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
	no_battle_damage_eff:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	no_battle_damage_eff:SetTargetRange(1, 0)
	no_battle_damage_eff:SetValue(function (e, tc, ...)
		if not tc then return true end
		for _, p_eff in ipairs{tc:GetCardEffect(EFFECT_PIERCE)} do
			local pierce_condition = p_eff:GetCondition()
			if not pierce_condition or pierce_condition(p_eff) then
				return false
			end
		end
		return true
	end)
	c:RegisterEffect(no_battle_damage_eff)

	-- place into spell/trap zone if its an ingredient
	if (CS.IsIngredientCard(c)) then
		local set_backrow_eff = Effect.CreateEffect(c)
		set_backrow_eff:SetType(EFFECT_TYPE_IGNITION)
		set_backrow_eff:SetRange(LOCATION_MZONE)

		set_backrow_eff:SetCost(function(e, tp, eg, ep, ev, re, r, rp, chk)
			if chk==0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 end
		end)

		set_backrow_eff:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
			local tc = e:GetHandler()
			if tc then
				Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
			end
		end)

		c:RegisterEffect(set_backrow_eff)
	end

end


---Initialize all effects common to every action cards to the given (c Card)\
---Action card activated effect should be created by using `CuisineStrike.CreateActionActivationEffect` function instead of manually create Effect instance.\
---@see CuisineStrike.CreateActionActivationEffect
---@param c Card
function CuisineStrike.InitializeActionEffects(c)

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

--- Create activation effect for action card (c Card)
--- @param c Card
--- @param params {cost: CostFunction, condition: ConditionFunction, target: TargetFunction, operation: OperationFunction}
--- @return Effect
function CuisineStrike.CreateActionActivationEffect(c, params)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	if params.condition then
		e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
			if Duel.GetCurrentChain(true) > 0 then return false end
			return params.condition(e, tp, eg, ep, ev, re, r, rp)
		end)
	else
		e1:SetCondition(function (e, tp, eg, ep, ev, re, r, rp, ...)
			return Duel.GetCurrentChain(true) == 0
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

