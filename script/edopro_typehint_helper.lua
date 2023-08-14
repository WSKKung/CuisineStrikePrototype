---@meta
---@version 5.3
---@module "constant"
---this script is intended to help with type hinting and autocompleting EdoPro's functions 
---src: https://github.com/ProjectIgnis/CardScripts/wiki

--- @alias Reason integer
--- @alias EffectCategory integer
--- @alias EffectCode integer

--- @alias Location integer
--- @alias Player integer
--- @alias Race integer
--- @alias Attribute integer
--- @alias CardType integer
--- @alias SummonType integer
--- @alias BattlePosition integer

--- @class CardPrototype
--- @field initial_effect fun(c: Card)
CardPrototype = {}

---Returns two values, a card object and its ID, used before the initial effect.
---@return CardPrototype, integer
function GetID() end

--#region Debug

---@class Debug
Debug = {}

---comment
---@param code integer
---@param owner Player
---@param player Player
---@param location Location
---@param seq integer
---@param pos BattlePosition
---@param proc boolean? deafult to false
---@return Card
function Debug.AddCard(code, owner, player, location, seq, pos, proc) end

---Sends (any msg) as a script error to the logs
---@param msg any
function Debug.Message(msg) end

function Debug.PreAddCounter(c, counter_type, count) end
function Debug.PreEquip(equip_card, target) end
function Debug.PreSetTarget(c, target) end
function Debug.PreSummon(c, sum_type, sum_location, summon_sequence, summon_pzone) end
function Debug.ReloadFieldBegin(flag, rule, ignore_rule) end
function Debug.ReloadFieldEnd() end
function Debug.SetAIName(name) end
function Debug.SetPlayerInfo(playerid, lp, startcount, drawcount) end
function Debug.ShowHint(msg) end

--#endregion

--#region Card

--- @class Card
Card = {}

function Card.AddAdditionalAttack(c, atknum, reset, rc, condition, properties) end
function Card.AddAdditionalAttackOnMonster(c, atknum, reset, rc, condition, properties) end
function Card.AddAdditionalAttackOnMonsterAll(c, reset, rc, value, condition, properties) end
function Card.AddCannotBeDestroyedBattle(c, reset, value, rc, condition, properties) end
function Card.AddCannotBeDestroyedEffect(c, ctype, reset, rc, condition, properties) end
function Card.AddCenterToSideEffectHandler(c, eff) end

---Adds a number (int count) of the specified counter (int countertype) to a card (Card c). If singly is set to a number, then it will be added by that number each time. When the number of added counter would exceed the limit for that card, it is not added.
---@param c Card
---@param countertype integer
---@param count integer
---@param singly integer?
---@return boolean
function Card.AddCounter(c, countertype, count, singly) end

function Card.AddDirectAttack(c, reset, rc, condition, properties) end
function Card.AddDoubleTribute(c, id, otfilter, eftg, reset, ...) end
function Card.AddMaximumAtkHandler(c) end

---Transforms a card (Card c) to a monster. The card type will become TYPE_MONSTER + extra_type. Uses the values if provided, otherwise uses the card's own values in Database. Be aware that the values added using this (except for Card type) will be reset when the card is flipped face-down.
---@param c Card
---@param extra_type CardType
---@param attribute Attribute?
---@param race Race?
---@param level integer?
---@param atk integer?
---@param def integer?
function Card.AddMonsterAttribute(c, extra_type, attribute, race, level, atk, def) end

---Used in conjunction with Card.AddMonsterAttribute, completes a card's (Card c) transformation to a monster. It is best to call this after the card has arrived in Monster Zone (i.e. after Duel.SpecialSummonStep). Does nothing with cards without EFFECT_PRE_MONSTER (added automatically by Card.AddMonsterAttribute).
---@param c Card
function Card.AddMonsterAttributeComplete(c) end

function Card.AddNoTributeCheck(c, id, stringid, rangeP1, rangeP2) end

---to be added. Available in proc_maximum.lua
---@param c Card the card gaining effect
---@param reset integer when the effect should disappear 
---@param rc Card? the card giving effect, default to the card gaining the effect itself
---@param condition ConditionFunction? condition for the effect to be "active"
---@param properties integer? properties beside EFFECT_FLAG_CLIENT_HINT
function Card.AddPiercing(c, reset, rc, condition, properties) end

---to be added. Available in utility.lua
---@param c Card
---@param code integer
---@param copyable boolean
---@param ... integer
---@return table
function Card.AddSetcodesRule(c, code, copyable, ...) end

function Card.AddSideMaximumHandler(c, eff) end

---	Changes (Card c)'s alias if (int code) is inputted, else returns the current card's alias.
---@param c Card
---@param code integer
---@return integer?
function Card.Alias(c, code) end

---Makes (int player) announce an attribute different from the one(s) (Card c) currently has
---@param c Card
---@param tp Player
---@return Attribute
function Card.AnnounceAnotherAttribute(c, tp) end

---Makes (int player) announce a monster type (Race) different from the one(s) (Card c) currently has
---@param c Card
---@param tp Player
---@return Race
function Card.AnnounceAnotherRace(c, tp) end

function Card.AssumeProperty(c, assume_type, assume_value) end

---Changes (Card c)'s original ATK if (int val) is inputted, else returns the current card's original ATK.
---@param c Card
---@param val integer?
---@return integer
function Card.Attack(c, val) end

---Changes (Card c)'s original attribute(s) if (int att) is inputted, else returns the current card's original attribute(s).
---@param c Card
---@param att Attribute
---@return Attribute
function Card.Attribute(c, att) end

function Card.CanAttack(c) end
function Card.CanBeDoubleTribute(c, ...) end

---Removes the second card (Card c2) from the list of the first card (Card c1)'s target
---@param c1 Card
---@param c2 Card
function Card.CancelCardTarget(c1, c2) end

function Card.CancelToGrave(c, cancel) end

---Checks if a card (Card c) can make a follow-up attack. Specifying the integer ac checks whether it can attack that number of times. Setting monsteronly to true checks only the possibility of follow-up attack to monster
---@param c Card
---@param ac integer? default to 2
---@param monsteronly boolean? default to false
---@return boolean
function Card.CanChainAttack(c, ac, monsteronly) end

---Returns true if a monster can get a piercing effect as per Rush rules
---@param c Card
---@return boolean
function Card.CanGetPiercingRush(c) end

---Returns if the (Card c) can be either Normal Summoned or Set by (Effect e), if it is not nil. If (bool ignore_count) is true, it ignores the standard once per turn summon limit. (int min) is the minimum number of tributes that are required
---@param c Card
---@param ignore_count boolean
---@param e Effect|nil
---@param min integer?
---@return boolean
function Card.CanSummonOrSet(c, ignore_count, e, min) end

---Checks a card (Card c)'s EFFECT_TYPE_ACTIVATE effect while checking for whether it can be activated. Returns nil if effect condition is not met. Set neglect_con to true to ignore condition checking. Set neglect_cost to true to ignore cost payable checking. Set copy_info to true to return the activate effect's supposed info, for other than EVENT_FREE_CHAIN usually (eg, ep, ev, r, re, rp)
---@param c Card
---@param neglect_con boolean
---@param neglect_cost boolean
---@param copy_info boolean
---@return Effect, Group?, integer?, integer?, Effect?, integer?, integer?
function Card.CheckActivateEffect(c, neglect_con, neglect_cost, copy_info) end

function Card.CheckAdjacent(c) end
function Card.CheckEquipTarget(c1, c2) end
function Card.CheckEquipTargetRush(equip, monster) end
function Card.CheckFusionMaterial(c, g, gc, chkf) end
function Card.CheckFusionSubstitute(c, fc) end
function Card.CheckRemoveOverlayCard(c, player, count, reason) end
function Card.CheckUniqueOnField(c, check_player, check_location, icard) end
function Card.CheckUnionTarget(c, eqc) end
function Card.ClearEffectRelation(c) end

---Changes (Card c)'s original card name if (int code) is inputted, else returns the current original card name.
---@param c Card
---@param code integer?
---@return integer
function Card.Code(c, code) end

function Card.CompleteProcedure(c) end
function Card.CopyEffect(c, code, reset_flag, reset_count) end
function Card.Cover(c) end
function Card.CreateEffectRelation(c, e) end
function Card.CreateRelation(c1, c2, reset_flag) end

---Changes (Card c)'s original DEF if (int val) is inputted, else returns the current card's original DEF.
---@param c Card
---@param val integer?
---@return integer
function Card.Defense(c, val) end

