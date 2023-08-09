---@version 5.3
---@module "edopro_typehint_helper"

CuisineStrike = {}
CS = CuisineStrike

-- common setcode
CS.SERIES_CUISINE_STRIKE = 0x6934

-- common card types
CS.TYPE_INGREDIENT = TYPE_MONSTER + TYPE_EFFECT + TYPE_TUNER
CS.TYPE_DISH = TYPE_MONSTER + TYPE_EFFECT + TYPE_FUSION
CS.TYPE_ACTION = TYPE_TRAP

-- common card ids
CS.CARD_BUN_GARDNA = 197493006
CS.CARD_COWVERN = 197493062

CS.CARD_PIG_FAIRY = 19749302
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

-- common hint message
CS.HINTMSG_COOK_SUMMON_NOT_ENOUGH_TOTAL_GRADE = 3941
CS.HINTMSG_SET_INGREDIENT_DISH_FROM_FIELD = 3942

-- common events
CS.EVENT_DISH_TAKEN_DAMAGE = EVENT_CUSTOM + 19749301

-- common effect codes
CS.EFFECT_UPDATE_ARMOR_VALUE = EVENT_CUSTOM + 19749301

-- game rule constants
CS.MAXIMUM_PLAYER_HP = 1500

--- 
--- @param c Card
--- @return integer 
function CS.GetGrade(c)
	return c:GetLevel()
end

--- 
--- @param c Card
--- @return integer 
function CS.GetBaseGrade(c)
	return c:GetOriginalLevel()
end

--- 
--- @param c Card
--- @return integer 
function CS.GetBonusGrade(c)
	return CS.GetGrade(c) - CS.GetBaseGrade(c)
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
--- @param reason Reason? default to 0
--- @param reason_card Card? default to the card taken damage itself
--- @param reason_player Player? default to owner of reason_card
--- @return integer The amount of damage dealt
function CuisineStrike.Damage(c, amount, reason, reason_card, reason_player)

	reason = reason or 0
	reason_card = reason_card or c
	reason_player = reason_player or c:GetOwner()

	local cur_health = c:GetDefense()

	-- apply armor effect of the target card
	for _, armored_eff in ipairs{c:GetCardEffect(CS.EFFECT_UPDATE_ARMOR_VALUE)} do
		local armor_condition = armored_eff:GetCondition()
		if not armor_condition or armor_condition(armored_eff, c:GetOwner(), Group.FromCards(reason_card), c:GetOwner(), amount, nil, reason, reason_player) then
			local armor_val = armored_eff:GetValue() or 0
			if type(armor_val) == "function" then
				amount = amount - armor_val(armored_eff)
			else
				amount = amount - armor_val
			end
		end
	end

	if amount > cur_health then amount = cur_health end

	if amount > 0 then
		local e1 = Effect.CreateEffect(reason_card)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetValue(amount)
		e1:SetCategory(CATEGORY_DEFCHANGE)
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
	elseif CS.IsIngredientCard(c) then CS.InitializeIngredientEffects(c)
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

	-- must be properly summoned first
	c:EnableReviveLimit()

	--[[
	Fusion.AddContactProc(c,
		function (tp)
			return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost, tp, LOCATION_SZONE, 0, nil)
		end,
		---contact operation
		---@param mg Group
		---@param tp Player
		function (mg, tp)
			-- get sum level before sending them to gy to avoid level reset when material leave the field
			local sumlvl = mg:GetSum(Card.GetLevel)
			Duel.SendtoGrave(mg, REASON_COST + REASON_MATERIAL)
			-- mix ingredients grade and apply to summoned dish as new grade
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(sumlvl)
			c:RegisterEffect(e1)
		end,
		nil,
		nil,
		SUMMON_TYPE_FUSION,
		nil, false
	)]]
	local cook_proc_group = function (tp)
		return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost, tp, LOCATION_SZONE, 0, nil)
	end

	-- cook summon procedure
	local cook_proc_eff = Effect.CreateEffect(c)
	cook_proc_eff:SetType(EFFECT_TYPE_FIELD)
	cook_proc_eff:SetCode(EFFECT_SPSUMMON_PROC)
	cook_proc_eff:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	cook_proc_eff:SetRange(LOCATION_EXTRA)
	cook_proc_eff:SetCondition(Fusion.ContactCon(cook_proc_group, nil))
	cook_proc_eff:SetTarget(
		-- modified version of Fusion.ContactTg to includes combined Level restriction
		function(e, tp, eg, ep, ev, re, r, rp)
			local m = cook_proc_group(tp)
			local chkf = tp | FUSPROC_CONTACTFUS
			local sg = Duel.SelectFusionMaterial(tp, e:GetHandler(), m, nil, chkf)
			if #sg>0 then
				-- check cook summon restriction
				-- TODO: Add restriction check to condition check phase, Th
				if sg:GetSum(Card.GetLevel) < e:GetHandler():GetOriginalLevel() then
					Duel.Hint(HINT_MESSAGE, tp, CS.HINTMSG_COOK_SUMMON_NOT_ENOUGH_TOTAL_GRADE)
					return false
				end
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else return false end
		end
	)
	cook_proc_eff:SetOperation(Fusion.ContactOp(
		---contact operation
		---@param mg Group
		---@param tp Player
		function (mg, tp)
			-- get sum level before sending them to gy to avoid level reset when material leave the field
			local sumlvl = mg:GetSum(Card.GetLevel)
			Duel.SendtoGrave(mg, REASON_COST + REASON_MATERIAL)
			-- mix ingredients grade and apply to summoned dish as new grade
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(sumlvl)
			c:RegisterEffect(e1)
		end)
	)
	cook_proc_eff:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(cook_proc_eff)

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
		local damage = tc:GetAttack()
		e:SetLabel(damage)
		
	end)

	hp_sim_eff:SetOperation(function (e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local damage = e:GetLabel()
		CS.Damage(c, damage, REASON_BATTLE, c:GetBattleTarget(), 1-tp)
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
		set_backrow_eff:SetDescription(CS.HINTMSG_SET_INGREDIENT_DISH_FROM_FIELD)
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

---Add bonus stat effects to a dish, scaling by their bonus grade
---@param c Card
---@param bonus_str integer
---@param bonus_def integer
function CS.InitBonusStatEffects(c, bonus_str, bonus_def)
	if not CS.IsDishCard(c) then return end
	if bonus_str > 0 then
		local bonus_str_eff = Effect.CreateEffect(c)
		bonus_str_eff:SetType(EFFECT_TYPE_SINGLE)
		bonus_str_eff:SetRange(LOCATION_MZONE)
		bonus_str_eff:SetCategory(CATEGORY_ATKCHANGE)
		bonus_str_eff:SetCode(EFFECT_UPDATE_ATTACK)
		bonus_str_eff:SetValue(function (e)
			return CS.GetBonusGrade(c) * bonus_str
		end)
		c:RegisterEffect(bonus_str_eff)
	end
	if bonus_def > 0 then
		local bonus_def_eff = Effect.CreateEffect(c)
		bonus_def_eff:SetType(EFFECT_TYPE_SINGLE)
		bonus_def_eff:SetRange(LOCATION_MZONE)
		bonus_def_eff:SetCategory(CATEGORY_DEFCHANGE)
		bonus_def_eff:SetCode(EFFECT_UPDATE_DEFENSE)
		bonus_def_eff:SetValue(function (e)
			return CS.GetBonusGrade(c) * bonus_def
		end)
		c:RegisterEffect(bonus_def_eff)
	end
end

--- @alias ActionEffectType "trigger" | "active"

--- Create activation effect for action card (c Card)
--- @param c Card
--- @param params {type: ActionEffectType, code: EffectCode?, properties: integer?, cost: CostFunction?, condition: ConditionFunction?, target: TargetFunction?, operation: OperationFunction?}
--- @return Effect
function CS.CreateActionEffect(c, params)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)

	if params.type == "active" then
		e1:SetCondition(CS.ActionCardActiveConditionFunction(params.condition))
	elseif params.condition then
		e1:SetCondition(params.condition)
	end

	e1:SetCost(CS.ActionCardCostFunction(params.cost))

	if params.target then e1:SetTarget(params.target) end
	if params.operation then e1:SetOperation(params.operation) end

	if params.properties then
		e1:SetProperty(EFFECT_FLAG_DELAY + params.properties)
	else
		e1:SetProperty(EFFECT_FLAG_DELAY)
	end

	if params.type == "active" then
		e1:SetCode(EVENT_FREE_CHAIN)
	elseif params.code ~= nil then
		e1:SetCode(params.code)
	end

	return e1
end

--- Create activation effect for action card (c Card)
--- @deprecated
--- @param c Card
--- @param params {type: ActionEffectType, cost: CostFunction?, condition: ConditionFunction?, target: TargetFunction?, operation: OperationFunction?}
--- @return Effect
function CuisineStrike.CreateActionActivationEffect(c, params)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)

	if params.type == "active" then
		e1:SetCondition(CS.ActionCardActiveConditionFunction(params.condition))
	else
		if params.condition then
			e1:SetCondition(params.condition)
		end
	end

	e1:SetCost(CS.ActionCardCostFunction(params.cost))

	if params.target then
		e1:SetTarget(params.target)
	end

	if params.operation then
		e1:SetOperation(params.operation)
	end

	return e1

end

--- Create activation cost function for action card (c Card)
--- @param additional_cost function?
--- @return function
function CS.ActionCardCostFunction(additional_cost)
	return function (e, tp, eg, ep, ev, re, r, rp, chk, ...)
		local c = e:GetHandler()
		if chk==0 then return c:IsDiscardable() and (not additional_cost or additional_cost(e, tp, eg, ep, ev, re, r, rp, chk, ...)) end
		Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
		if additional_cost then
			additional_cost(e, tp, eg, ep, ev, re, r, rp, chk, ...)
		end
	end
end

--- Create activation condition function for active type action card (c Card)
--- @param additional_condition function?
--- @return function
function CS.ActionCardActiveConditionFunction(additional_condition)
	return function (e, tp, eg, ep, ev, re, r, rp, ...)
		-- active effect must not be activate in response to other effect
		if Duel.GetCurrentChain() > 0 then return false end
		-- active effect can only be activated on their own turn
		if Duel.GetTurnPlayer() ~= tp then return false end
		return not additional_condition or additional_condition(e, tp, eg, ep, ev, re, r, rp, ...)
	end
end