---Makes the card (Card c) able to hold a type of counter (int countertype). If a location is provided (int location), the card will be able to hold counter only when in the specified location.
---@param c Card
---@param countertype integer
---@param location Location?
function Card.EnableCounterPermit(c, countertype, location) end

---Enables the Gemini effect of a card (Card c). Alias to Card.EnableGeminiState
---@param c Card
function Card.EnableGeminiStatus(c) end

---	Makes a card (Card c) unsummonable except with its own procedure, or after its Summon procedure is complete (for example, all extra deck monsters and Ritual monsters)
---@param c Card
function Card.EnableReviveLimit(c) end

---Makes a card (Card c) unsummonable except with its own procedure
---@param c Card
function Card.EnableUnsummonable(c) end

function Card.EquipByEffectAndLimitRegister(c, e) end
function Card.EquipByEffectLimit(c, e, tp, tc, code, mustbefaceup) end
function Card.FromLuaRef(ref) end
function Card.GetActivateEffect(c) end

---	Returns a table containing all the counters Card c currently has
---@param c Card
---@return table
function Card.GetAllCounters(c) end

---Returns the current ATK of "c".
---@param c Card
---@return integer
function Card.GetAttack(c) end

---Gets a card's (Card c) valid attack targets
---@param c Card
---@return Group, boolean
function Card.GetAttackableTarget(c) end

function Card.GetAttackAnnouncedCount(c) end

function Card.GetAttackedCount(c) end

function Card.GetAttackedGroup(c) end

function Card.GetAttackedGroupCount(c) end

---Returns the current Attribute of "c" (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c any
---@param scard Card?
---@param sumtype SummonType? default to 0
---@param playerid Player? default to PLAYER_NONE
---@return Attribute
function Card.GetAttribute(c, scard, sumtype, playerid) end

---Returns the original ATK of "c".
---@param c Card
---@return integer
function Card.GetBaseAttack(c) end

---Returns the original DEF of "c".
---@param c Card
---@return integer
function Card.GetBaseDefense(c) end

function Card.GetBattledGroup(c) end

function Card.GetBattledGroupCount(c) end

---Returns the position of "c" at the start of the Damage Step (see "Marshmallon").
---@param c Card
---@return integer
function Card.GetBattlePosition(c) end

---Gets a card's (Card c) current battle target
---@param c Card
---@return Card
function Card.GetBattleTarget(c) end

---Returns all the effect with that code (int effect_type) applied on a card (Card c). With no effect_type or effect_type=0 it will return all the effects applied on a (Card c). [effect_type refer to "EFFECT_" constants, eg: EFFECT_NECRO_VALLEY]
---@param c Card
---@param effect_type EffectCode? default to 0
---@return Effect ...
function Card.GetCardEffect(c, effect_type) end

function Card.GetCardID(c) end
function Card.GetCardTarget(c) end
function Card.GetCardTargetCount(c) end
function Card.GetCode(c) end
function Card.GetColumnGroup(c, left, right) end
function Card.GetColumnGroupCount(c, left, right) end
function Card.GetColumnZone(c, loc, left, right, cp) end

---Returns the current DEF of "c".
---@param c Card
---@return integer
function Card.GetDefense(c) end

---Returns the current Level of "c". (Returns 0 if it has no Level, e.g. Xyz/Link.)
---@param c Card
---@return integer
function Card.GetLevel(c) end

function Card.GetLink(c) end
function Card.GetLinkMarker(c) end
function Card.GetLinkedGroup(c) end
function Card.GetLinkedGroupCount(c) end
function Card.GetLinkedZone(c, cp) end

---Returns the location of "c".
---@param c Card
---@return Location
function Card.GetLocation(c) end

function Card.GetLuaRef(c) end
function Card.GetMaterial(c) end
function Card.GetMaterialCount(c) end
function Card.GetMaterialCountRush(c) end
function Card.GetMaximumAttack(c) end
function Card.GetMetatable(c, current_code) end
function Card.GetMutualLinkedGroup(c) end
function Card.GetMutualLinkedGroupCount(c) end
function Card.GetMutualLinkedZone(c, cp) end

function Card.GetOriginalAttribute(c) end
function Card.GetOriginalCode(c) end
function Card.GetOriginalCodeRule(c) end
function Card.GetOriginalLeftScale(c) end


---Returns the original Level of "c". (Returns 0 if it has no Level, e.g. Xyz/Link.)
---@param c Card
---@return integer
function Card.GetOriginalLevel(c) end

function Card.GetOriginalRace(c) end
function Card.GetOriginalRank(c) end
function Card.GetOriginalRightScale(c) end
function Card.GetOriginalSetCard(c) end
function Card.GetOriginalType(c) end

---Returns the owner of "c".
---@param c Card
---@return Player
function Card.GetOwner(c) end

function Card.GetOwnerTarget(c) end
function Card.GetOwnerTargetCount(c) end
function Card.GetPosition(c) end
function Card.GetPreviousAttackOnField(c) end
function Card.GetPreviousAttributeOnField(c) end
function Card.GetPreviousCodeOnField(c) end
function Card.GetPreviousControler(c) end
function Card.GetPreviousDefenseOnField(c) end
function Card.GetPreviousEquipTarget(c) end
function Card.GetPreviousLevelOnField(c) end
function Card.GetPreviousLocation(c) end
function Card.GetPreviousPosition(c) end
function Card.GetPreviousRaceOnField(c) end
function Card.GetPreviousRankOnField(c) end
function Card.GetPreviousSequence(c) end
function Card.GetPreviousSetCard(c) end
function Card.GetPreviousTypeOnField(c) end

---Returns the current Monster Type of "c" (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c Card
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return Race
function Card.GetRace(c, scard, sumtype, playerid) end

function Card.GetRank(c) end
function Card.GetRealFieldID(c) end
function Card.GetReason(c) end
function Card.GetReasonCard(c) end
function Card.GetReasonEffect(c) end
function Card.GetReasonPlayer(c) end
function Card.GetRightScale(c) end
function Card.GetRitualLevel(c, rc) end
function Card.GetScale(c) end
function Card.GetSequence(c) end

---Returns the archetype(s) that "c" has (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c Card
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return integer
function Card.GetSetCard(c, scard, sumtype, playerid) end

function Card.GetSummonLocation(c) end
function Card.GetSummonPlayer(c) end
function Card.GetSummonType(c) end
function Card.GetSynchroLevel(c, sc) end
function Card.GetTextAttack(c) end
function Card.GetTextDefense(c) end

function Card.GetToBeLinkedZone(g, c, tp, clink, emz) end
function Card.GetTributeRequirement(c) end
function Card.GetTurnCounter(c) end
function Card.GetTurnID(c) end

---Gets the current type of a Card (Card c) where (Card scard) if provided checks the monster that (Card c) would be used as material, (int sumtype) is for checking the summon type and (int playerid) is the player checking the type.
---@param c Card
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return CardType
function Card.GetType(c, scard, sumtype, playerid) end

function Card.IsAbleToChangeControler(c) end
function Card.IsAbleToDeck(c) end
function Card.IsAbleToDeckAsCost(c) end
function Card.IsAbleToExtra(c) end
function Card.IsAbleToExtraAsCost(c) end

---Checks if a card (Card c) is able to go to the Graveyard
---@param c Card
---@return boolean
function Card.IsAbleToGrave(c) end

---Checks if a card (Card c) is able to go to the Graveyard as a cost
---@param c Card
---@return boolean
function Card.IsAbleToGraveAsCost(c) end

function Card.IsAbleToHand(c) end
function Card.IsAbleToHandAsCost(c) end
function Card.IsAbleToRemove(c, player, pos, reason) end
function Card.IsAbleToRemoveAsCost(c, pos) end
function Card.IsAllColumn(c) end
function Card.IsAttack(c, ...) end
function Card.IsAttackAbove(c, atk) end
function Card.IsAttackBelow(c, atk) end
function Card.IsAttackPos(c) end
function Card.IsAttribute(c, attribute, scard, sumtype, playerid) end
function Card.IsAttributeExcept(c, att, card, scard, sumtype, playerid) end
function Card.IsBattleDestroyed(c) end
function Card.IsCanAddCounter(c, countertype, count, least_one, loc) end
function Card.IsCanBeBattleTarget(c1, c2) end
function Card.IsCanBeDisabledByEffect(e, is_monster_effect) end
function Card.IsCanBeEffectTarget(c, e) end

---Checks if a card (Card c) can be a Fusion material. If (Card fc) is provided, checks if it can be a Fusion Material for that card. If ignore_mon is true, it does not check whether the card is a monster.
---@param c Card
---@param fc Card?
---@param ignore_mon boolean?
---@return boolean
function Card.IsCanBeFusionMaterial(c, fc, ignore_mon) end

function Card.IsCanBeLinkMaterial(c, linkc) end
function Card.IsCanBeMaterial(c, summontype) end
function Card.IsCanBeRitualMaterial(c, sc, player) end
function Card.IsCanBeSpecialSummoned(c, e, sumtype, sumplayer, nocheck, nolimit, sumpos, target_player, zone) end
function Card.IsCanBeSynchroMaterial(c, sc, tuner, player) end
function Card.IsCanBeXyzMaterial(c, sc, tp, reason) end
function Card.IsCanChangePosition (c) end
function Card.IsCanChangePositionRush(c) end
function Card.IsCanRemoveCounter(c, player, countertype, count, reason) end
function Card.IsCanTurnSet(c) end

---Checks if "c" has at least 1 code/ID among the "..." list.
---@param c Card
---@param ... integer
---@return boolean
function Card.IsCode(c, ...) end

function Card.IsCode(c, ...) end
function Card.IsContinuousSpell(c) end
function Card.IsContinuousTrap(c) end

---Checks if a card (Card c) has player (int p) as it's controller
---@param c Card
---@param controler Player
---@return boolean
function Card.IsControler(c, controler) end

function Card.IsControlerCanBeChanged(c, ign, zone) end
function Card.IsCounterTrap(c) end
function Card.IsDefense(c, ...) end
function Card.IsDefenseAbove(c, def) end
function Card.IsDefenseBelow(c, def) end
function Card.IsDefensePos(c) end

---	Returns if the Card object got internally deleted and remained as dangling reference inside the lua state.
---@param c Card
---@return true
function Card.IsDeleted(c) end

---Checks if a card (Card c) can be discarded for (int reason).
---@param c Card
---@param reason Reason? = REASON_COST
---@return boolean
function Card.IsDiscardable(c, reason) end

function Card.IsDoubleTribute(c, ...) end
function Card.IsEquipSpell(c) end
function Card.IsEvenScale(c) end
function Card.IsExactType(c, typ, sumc, sumtype, player) end
function Card.IsExtraLinked(c) end
function Card.IsFacedown(c) end
function Card.IsFaceup(c) end

function Card.IsHasEffect(c, code) end

---Checks if a card (Card c) is located on the specified location (int location)
---@param c any
---@param location any
---@return boolean
function Card.IsLocation(c, location) end

---Checks if the Monster Type of "c" is "race" (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c Card
---@param race Race
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return boolean
function Card.IsRace(c, race, scard, sumtype, playerid) end

---Checks whether a card (Card c) is related to battle (either as attacker or as an attack target)
---@param c Card
---@return boolean
function Card.IsRelateToBattle(c) end

--- Checks whether a card (Card c1) is related to another card (Card c2) (That results from c1:CreateRelation(c2))
---@param c1 Card
---@param c2 Card
---@return boolean
function Card.IsRelateToCard(c1, c2) end

---Checks whether a card (Card c) is related to the chain numbered (int chainc)
---@param c Card
---@param chainc integer
---@return boolean
function Card.IsRelateToChain(c, chainc) end

---Checks whether a card (Card c) is related to an effect (Effect e)
---@param c Card
---@param e Effect
---@return boolean
function Card.IsRelateToEffect(c, e) end

function Card.IsReleasable(c) end
function Card.IsReleasableByEffect(c) end
function Card.IsRikkaReleasable(c) end
function Card.IsRitualMonster(c) end
function Card.IsRitualSpell(c) end
function Card.IsSequence(c, ...) end

---Checks if "c" is part of the archetype "setname" (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c Card
---@param setname integer
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return boolean
function Card.IsSetCard(c, setname, scard, sumtype, playerid) end

function Card.IsSpecialSummonable(c) end
function Card.IsSpell(c) end
function Card.IsSpellTrap(c) end
function Card.IsSSetable(c, ignore_field) end
function Card.IsStatus(c, status) end
function Card.IsSummonable(c, ignore_count, e, min) end
function Card.IsSummonCode(c, sc, sumtype, playerid, ...) end

---Checks if the card type of "c" is "type" (if it is to be used as material for "scard" with Summon type "sumtype" by player "playerid").
---@param c Card
---@param type CardType
---@param scard Card?
---@param sumtype SummonType?
---@param playerid Player?
---@return boolean
function Card.IsType(c, type, scard, sumtype, playerid) end

---Applies an ATK change to card c, equal to int amount. If the reset values (int reset) are not provided, the default is RESET_EVENT (+RESETS_STANDARD_DISABLE , if rc == c, or just +RESETS_STANDARD). If the reason card rc is not provided, uses as default card c. Returns the amount of ATK successfully changed.
---@param c Card
---@param e Effect
---@param forced boolean?
---@param ... unknown
function Card.RegisterEffect(c, e, forced, ...) end

---Applies a DEF change to card c, equal to int amount. If the reset values (int reset) are not provided, the default is RESET_EVENT (+RESETS_STANDARD_DISABLE , if rc == c, or just +RESETS_STANDARD). If the reason card rc is not provided, uses as default card c. Returns the amount of DEF successfully changed.
---@param c Card
---@param amount integer
---@param reset integer?
---@param rc Card?
---@return integer
function Card.UpdateAttack(c, amount, reset, rc) end

---Applies a DEF change to card c, equal to int amount. If the reset values (int reset) are not provided, the default is RESET_EVENT (+RESETS_STANDARD_DISABLE , if rc == c, or just +RESETS_STANDARD). If the reason card rc is not provided, uses as default card c. Returns the amount of DEF successfully changed.
---@param c Card
---@param amount integer
---@param reset integer?
---@param rc Card?
---@return integer
function Card.UpdateDefense(c, amount, reset, rc) end

---Applies a level change to card c, equal to int amount. If the reset values (int reset) are not provided, the default is RESET_EVENT (+RESETS_STANDARD_DISABLE if rc == c, or just +RESETS_STANDARD) If the reason card rc is not provided, uses as default card c. Returns the amount of levels successfully changed.
---@param c Card
---@param amount integer
---@param reset integer?
---@param rc Card?
---@return integer
function Card.UpdateLevel(c, amount, reset, rc) end

--#endregion

--#region Duel

--- @class Duel
Duel = {}

---Activates an effect in a new chain link. If the effect is the activate effect of a spell/trap, that card is also activated.
---@param e Effect
function Duel.Activate(e) end

---Registers an activity with type (int activity_type), with id (int counter_id), that matches (function f)
---@param counter_id integer
---@param activity_type integer
---@param f function
function Duel.AddCustomActivityCounter(counter_id, activity_type, f) end

---Separates an effect for the purposes of timing (Reflects the effects of the conjunctives "then" and "also after that")
function Duel.BreakEffect() end

function Duel.CheckReleaseGroup(player, f, count, use_hand, max, check_field, card_to_check, to_player, zone, use_oppo, ex, ...) end
function Duel.CheckReleaseGroupCost(player, f, minc, maxc, use_hand, spcheck, ex, ...) end
function Duel.CheckReleaseGroupEx(player, f, count, use_hand, max, check_field, card_to_check, to_player, zone, use_oppo, ex, ...) end
function Duel.CheckReleaseGroupSummon(c, player, e, fil, min, max, last, ...) end
function Duel.CheckRemoveOverlayCard(player, s, o, count, reason) end
function Duel.CheckSummonedCount(c) end
function Duel.CheckTiming(timing) end
function Duel.CheckTribute(c, min, max, mg, tp, zone) end
function Duel.ClearOperationInfo(chainc) end
function Duel.ClearTargetCard() end

---Reveals the passed cards to the passed player if they are in a private knowledge state.
---@param player Player
---@param targets Card|Group
function Duel.ConfirmCards(player, targets) end

function Duel.ConfirmDecktop(player, count) end
function Duel.ConfirmExtratop(tp, count) end
function Duel.CountHeads(results, ...) end
function Duel.CountTails(results, ...) end
function Duel.CreateToken(player, code) end

---Damages/Decreases player's (int player) Life Points by an amount (int value) for a reason (int reason). The damage is considered to be dealt by (int rp). Setting (bool is_step) to true will make so the damage is considered dealt at the call of Duel.RDComplete().
---@param player Player
---@param value integer
---@param reason Reason
---@param is_step boolean?
---@param rp Player?
---@return integer
function Duel.Damage(player, value, reason, is_step, rp) end

---Destroys a card or group (Card|Group targets) with (int reason) as reason, and sends the card in the location specified by (int dest). If (int rp) is passed, sets the reason player to be that player. Returns the number of cards successfully destroyed.
---@param targets Card|Group
---@param reason Reason
---@param dest Location? default to LOCATION_GRAVE
---@param rp Player? default to reason player
function Duel.Destroy(targets, reason, dest, rp) end

---A player (int player) sends the top n cards (int count) to the Graveyard (discard mechanic) with a reason (int reason)
---@param player Player
---@param count integer
---@param reason Reason
---@return integer
function Duel.DiscardDeck(player, count, reason) end

---Makes (int player) Discard between (int min) and (int max) cards from their hand for which (function f) returns true, except (Group|Card ex), for (int reason)
---@param player Player
---@param f CardFilterFunction
---@param min integer
---@param max integer
---@param reason Reason
---@param ex CardFilterExclusion
---@param ... unknown
---@return integer
function Duel.DiscardHand(player, f, min, max, reason, ex, ...) end

---Player (int player) draws a specific amount (int count) of Cards for a reason (REASON_x)
---@param player Player
---@param count integer
---@param reason Reason
---@return integer
function Duel.Draw(player, count, reason) end

function Duel.Equip(player, c1, c2) end

---Gets the attacking card (or nil if there is no attacker)
---@return Card?
function Duel.GetAttacker() end

---Gets the attack target card (or nil if there's no attack target/the attack is a direct attack)
---@return Card?
function Duel.GetAttackTarget() end

---Gets the battle damage (int player) would take
---@param player Player
---@return integer
function Duel.GetBattleDamage(player) end

---Returns as first value the monster that is currently battling from the perspective of tp (nil if tp has no currently battling monsters), as second value returns the battling monster from the perspective of 1-tp.
---@param tp Player
---@return Card|nil, Card|nil
function Duel.GetBattleMonster(tp) end

---Returns the number of the current chain link. If real chain is true, then it will return the number of ACTUAL chains that have already formed, so in a target or cost function, it will not include the current chain in this count, while with that parameter as false the current chain will be included as well. Set this when you need to check for the current chain in an effect condition.
---@param real_chain boolean? default to false
---@return integer
function Duel.GetCurrentChain(real_chain) end

---Gets the current Phase of the game (corresponds to PHASE_x in constants.lua)
---@return integer
function Duel.GetCurrentPhase() end

function Duel.GetDecktopGroup(player, count) end

---Gets a group containing cards from a specified location of a player (int player), s denotes the player's side of the field, o denotes opposing player's side of the field
---@param player Player
---@param s Location
---@param o Location
---@return Group
function Duel.GetFieldGroup(player, s, o) end

---Counts the number of cards from a specified location of a player (int player), s denotes the player's side of the field, o denotes opposing player's side of the field
---@param player Player
---@param s Location
---@param o Location
---@return integer
function Duel.GetFieldGroupCount(player, s, o) end

function Duel.GetFieldGroupCountRush(player, s, o) end

---Get the first card in locations (int s) (on (int player)'s side of the field) and (int o) (on their opponent's) for which (function f) returns true, except (Card ex)
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param ex CardFilterExclusion
---@param ... unknown
---@return Card
function Duel.GetFirstMatchingCard(f, player, s, o, ex, ...) end

---Returns all the cards that got targeted in the current chain link as separate return values, Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS) is an equivalent alternative that directly returns a group. Duel.GetTargetCards() is a better alternative that returns a group and of target cards that are filtered depending on their relation to the effect.
---@return Card,...
function Duel.GetFirstTarget() end

---Gets the flag effect with (int code) as the effect code that is registered to a player (int player), returns 0 if no effect, a positive integer otherwise
---@param player Player
---@param code integer
---@return integer
function Duel.GetFlagEffect(player, code) end

---Gets the integer labels to the flag effect registered to the player (int player) with (int code) as the effect code, returns nil if there is no integer label.
---@param player Player
---@param code integer
---@return integer
function Duel.GetFlagEffectLabel(player, code) end


---Returns 2 values. First the number of zones that a player (target_player) has available in a location of the field (int location)[, that can be used by the player (use_player), with intention of (reason), among certain zones (zone)]. Second return is a flag with the available zones.
---@param player Player
---@param location Location
---@param use_player Player? default to reason player
---@param reason Reason? default to LOCATION_REASON_TOFIELD
---@param zone integer? default to 0xff
---@return integer,integer
function Duel.GetLocationCount(player, location, use_player, reason, zone) end

---Gets the number of available zones that (int player) has to perform a Special Summon from the Extra Deck. Optional Parameters: int rplayer is the player performing the summon , by default comes from the player that activates the effect itself; sg are material(s) or tribute(s) for the special summon, it's included when the effect requires the cost of one or more cards; lc is the card that will be special summoned, it's included when it's a specific card which will be special summon). If lc is group, it cannot be passed directly. Instead, pass the type of the monsters in that group (e.g. TYPE_FUSION, see "Construct Element"), which is limited to a single type and will not work properly if the group has different types. The zone parameter is used to limit the check to only some specific zones of the field. The second return is a flag with the available zones.
---@param player Player
---@param rplayer Player? default to reason player
---@param sg (Group|Card)? default to nil
---@param lc (Card|integer|nil)? default to nil
---@param zone integer? default to 0xff
---@return integer,integer
function Duel.GetLocationCountFromEx(player, rplayer, sg, lc, zone) end

---Gets a specified player's (int player) current Life Point
---@param player any
---@return integer
function Duel.GetLP(player) end

---Gets all cards in locations (int s) (on (int player)'s side of the field) and (int o) (on their opponent's) for which (function f) returns true, except (Card ex)
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
function Duel.GetMatchingGroup(f, player, s, o, ex, ...) end

---Returns the number of cards that would be returned by Duel.GetMatchingGroup
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param ex CardFilterExclusion
---@param ... unknown
---@return integer
function Duel.GetMatchingGroupCount(f, player, s, o, ex, ...) end

---Equivalent to Duel.GetMatchingGroup, but the cards are also filtered to match Auxiliary.FilterMaximumSideFunctionEx
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param ex CardFilterExclusion
---@param ... unknown
---@return integer
function Duel.GetMatchingGroupCountRush(f, player, s, o, ex, ...) end

function Duel.GetMetatable(code) end
function Duel.GetMZoneCount(target_player, ex, use_player, reason, zone) end

function Duel.GetPlayerEffect(player, effect_type) end
function Duel.GetPlayersCount(team) end
function Duel.GetPossibleOperationInfo(chainc, category) end

---Gets a random number between min (default is 0) and max.
---@param min integer? default to 0
---@param max integer
---@return integer
function Duel.GetRandomNumber(min, max) end

---Returns the turn player (0 for the player who went first, 1 for the other)
---@return Player
function Duel.GetTurnPlayer() end

function Duel.GetTurnCount() end

---Creates a message for the "player" which has "type" as key and "desc" as value. It is entirely up to the client to interpret say data, the most common case is setting the selection message with, "type" being "HINT_SELECTMSG" and "desc" being a stringId. It is also used to implement Skill Cards visually. Check the "HINT_XXX" constants for their behaviour.
---@param hint_type integer
---@param player Player
---@param desc integer
function Duel.Hint(hint_type, player, desc) end

---If log_as_selection is true, that selection will be logged by the client as "card(s) selected" rather than "card(s) targeted"
---@param selection Card|Group
---@param log_as_selection boolean?
function Duel.HintSelection(selection, log_as_selection) end

function Duel.IsAbleToEnterBP() end
function Duel.IsAttackCostPaid() end
function Duel.IsBattlePhase() end
function Duel.IsCanAddCounter(player, countertype, count, c) end
function Duel.IsCanRemoveCounter(player, s, o, countertype, count, reason) end

---	Checks if a chain's (int chainc) effect can be disabled (Negate Effect)
---@param chainc integer
---@return boolean
function Duel.IsChainDisablable(chainc) end

function Duel.IsChainNegatable(chainc) end
function Duel.IsChainSolving() end
function Duel.IsDamageCalculated() end
function Duel.IsDuelType(flag) end
function Duel.IsEnvironment(code, player, location) end

---Checks if (int count) cards exist in locations (int s) (on (int player)'s side of the field) and (int o) (on their opponent's) for which (function f) returns true, except (Card ex)
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param count integer
---@param ex CardFilterExclusion
---@param ... unknown
---@return boolean
function Duel.IsExistingMatchingCard(f, player, s, o, count, ex, ...) end

---This function's behaviour is equivalent of calling Duel.IsExistingMatchingCard with the same arguments and filtering cards with Card.IsCanBeEffectTarget with the current reason effect as parameter (internal to the core, but most of the time corresponds to the effect itself)
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param count integer
---@param ex CardFilterExclusion
---@param ... unknown
---@return boolean
function Duel.IsExistingTarget(f, player, s, o, count, ex, ...) end

function Duel.IsMainPhase() end
function Duel.IsPlayerAffectedByEffect(player, code) end
function Duel.IsPlayerCanAdditionalSummon(tp) end

---Checks if a player (int player) can mill a number of cards (int count) from their Deck
---@param player Player
---@param count integer
---@return boolean
function Duel.IsPlayerCanDiscardDeck(player, count) end

---Checks if a player (int player) can mill a number of cards (int count) from their Deck as cost
---@param player Player
---@param count integer
---@return boolean
function Duel.IsPlayerCanDiscardDeckAsCost(player, count) end

---Checks if (int player) can draw (int count) cards from their deck
---@param player Player
---@param count integer? default to 0
---@return boolean
function Duel.IsPlayerCanDraw(player, count) end

function Duel.IsPlayerCanFlipSummon(player, c) end
function Duel.IsPlayerCanPendulumSummon(player) end
function Duel.IsPlayerCanRelease(player, c) end
function Duel.IsPlayerCanRemove(player, c) end
function Duel.IsPlayerCanSendtoDeck(player, c) end
function Duel.IsPlayerCanSendtoGrave(player, c) end
function Duel.IsPlayerCanSendtoHand(player, c) end
function Duel.IsPlayerCanSpecialSummon(player, sumtype, sumpos, target_player, c) end
function Duel.IsPlayerCanSpecialSummonCount(player, count) end
function Duel.IsPlayerCanSpeciaSummonMonster(player, code, setcode, type, atk, def, level, race, attribute, pos, target_player, sumtype) end
function Duel.IsPlayerCanSummon(player, sumtype, c) end
function Duel.IsSummonCancelable() end
function Duel.IsTurnPlayer(player) end
function Duel.LinkSummon(player, c, must_use, mg, minc, maxc) end
function Duel.LoadCardScript(code) end

---Loads into the current environment (duel/puzzle) (file_name)'s script, and return true or false depending on the script loading success. If "forced" is false, the file name is loaded only if it hasn't been loaded before. If "forced" is true, other than loading the script regardless if it has been loaded previously, the 2nd returned value will be whatever was set as the global variable "edopro_export" from the loaded script.
---@param file_name string
---@param forced boolean? default to false
function Duel.LoadScript(file_name, forced) end

function Duel.LoadCardScriptAlias(code) end
function Duel.MajesticCopy(c1, c2, reset_value, reset_count) end

---Moves a card (Card c) to a different sequence (int seq). If (int location) is not provided, only the current location is considered
---@param c Card
---@param seq integer
---@param location Location?
function Duel.MoveSequence(c, seq, location) end

function Duel.MoveToDeckBottom(targets, player) end
function Duel.MoveToDeckTop(targets, player) end

---A player (int move_player) moves a card (Card c) to the target player's field. The destination must be either LOCATION_MZONE or LOCATION_SZONE (maybe LOCATION_ONFIELD too). It will be sent with the given position (int pos). Its effects will either be enabled or disabled according to the last parameter (bool enabled), if zone is specified, it can only place the card in these zones.
---@param c Card
---@param move_player Player
---@param target_player Player
---@param dest Location
---@param pos BattlePosition
---@param enabled boolean
---@param zone integer? default to 0x1f
function Duel.MoveToField(c, move_player, target_player, dest, pos, enabled, zone) end

function Duel.MSet(player, c, ignore_count, e, min, zone) end
function Duel.NegateActivation(chainc) end
function Duel.NegateAttack() end
function Duel.NegateEffect(chainc) end
function Duel.NegateRelatedChain(c, reset) end
function Duel.NegateSummon(targets) end
function Duel.Overlay(c, of_card, send_to_grave) end

---	Makes a player (int player) pay an amount (int cost) of LP
---@param player Player
---@param cost integer
function Duel.PayLPCost(player, cost) end
---Raises a specific event that will raise effects of type EFFECT_TYPE_FIELD, by relying re,r,rp,ep,ev as the arguments of that event with eg being the cards that were the reason of that event.
---@param eg Card|Group
---@param code EffectCode
---@param re Effect
---@param r Reason
---@param rp Player
---@param ep Player
---@param ev integer
function Duel.RaiseEvent(eg, code, re, r, rp, ep, ev) end

---Raises a specific event that will raise effects of type EFFECT_TYPE_SINGLE on the specific ec, by relying re,r,rp,ep,ev as the arguments of that event.
---@param ec Card
---@param code EffectCode
---@param re Effect
---@param r Reason
---@param rp Player
---@param ep Player
---@param ev integer
function Duel.RaiseSingleEvent(ec, code, re, r, rp, ep, ev) end

function Duel.RDComplete() end
function Duel.Readjust() end

---Increases player's (int player) Life Points by an amount (int value) for a reason (REASON_x). Setting is_step to true made the recovery considered being done at the call of Duel.RDComplete()
---@param player Player
---@param value integer
---@param reason Reason
---@param is_step boolean?
---@return integer
function Duel.Recover(player, value, reason, is_step) end

---Registers an effect (Effect e) to a player (int player)
---@param e Effect
---@param player Player
function Duel.RegisterEffect(e, player) end

function Duel.RegisterFlagEffect(player, code, reset_flag, property, reset_count, label) end
function Duel.Release(targets, reason, rp) end
function Duel.ReleaseRitualMaterial(g) end
function Duel.Remove(targets, pos, reason) end
function Duel.RemoveCards(cards) end
function Duel.RemoveCounter(player, s, o, countertype, count, reason) end
function Duel.RemoveOverlayCard(player, s, o, min, max, reason, rg) end
function Duel.ResetFlagEffect(player, code) end
function Duel.ReturnToField(c, pos, zone) end
function Duel.RockPaperScissors(repeated) end

---Asks (int player) Yes or No, with the question being specified by (int desc) highlighting the passed card (Card c). The default string ask the player if they want to use the effect of "card x"
---@param player Player
---@param c Card
---@param description integer? default to 3
---@return boolean
function Duel.SelectEffectYesNo(player, c, description) end

---Asks (int player) to choose a number of Zones up to (int count), in locations (int s) for the player and (int o) for their opponent, that are bitmasked by (int filter) <in another word, zones that are not filter>. This function allows the player to select ANY field zone, even those that are currently occupied by other cards.
---@param player Player
---@param count integer
---@param s Location
---@param o Location
---@param filter integer? default to 0xe0e0e0e0
---@return integer
function Duel.SelectFieldZone(player, count, s, o, filter) end

---Makes int player select Fusion Materials to summon card c from group g.
---@param player Player
---@param c Card
---@param g Group
---@param gc Card?
---@param chkf Player?
---@return Group
function Duel.SelectFusionMaterial(player, c, g, gc, chkf) end

---Makes (int sel_player) select between (int min) and (int max) cards in locations (int s) (on (int player)'s side of the field) and (int o) (on their opponent's) for which (function f) returns true, except (Card ex). If cancelable is true and the selection is canceled nil will be returned. If both cancelable and a minimum of 0 are passed, the result is unspecified.
---@param sel_player Player
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param min integer
---@param max integer
---@param cancelable boolean default to false
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
---@overload fun(sel_player: Player, f: CardFilterExclusion, player: Player, s: Location, o: Location, min: integer, max: integer, ex: CardFilterExclusion, ...)
function Duel.SelectMatchingCard(sel_player, f, player, s, o, min, max, cancelable, ex, ...) end

---Allows (int player) to choose between any number of options, starting with (int desc1). Returns the index of the chosen option, e.g. desc1 returns 0, the second option returns 1, etc. If confirm_dialog is false, the announce will be performed, but the no selection hint will be shown to the opponent
---@param player Player
---@param confirm_dialog boolean? default to true
---@param desc1 integer
---@param ... integer
---@return integer
function Duel.SelectOption(player, confirm_dialog, desc1, ...) end

---This function's behaviour is equivalent of calling Duel.SelectMatchingCard with the same arguments and filtering cards with Card.IsCanBeEffectTarget with the current reason effect as parameter (internal to the core, but most of the time corresponds to the effect itself)
---@param sel_player Player
---@param f CardFilterFunction
---@param player Player
---@param s Location
---@param o Location
---@param min integer
---@param max integer
---@param cancelable boolean
---@param ex CardFilterExclusion
---@return Group
function Duel.SelectTarget(sel_player, f, player, s, o, min, max, cancelable, ex, ...) end

---Asks (int player) Yes or No, with the question being specified by (int desc)
---@param player Player
---@param desc integer
---@return boolean
function Duel.SelectYesNo(player, desc) end

---Sends a card or group (Card|Group targets) to the location (int location) with (int reason) as reason in (ins pos) position (only applies in Extra Deck and Banish). If (int player) is supplied, the destination would be that player's location. A seq value of 0 means it's put on the top, 1 means it's put on the bottom, other values means it's put on the top, and then if it is in the Deck, it will be shuffled after the function resolution, except if Duel.DisableShuffleCheck() is set to true beforehand. If (int rp) is provided, sets the reason player to be that player. Returns the number of cards successfully sent.
---@param targets Card|Group
---@param location Location
---@param reason Reason
---@param pos BattlePosition? defaykt to POS_FACEUP
---@param player Player? default to PLAYER_NONE
---@param sequence integer? default to 0
---@param rp integer? default to reason player
---@return integer
function Duel.Sendto(targets, location, reason, pos, player, sequence, rp) end

---Sends a card or group (Card|Group targets) to the Deck with (int reason) as reason, if (int player) is supplied, the destination would be that player's Deck. If (int rp) is provided, sets the reason player to be that player. Available sequence values (SEQ_DECKTOP, SEQ_DECKBOTTOM and SEQ_DECKSHUFFLE). If SEQ_DECKSHUFFLE or other values are used for the sequence, the card is put on the top, and the Deck will be shuffled after the function resolution, except if Duel.DisableShuffleCheck() is set to true beforehand. Returns the number of cards successfully sent to the Deck.
---@param targets Card|Group
---@param player Player? default to PLAYER_NONE
---@param seq integer
---@param reason Reason
---@param rp Player? default to reason player
---@return integer
function Duel.SendtoDeck(targets, player, seq, reason, rp) end

---Sends a card or group (Card|Group targets) to the Graveyard with (int reason) as reason, if (int player) is supplied, the destination would be that player's Graveyard. If (int rp) is provided, sets the reason player to be that player. Returns the number of cards successfully sent.
---@param targets Card|Group
---@param reason Reason
---@param player Player? default to PLAYER_NONE
---@param rp Reason? default to reason player
---@return integer
function Duel.SendtoGrave(targets, reason, player, rp) end

---Sends a card or group (Card|Group targets) to the Hand with (int reason) as reason, if (int player) is supplied, the destination would be that player's Hand. Returns the number of cards successfully sent.
---@param targets Card|Group
---@param player Player? default to PLAYER_NONE
---@param reason Reason
function Duel.SendtoHand(targets, player, reason) end

---	Sets a specified player's (int player) current Life Point to (int lp). (Used by effects that "make the LP become X")
---@param player Player
---@param lp integer
function Duel.SetLP(player, lp) end

function Duel.SetPossibleOperationInfo(chainc, category, targets, count, target_player, target_param) end

---Sets informations about the operation being performed in the current (int chainc = 0) chain, belonging to (int category), with a total of (int count) of card(s) from (Card|Group targets) being affected. These are used with GetOperationInfo. Also, the parameter passed here are checked if any of the summon related activities are checked like ACTIVITY_SUMMON, ACTIVITY_NORMALSUMMON, ACTIVITY_SPSUMMON and ACTIVITY_FLIPSUMMON.
---@param chainc integer
---@param category integer
---@param targets Card|Group
---@param count integer
---@param target_player Player
---@param target_param integer
function Duel.SetOperationInfo(chainc, category, targets, count, target_player, target_param) end

---Shuffles the deck of (int player). Handled automatically if a card is sent to deck sequence -2.
---@param player Player
function Duel.ShuffleDeck(player) end

---A player (int sumplayer) Special Summons a card/group of cards (Card|Group targets) with summon type described with SUMMON_TYPE_x (int sumtype) to a player's (int target_player) field in the specific zone (here zone 0xff, means the default zones). If (bool nocheck) is true, it will summon ignoring conditions. If (bool nolimit) is true, it will summon ignoring the revive limit. Returns the number of cards successfully summoned.
---@param targets Card|Group
---@param sumtype SummonType
---@param sumplayer Player
---@param target_player Player
---@param nocheck boolean
---@param nolimit boolean
---@param pos integer
---@param zone integer? default to 0xff
---@return integer
function Duel.SpecialSummon(targets, sumtype, sumplayer, target_player, nocheck, nolimit, pos, zone) end

function Duel.TossCoin(player, count) end
function Duel.TossDice(player, count1) end

--#endregion

--#region Effect
---@class Effect
Effect = {}

---Clone an effect object (Effect e), duplicating all except register status and assigned labels.
---@param e Effect
---@return Effect
function Effect.Clone(e) end

---Creates a new effect object with a card (Card c) as its owner.
---@param c Card
---@return Effect
function Effect.CreateEffect(c) end

---Gets an effect's (Effect e) condition function, returns nil if no function was set
---@param e Effect
---@return function
function Effect.GetCondition(e) end

function Effect.GetDescription(e) end

---Gets an effect's (Effect e) card handler, if the effect is not attached to a card (i.e. registered to player) it returns nil
---@param e Effect
---@return Card
function Effect.GetHandler(e) end

---Returns the controller of the handler of the effect (Effect e). If the effect is registered to a player, it returns the player it's registered to instead.
---@param e Effect
---@return Player
function Effect.GetHandlerPlayer(e) end

---Gets an effect's (Effect e) internal labels. If no labels are present, it will return 0.
---@param e Effect
---@return integer
function Effect.GetLabel(e) end

---Gets an effect's (Effect e) internal label object
---@param e Effect
---@return Card|Group|Effect|table
function Effect.GetLabelObject(e) end

---Gets an effect's (Effect e) operation function, returns nil if no function was set
---@param e Effect
---@return function
function Effect.GetOperation(e) end

---comment
---@param e Effect
---@return integer
function Effect.GetValue(e) end

---Creates a new effect object, not owned by any specific card.
---@return Effect
function Effect.GlobalEffect() end

---Returns true if the effect (Effect e) has any category listed in (int cate), otherwise returns false
---@param e Effect
---@param cate EffectCategory
---@return boolean
function Effect.IsHasCategory(e, cate) end

---Sets an effect's (Effect e) category. Refer to constant.lua for valid categories.
---@param e Effect
---@param cate EffectCategory
function Effect.SetCategory(e, cate) end

---Sets an effect's (Effect e) code. Refer to constant.lua and card scripts that has been already there for valid codes (or ask someone).
---@param e Effect
---@param code EffectCode
function Effect.SetCode(e, code) end

---Sets (Effect e)'s condition function
---@param e Effect
---@param con_func ConditionFunction|function
function Effect.SetCondition(e, con_func) end

---Sets (Effect e)'s cost function
---@param e Effect
---@param cost_func CostFunction
function Effect.SetCost(e, cost_func) end

---Sets an effect's (Effect e) use limit per turn to (int count). If "code" is supplied, then it would count toward all effects with the same count limit code (i.e. Hard OPT). If a card has multiple HOPT effects on it, then instead of passing "code" as integer, a table can be used as parameter, the first element of this table will be still "code", the second element will instead be the HOPT index of that effect, this is done to prevent the passed code from clashing with other HOPT effects. (e.g. calling "e:SetCountLimit(1, 1234)" is the same as calling "e:SetCountLimit(1, {1234, 0})". The flag parameter consists of the "EFFECT_COUNT_CODE_XXX" constants.
---@param e Effect
---@param count integer
---@param code (EffectCode | {code: EffectCode, hopt_index: integer})? default to 0
---@param flag integer? default to 0
function Effect.SetCountLimit(e, count, code, flag) end

---Sets an effect's (Effect e) description string id with (int desc), you can use aux.Stringid() to reference strings in your database, use the "HINTMSG_" constants, or directly put the string number you want (it's not always recommended, but it is possible if you need to use a system string that is defined in the strings.conf file but doesn't have an equivalent "HINTMSG_" constant).
---@param e Effect
---@param desc integer
function Effect.SetDescription(e, desc) end

---Sets (Effect e)'s client usage hint timing. This is the timing where the game will prompt the player to activate that effect (in addition to regular timings)
---@param e Effect
---@param s_time integer
function Effect.SetHintTiming(e, s_time) end

---Sets an effect's (Effect e) internal labels to the integers passed as parameter (Multiple values and tables can used). This operation replaces previously set labels.
---@param e Effect
---@param label integer
---@vararg integer
function Effect.SetLabel(e, label, ...) end

---Sets an effect's (Effect e) internal label object to label object. This operation replaces a previously stored label object
---@param e Effect
---@param labelobject (Card | Group | Effect | table)
function Effect.SetLabelObject(e, labelobject) end

---Sets (Effect e)'s operation function.
---@param e Effect
---@param op_func OperationFunction|function
function Effect.SetOperation(e, op_func) end

---Sets (int player) as the (Effect e)'s owner player.
---@param e Effect
---@param player Player
function Effect.SetOwnerPlayer(e, player) end

---Sets an effect's (Effect e) property. Refer to constant.lua and card scripts that has been already there for valid properties (or ask someone).
---@param e Effect
---@param prop1 integer
---@param prop2 integer?
function Effect.SetProperty(e, prop1, prop2) end


---Sets an effect's (Effect e) effective range (int range) i.e. LOCATION_MZONE. The location is the effect handler's location.
---@param e Effect
---@param range Location
function Effect.SetRange(e, range) end

---Sets the timing that the effect (Effect e) would be erased (with reset_flag)
---@param e Effect
---@param reset_flag integer
---@param reset_count integer? default to 1
function Effect.SetReset(e, reset_flag, reset_count) end

---Sets (Effect e)'s target function. In a activate effects, the target function is the function used to do the activation legality check and to execute steps that must be done during the activation (e.g. targetting cards, declaring names or numbers, etc).
---@param e Effect
---@param targ_func TargetFunction|function
function Effect.SetTarget(e, targ_func) end

---Sets (Effect e)'s target range, s_range denotes the effect's handler player's range and o_range denotes the opponent's. If the effect has "EFFECT_FLAG_PLAYER_TARGET" as property, then here 1 as "s_range" would mean it affect the handler and 0 would mean it doesn't, and "o_range" would refer to the opponent of the handler.
---@param e Effect
---@param s_range integer
---@param o_range integer
function Effect.SetTargetRange(e, s_range, o_range) end

---Sets an effect's (Effect e) type. constant.lua contains the list with all valid effect types but other cards' scripts can be used as reference
---@param e Effect
---@param type integer
function Effect.SetType(e, type) end

---Sets (Effect e)'s value, or value function
---@param e Effect
---@param val function|integer|boolean
function Effect.SetValue(e, val) end

---Decreases the remaining usages of the effect by the player "p" by "count", if "oath_only" is true, the function will do nothing unless the effect is an OATH effect.
---@param e Effect
---@param p integer
---@param count integer?
---@param oath_only boolean?
function Effect.UseCountLimit(e, p, count, oath_only) end

--#endregion

--#region Group

---@class Group
Group = {}

---Adds a card or group (Card|Group other) to a group (Group g). Returns the group itself. Equivalent to Group.Merge\
---@see Group.Merge
---@param g Group
---@param c Card
---@return Group
function Group.AddCard(g, c) end

---Removes all the elements from a group (Group g). Returns the group itself.
---@param g Group
---@return Group
function Group.Clear(g) end

---Create a copy of a group (Group g) with the same members
---@param g Group
---@return Group
function Group.Clone(g) end

---Create a new Group object
---@return Group
function Group.CreateGroup() end

---Create a new group with members from another group (Group g) filtered according to a function (function f). Excludes a card/group (Group/Card ex) if not nil. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the card will be included if f(c, ...) returns true.
---@param g Group
---@param f CardFilterFunction
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
function Group.Filter(g, f, ex, ...) end

---Counts the amount of members of a group (Group g) which meets the function (function f). Excludes a card (Card ex) if not nil. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the card will be included if f(c, ...) returns true.
---@param g Group
---@param f CardFilterFunction
---@param ex CardFilterExclusion
---@param ... unknown
---@return integer
function Group.FilterCount(g, f, ex, ...) end

---Make a player (int player) select members of a group (Group g) which meets the function (function f), with a minimum and a maximum, then outputs the result as a new Group. Excludes a card (Card ex) if not nil. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the card will be included if f(c, ...) returns true. If cancelable is true and the selection is canceled nil will be returned.
---@param g Group
---@param player Player
---@param f CardFilterFunction
---@param min integer
---@param max integer
---@param cancelable boolean
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
function Group.FilterSelect(g, player, f, min, max, cancelable, ex, ...) end

---Executes a function for each card in a group (Group g), function f should accept one parameter (e.g. f(c, ...), with c as each member of the group and ... can be any number of parameters)
---@param g Group
---@param f fun(c: Card)
---@param ... unknown
function Group.ForEach(g, f, ...) end

---Create a new Group object and populate it with cards (Card c, ...)
---@param c Card
---@param ... Card
---@return Group
function Group.FromCards(c, ...) end

---Returns a table containing all the different values returned by applying the function f to all the members of the Group g,
---@param g Group
---@param f CardToIntFunction
---@param ... unknown
---@return {[integer]: integer}
function Group.GetClass(g, f, ...) end

---Gets the count of different f(c, ...) results from all members of a group (Group g). Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the return value should be integer.
---@param g Group
---@param f CardToIntFunction
---@param ... unknown
---@return integer
function Group.GetClassCount(g, f, ...) end

---Returns the number of cards in a group (Group g)
---@param g Group
---@return integer
function Group.GetCount(g) end

---	Gets the first member of Group g (also resets the internal enumerator). Returns nil if the group is empty.
---@param g Group
---@return Card
function Group.GetFirst(g) end

---Create a new group with members from another group (Group g) which has the maximum result from f(c, ...). Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the return value should be integer, if the group g have no element, that function will return nil.
---@param g Group
---@param f CardToIntFunction
---@param ... unknown
---@return CardFilterExclusion
function Group.GetMaxGroup(g, f, ...) end

---	Create a new group with members from another group (Group g) which has the minimum result from f(c, ...). Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the return value should be integer, if the group g have no element, that function will return nil.
---@param g Group
---@param f CardToIntFunction
---@param ... unknown
---@return CardFilterExclusion
function Group.GetMinGroup(g, f, ...) end

---Gets then next member of Group g (moves the internal enumerator by a step). Returns nil when the whole group was iterated.
---@param g Group
---@return Card?
function Group.GetNext(g) end

---Gets the sum of f(c, ...) result from all members of a group (Group g). Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the return value should be integer.
---@param g Group
---@param f CardToIntFunction
---@param ... unknown
---@return integer
function Group.GetSum(g, f, ...) end

---Checks if (Group g1) contains all cards in (Group g2)
---@param g1 Group
---@param g2 Group
---@return boolean
function Group.Includes(g1, g2) end

---	Checks if a group (Group g) contains a specified card (Card c)
---@param g Group
---@param c Card
---@return boolean
function Group.IsContains(g, c) end

---Checks if at least a number (int count) of members of a group (Group g) meet the function (function f). Excludes a card (Card ex) if not nil. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the card will be included if f(c, ...) returns true.
---@param g Group
---@param f CardFilterFunction
---@param count integer
---@param ex CardFilterExclusion
---@param ... unknown
---@return boolean
function Group.IsExists(g, f, count, ex, ...) end

---Make a group (Group g) not be destroyed upon exiting the function
---@param g Group
function Group.KeepAlive(g) end

---It has the same behaviour as Group.Filter but the changes are done to the Group g and no new group is created.\
---@see Group.Filter
---@param g Group
---@param f CardFilterFunction
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
function Group.Match(g, f, ex, ...) end

---Add a card or group (Card|Group other) to a group (Group g). Returns the group itself. Equivalent to Group.AddCard\
---@see Group.AddCard
---@param g Group
---@param other Card|Group
---@return Group
function Group.Merge(g, other) end

---Make a player (int player) randomly select (int amount) members of a group (Group g).
---@param g Group
---@param player Player
---@param count integer
---@return Card
---@return Group
function Group.RandomSelect(g, player, count) end

---Removes members of a group (Group g) that meets the function (function f). Excludes a card (Card ex) from removal if not nil. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and the card will be included if f(c, ...) returns true. Returns the group g.
---@param g Group
---@param f CardFilterFunction
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group
function Group.Remove(g, f, ex, ...) end

---Removes from (Group g) a card or group (Card|Group other). Returns the group itself. Equivalent to Group.Sub\
---@see Group.Sub
---@param g Group
---@param other Card|Group
---@return Group
function Group.RemoveCard(g, other) end

---	Gets the first card found in a group (Group g) which f(c, ...) returns true. Function f accepts at least one parameter (f(c, ...), with c as each member of the group), and must return a boolean.
---@param g Group
---@param f CardFilterFunction
---@param ... unknown
---@return Card
function Group.SearchCard(g, f, ...) end

---Makes a player (int player) select members of a group (Group g), with a minimum and a maximum, then outputs the result as a new Group. Excludes a card (Card ex) if it is not nil. If (bool cancelable) is true and the selection is canceled nil will be returned.
---@param g Group
---@param player Player
---@param min integer
---@param max integer
---@param cancelable boolean?
---@param ex CardFilterExclusion
---@return Group
function Group.Select(g, player, min, max, cancelable, ex) end

---Selects cards in a loop that allows unselection/cancellation. (Group g1) is the group of not selected cards, (Group g2) is the group of already selected cards, (int player) is the player who selects the card, (bool finishable) indicates that the current selection has met the requirements and thus can be finished with the right click, (bool cancelable) indicates that the selection can be canceled with the right click (in the procedures this is set when the selected group is empty and no chain is going on), (int max) and (int min) does nothing to the function, they are only the max and min values shown in the hint. Every card in both the groups can be selected. The function returns a single card
---@param g1 Group
---@param g2 Group
---@param player Player
---@param finishable boolean?
---@param cancelable boolean?
---@param min integer?
---@param max integer?
---@return Card
function Group.SelectUnselect(g1, g2, player, finishable, cancelable, min, max) end

---Returns 2 groups, the first group will contain cards matched with the same behaviour as Group.Filter, the second group will contain the remaining cards from the Group g.
---@param g Group
---@param f CardFilterFunction
---@param ex CardFilterExclusion
---@param ... unknown
---@return Group, Group
function Group.Split(g, f, ex, ...) end

---Removes from (Group g) a card or group (Card|Group other). Returns the group itself. Equivalent to Group.Remove\
---@see Group.Remove
---@param g1 Group
---@param g2 Card|Group
---@return Group
function Group.Sub(g1, g2) end

---	Returns the card at the index specified (int pos) in the group. Returns nil if the index is greater than the size of the group.
---@param g Group
---@param pos integer
---@return Card?
function Group.TakeatPos(g, pos) end

--#endregion

--#region Auxiliary

---@class aux
aux = {}

---Function that returns true
---@return boolean
function aux.TRUE() end

---Function that returns false
---@return boolean
function aux.FALSE() end

---Used in filters (with parameter (Card c)) to check a function and its (...) parameters
---@param f CardFilterFunction
---@param ... unknown
---@return CardFilterFunction
function aux.FilterBoolFunction(f, ...) end

---Used filter for the Fusion, Xyz, Synchro and Link Procedures where (function f) can be Card.IsRace, Card.IsAttribute and Card.IsType and (int value) corresponds to the required Race, Attribute and Type.
---@param f CardFilterFunction
---@param value any
---@return CardFilterFunction
function aux.FilterBoolFunctionEx(f, value) end

---Returns the description code using the database entry's code (int code) and from the nth position (int position) which can be 0-15 corresponding to the str in the database which are from str1 to str16
---@param code integer
---@param n integer
---@return integer
function aux.Stringid(code, n) end

--#endregion

--#region Fusion

---@class Fusion
Fusion = {}

---@alias FusionMaterialCardFilterFunction fun(c:Card, fc:Card, sumtype:SummonType, tp:Player, sub:boolean, mg:Group, sg:Group, contact: boolean)

---@alias FusionMaterialFilterFunction fun(tp: Player): Group
---@alias ContactFusionOperationFuction fun(mg: Group, tp: Player)
---@alias SummonLimitFilterFunction fun(e: Effect, c: Card, tp: Player, sumtype: SummonType, pos: BattlePosition, tgp: Player, re: Effect): boolean

---Adds a Contact Fusion Procedure to a Fusion monster which is a Summoning Procedure without having to use "Polymerization". (function group) is a function with (int tp) parameter which returns a Group of usable materials. (function op) is the operation that will be applied to the selected materials. (function sumcon) adds a limitation on a Fusion monster which applies to EFFECT_SPSUMMON_CONDITION. (function condition) is an additional condition to check. (int sumtype) is the Summon Type of the Contact Fusion, which defaults to 0. (int desc) is the description of the Summoning Procedure when selecting it.
---@param c Card
---@param group FusionMaterialFilterFunction
---@param op ContactFusionOperationFuction
---@param sumcon SummonLimitFilterFunction
---@param condition function|nil
---@param sumtype SummonType? default to 0
---@param desc integer?
---@param cannotBeLizard boolean
function Fusion.AddContactProc(c, group, op, sumcon, condition, sumtype, desc, cannotBeLizard) end

---Adds a Fusion Procedure where (bool sub) is a check if Fusion Substitutes are allowed. (bool insf) is a check if using no materials are allowed (e.g. Instant Fusion). (int|function ...) is a list of any number of codes/conditions as Fusion Materials. Member function from the Fusion namespace. Definition available in proc_fusion.lua.
---@param c Card
---@param sub boolean
---@param insf boolean
---@param ... integer|CardFilterFunction
---@return table?
function Fusion.AddProcMix(c, sub, insf, ...) end

---Adds a Fusion Procedure where (bool sub) is a check if Fusion Substitutes are allowed. (bool insf) is a check if using no materials are allowed (e.g. Instant Fusion). (int|function ...) is a list of any number of codes/conditions as Fusion Materials, by pairs wherein the first value is int/function which is the code or condition, and the second value is an int which corresponds to the number of fixed materials.
---@param c Card
---@param sub boolean
---@param insf boolean
---@param n integer
---@param ... integer|CardFilterFunction
function Fusion.AddProcMixN(c, sub, insf, n, ...) end

---Adds a Fusion Procedure where (bool sub) is a check if Fusion Substitutes are allowed. (bool insf) is a check if using no materials are allowed (e.g. Instant Fusion). (function fun1) is a condition for a Fusion Material with a minimum (int minc) and maximum (int maxc) and (int|function ...) is a list of any number of codes/conditions as Fusion Materials.
---@param c Card
---@param sub boolean
---@param insf boolean
---@param fun1 CardFilterFunction
---@param minc integer
---@param maxc integer
---@param ... integer|CardFilterFunction
function Fusion.AddProcMixRep(c, sub, insf, fun1, minc, maxc, ...) end

--#endregion

---filter
---@alias CardFilterFunction fun(c: Card, ...: unknown): boolean
---@alias CardFilterExclusion Group|Card|nil
---@alias CardToIntFunction fun(c: Card, ...: unknown): integer

---Generic condition callback.\
---e: Effect | owner effect;\
---tp: number | triggering player;\
---eg: Group | event group;\
---ep: number | event player;\
---ev: number | event value;\
---re: Effect | reason effect;\
---r: number | reason;\
---rp: number | reason player;\
---@alias ConditionFunction fun(e: Effect, tp: Player, eg: Group, ep: Player, ev: integer, re: Effect, r: Reason, rp: Player, ...: unknown): boolean

---@alias CostFunction fun(e: Effect, tp: Player, eg: Group, ep: Player, ev: integer, re: Effect, r: Reason, rp: Player, chk: integer, ...: unknown): boolean?


---@alias TargetFunction fun(e: Effect, tp: Player, eg: Group, ep: Player, ev: integer, re: Effect, r: Reason, rp: Player, chk: integer, ...: unknown): boolean?
---@alias OperationFunction fun(e: Effect, tp: Player, eg: Group, ep: Player, ev: integer, re: Effect, r: Reason, rp: Player, ...: unknown)

return Duel, Debug, Card, Effect, aux, Fusion