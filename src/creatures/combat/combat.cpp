/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "declarations.hpp"
#include "creatures/combat/combat.hpp"
#include "lua/creature/events.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "game/game.hpp"
#include "io/iobestiary.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "items/weapons/weapons.hpp"
#include "map/spectators.hpp"

int32_t Combat::getLevelFormula(std::shared_ptr<Player> player, const std::shared_ptr<Spell> wheelSpell, const CombatDamage &damage) const {
	if (!player) {
		return 0;
	}

	uint32_t magicLevelSkill = player->getMagicLevel();
	// Wheel of destiny - Runic Mastery
	if (player->wheel()->getInstant("Runic Mastery") && wheelSpell && damage.instantSpellName.empty() && normal_random(0, 100) <= 25) {
		const auto conjuringSpell = g_spells().getInstantSpellByName(damage.runeSpellName);
		if (conjuringSpell && conjuringSpell != wheelSpell) {
			uint32_t castResult = conjuringSpell->canCast(player) ? 20 : 10;
			magicLevelSkill += magicLevelSkill * castResult / 100;
		}
	}

	int32_t levelFormula = player->getLevel() * 2 + (player->getMagicLevel() + player->getSpecializedMagicLevel(damage.primary.type, true)) * 3;
	return levelFormula;
}

CombatDamage Combat::getCombatDamage(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const {
	CombatDamage damage;
	damage.origin = params.origin;
	damage.primary.type = params.combatType;

	damage.instantSpellName = instantSpellName;
	damage.runeSpellName = runeSpellName;
	// Wheel of destiny
	std::shared_ptr<Spell> wheelSpell = nullptr;
	std::shared_ptr<Player> attackerPlayer = creature ? creature->getPlayer() : nullptr;
	if (attackerPlayer) {
		wheelSpell = attackerPlayer->wheel()->getCombatDataSpell(damage);
	}
	// End
	if (formulaType == COMBAT_FORMULA_DAMAGE) {
		damage.primary.value = normal_random(
			static_cast<int32_t>(mina),
			static_cast<int32_t>(maxa)
		);
	} else if (creature) {
		int32_t min, max;
		if (creature->getCombatValues(min, max)) {
			damage.primary.value = normal_random(min, max);
		} else if (std::shared_ptr<Player> player = creature->getPlayer()) {
			if (params.valueCallback) {
				params.valueCallback->getMinMaxValues(player, damage, params.useCharges);
			} else if (formulaType == COMBAT_FORMULA_LEVELMAGIC) {
				int32_t levelFormula = getLevelFormula(player, wheelSpell, damage);
				damage.primary.value = normal_random(
					static_cast<int32_t>(levelFormula * mina + minb),
					static_cast<int32_t>(levelFormula * maxa + maxb)
				);
			} else if (formulaType == COMBAT_FORMULA_SKILL) {
				std::shared_ptr<Item> tool = player->getWeapon();
				const WeaponShared_ptr weapon = g_weapons().getWeapon(tool);
				if (weapon) {
					damage.primary.value = normal_random(
						static_cast<int32_t>(minb),
						static_cast<int32_t>(weapon->getWeaponDamage(player, target, tool, true) * maxa + maxb)
					);

					damage.secondary.type = weapon->getElementType();
					damage.secondary.value = weapon->getElementDamage(player, target, tool);
					if (params.useCharges) {
						auto charges = tool->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
						if (charges != 0) {
							g_game().transformItem(tool, tool->getID(), charges - 1);
						}
					}
				} else {
					damage.primary.value = normal_random(
						static_cast<int32_t>(minb),
						static_cast<int32_t>(maxb)
					);
				}
			}
		}
	}
	return damage;
}

void Combat::getCombatArea(const Position &centerPos, const Position &targetPos, const std::unique_ptr<AreaCombat> &area, std::forward_list<std::shared_ptr<Tile>> &list) {
	if (targetPos.z >= MAP_MAX_LAYERS) {
		return;
	}

	if (area) {
		area->getList(centerPos, targetPos, list);
	} else {
		list.push_front(g_game().map.getOrCreateTile(targetPos));
	}
}

CombatType_t Combat::ConditionToDamageType(ConditionType_t type) {
	switch (type) {
		case CONDITION_FIRE:
			return COMBAT_FIREDAMAGE;

		case CONDITION_ENERGY:
			return COMBAT_ENERGYDAMAGE;

		case CONDITION_BLEEDING:
			return COMBAT_PHYSICALDAMAGE;

		case CONDITION_DROWN:
			return COMBAT_DROWNDAMAGE;

		case CONDITION_POISON:
			return COMBAT_EARTHDAMAGE;

		case CONDITION_FREEZING:
			return COMBAT_ICEDAMAGE;

		case CONDITION_DAZZLED:
			return COMBAT_HOLYDAMAGE;

		case CONDITION_CURSED:
			return COMBAT_DEATHDAMAGE;

		default:
			break;
	}

	return COMBAT_NONE;
}

ConditionType_t Combat::DamageToConditionType(CombatType_t type) {
	switch (type) {
		case COMBAT_FIREDAMAGE:
			return CONDITION_FIRE;

		case COMBAT_ENERGYDAMAGE:
			return CONDITION_ENERGY;

		case COMBAT_DROWNDAMAGE:
			return CONDITION_DROWN;

		case COMBAT_EARTHDAMAGE:
			return CONDITION_POISON;

		case COMBAT_ICEDAMAGE:
			return CONDITION_FREEZING;

		case COMBAT_HOLYDAMAGE:
			return CONDITION_DAZZLED;

		case COMBAT_DEATHDAMAGE:
			return CONDITION_CURSED;

		case COMBAT_PHYSICALDAMAGE:
			return CONDITION_BLEEDING;

		default:
			return CONDITION_NONE;
	}
}

bool Combat::isPlayerCombat(std::shared_ptr<Creature> target) {
	if (target->getPlayer()) {
		return true;
	}

	if (target->isSummon() && target->getMaster()->getPlayer()) {
		return true;
	}

	return false;
}

ReturnValue Combat::canTargetCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> target) {
	if (player == target) {
		return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
	}

	if (!player->hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
		// pz-zone
		if (player->getZoneType() == ZONE_PROTECTION) {
			return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
		}

		if (target->getZoneType() == ZONE_PROTECTION) {
			return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
		}

		// nopvp-zone
		if (isPlayerCombat(target)) {
			if (player->getZoneType() == ZONE_NOPVP) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			}

			if (target->getZoneType() == ZONE_NOPVP) {
				return RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE;
			}
		}
	}

	if (player->hasFlag(PlayerFlags_t::CannotUseCombat) || !target->isAttackable()) {
		if (target->getPlayer()) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		} else {
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
		}
	}

	if (target->getPlayer()) {
		if (isProtected(player, target->getPlayer())) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		}

		if (player->hasSecureMode() && !Combat::isInPvpZone(player, target) && player->getSkullClient(target->getPlayer()) == SKULL_NONE) {
			return RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS;
		}
	}

	return Combat::canDoCombat(player, target, true);
}

ReturnValue Combat::canDoCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Tile> tile, bool aggressive) {
	if (tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
		return RETURNVALUE_NOTENOUGHROOM;
	}
	if (aggressive && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
	}

	if (tile->hasFlag(TILESTATE_FLOORCHANGE)) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (tile->getTeleportItem()) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (caster) {
		const Position &casterPosition = caster->getPosition();
		const Position &tilePosition = tile->getPosition();
		if (casterPosition.z < tilePosition.z) {
			return RETURNVALUE_FIRSTGODOWNSTAIRS;
		} else if (casterPosition.z > tilePosition.z) {
			return RETURNVALUE_FIRSTGOUPSTAIRS;
		}

		if (std::shared_ptr<Player> player = caster->getPlayer()) {
			if (player->hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
				return RETURNVALUE_NOERROR;
			}
		}
	}

	return g_events().eventCreatureOnAreaCombat(caster, tile, aggressive);
}

bool Combat::isInPvpZone(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target) {
	return attacker->getZoneType() == ZONE_PVP && target->getZoneType() == ZONE_PVP;
}

bool Combat::isProtected(std::shared_ptr<Player> attacker, std::shared_ptr<Player> target) {
	uint32_t protectionLevel = g_configManager().getNumber(PROTECTION_LEVEL, __FUNCTION__);
	if (target->getLevel() < protectionLevel || attacker->getLevel() < protectionLevel) {
		return true;
	}

	if (!attacker->getVocation()->canCombat() || !target->getVocation()->canCombat() && (attacker->getVocationId() == VOCATION_NONE || target->getVocationId() == VOCATION_NONE)) {
		return true;
	}

	if (attacker->getSkull() == SKULL_BLACK && attacker->getSkullClient(target) == SKULL_NONE) {
		return true;
	}

	return false;
}

ReturnValue Combat::canDoCombat(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target, bool aggressive) {
	if (!aggressive) {
		return RETURNVALUE_NOERROR;
	}

	auto targetPlayer = target ? target->getPlayer() : nullptr;
	if (target) {
		std::shared_ptr<Tile> tile = target->getTile();
		if (tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
			return RETURNVALUE_NOTENOUGHROOM;
		}
		if (tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
			auto permittedOnPz = targetPlayer ? targetPlayer->hasPermittedConditionInPZ() : false;
			return permittedOnPz ? RETURNVALUE_NOERROR : RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
		}
	}

	if (attacker) {
		const std::shared_ptr<Creature> attackerMaster = attacker->getMaster();
		if (targetPlayer) {
			if (targetPlayer->hasFlag(PlayerFlags_t::CannotBeAttacked)) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
			}

			const std::shared_ptr<Tile> targetPlayerTile = targetPlayer->getTile();

			if (const std::shared_ptr<Player> attackerPlayer = attacker->getPlayer()) {
				if (attackerPlayer->hasFlag(PlayerFlags_t::CannotAttackPlayer)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}

				if (isProtected(attackerPlayer, targetPlayer)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}

				// nopvp-zone
				auto attackerTile = attackerPlayer->getTile();
				if (targetPlayerTile && targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE)) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				} else if (attackerTile && attackerTile->hasFlag(TILESTATE_NOPVPZONE) && targetPlayerTile && !targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE | TILESTATE_PROTECTIONZONE)) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				}

				if (attackerPlayer->getFaction() != FACTION_DEFAULT && attackerPlayer->getFaction() != FACTION_PLAYER && attackerPlayer->getFaction() == targetPlayer->getFaction()) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}
			}

			if (attackerMaster) {
				if (const std::shared_ptr<Player> masterAttackerPlayer = attackerMaster->getPlayer()) {
					if (masterAttackerPlayer->hasFlag(PlayerFlags_t::CannotAttackPlayer)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}

					if (targetPlayerTile && targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE)) {
						return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
					}

					if (isProtected(masterAttackerPlayer, targetPlayer)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}
				}
			}

			if (attacker->getMonster() && (!attackerMaster || attackerMaster->getMonster())) {
				if (attacker->getFaction() != FACTION_DEFAULT && !attacker->getMonster()->isEnemyFaction(targetPlayer->getFaction())) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}
			}
		} else if (target && target->getMonster()) {
			if (attacker->getFaction() != FACTION_DEFAULT && attacker->getFaction() != FACTION_PLAYER && attacker->getMonster() && !attacker->getMonster()->isEnemyFaction(target->getFaction())) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
			}

			if (const std::shared_ptr<Player> attackerPlayer = attacker->getPlayer()) {
				if (attackerPlayer->hasFlag(PlayerFlags_t::CannotAttackMonster)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
				}

				if (target->isSummon() && target->getMaster()->getPlayer() && target->getZoneType() == ZONE_NOPVP) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				}
			} else if (attacker->getMonster()) {
				const std::shared_ptr<Creature> targetMaster = target->getMaster();

				if ((!targetMaster || !targetMaster->getPlayer()) && attacker->getFaction() == FACTION_DEFAULT) {
					if (!attackerMaster || !attackerMaster->getPlayer()) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
					}
				}
			}
		} else if (target && target->getNpc()) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
		}

		if (g_game().getWorldType() == WORLD_TYPE_NO_PVP) {
			if (attacker->getPlayer() || (attackerMaster && attackerMaster->getPlayer())) {
				if (targetPlayer) {
					if (!isInPvpZone(attacker, target)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}
				}

				if (target && target->isSummon() && target->getMaster()->getPlayer()) {
					if (!isInPvpZone(attacker, target)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
					}
				}
			}
		}
	}
	return g_events().eventCreatureOnTargetCombat(attacker, target);
}

void Combat::setPlayerCombatValues(formulaType_t newFormulaType, double newMina, double newMinb, double newMaxa, double newMaxb) {
	this->formulaType = newFormulaType;
	this->mina = newMina;
	this->minb = newMinb;
	this->maxa = newMaxa;
	this->maxb = newMaxb;
}

bool Combat::setParam(CombatParam_t param, uint32_t value) {
	switch (param) {
		case COMBAT_PARAM_TYPE: {
			params.combatType = static_cast<CombatType_t>(value);
			return true;
		}

		case COMBAT_PARAM_EFFECT: {
			params.impactEffect = static_cast<uint16_t>(value);
			return true;
		}

		case COMBAT_PARAM_DISTANCEEFFECT: {
			params.distanceEffect = static_cast<uint16_t>(value);
			return true;
		}

		case COMBAT_PARAM_BLOCKARMOR: {
			params.blockedByArmor = (value != 0);
			return true;
		}

		case COMBAT_PARAM_BLOCKSHIELD: {
			params.blockedByShield = (value != 0);
			return true;
		}

		case COMBAT_PARAM_TARGETCASTERORTOPMOST: {
			params.targetCasterOrTopMost = (value != 0);
			return true;
		}

		case COMBAT_PARAM_CREATEITEM: {
			params.itemId = value;
			return true;
		}

		case COMBAT_PARAM_AGGRESSIVE: {
			params.aggressive = (value != 0);
			return true;
		}

		case COMBAT_PARAM_DISPEL: {
			params.dispelType = static_cast<ConditionType_t>(value);
			return true;
		}

		case COMBAT_PARAM_USECHARGES: {
			params.useCharges = (value != 0);
			return true;
		}

		case COMBAT_PARAM_IMPACTSOUND: {
			params.soundImpactEffect = static_cast<SoundEffect_t>(value);
			return true;
		}

		case COMBAT_PARAM_CASTSOUND: {
			params.soundCastEffect = static_cast<SoundEffect_t>(value);
			return true;
		}

		case COMBAT_PARAM_CHAIN_EFFECT: {
			params.chainEffect = static_cast<uint8_t>(value);
			return true;
		}
	}
	return false;
}

bool Combat::setCallback(CallBackParam_t key) {
	switch (key) {
		case CALLBACK_PARAM_LEVELMAGICVALUE: {
			params.valueCallback = std::make_unique<ValueCallback>(COMBAT_FORMULA_LEVELMAGIC);
			return true;
		}

		case CALLBACK_PARAM_SKILLVALUE: {
			params.valueCallback = std::make_unique<ValueCallback>(COMBAT_FORMULA_SKILL);
			return true;
		}

		case CALLBACK_PARAM_TARGETTILE: {
			params.tileCallback = std::make_unique<TileCallback>();
			return true;
		}

		case CALLBACK_PARAM_TARGETCREATURE: {
			params.targetCallback = std::make_unique<TargetCallback>();
			return true;
		}

		case CALLBACK_PARAM_CHAINVALUE: {
			params.chainCallback = std::make_unique<ChainCallback>();
			return true;
		}

		case CALLBACK_PARAM_CHAINPICKER: {
			params.chainPickerCallback = std::make_unique<ChainPickerCallback>();
			return true;
		}
	}
	return false;
}

CallBack* Combat::getCallback(CallBackParam_t key) {
	switch (key) {
		case CALLBACK_PARAM_LEVELMAGICVALUE:
		case CALLBACK_PARAM_SKILLVALUE: {
			return params.valueCallback.get();
		}

		case CALLBACK_PARAM_TARGETTILE: {
			return params.tileCallback.get();
		}

		case CALLBACK_PARAM_TARGETCREATURE: {
			return params.targetCallback.get();
		}

		case CALLBACK_PARAM_CHAINVALUE: {
			return params.chainCallback.get();
		}

		case CALLBACK_PARAM_CHAINPICKER: {
			return params.chainPickerCallback.get();
		}
	}
	return nullptr;
}

void Combat::CombatHealthFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data) {
	assert(data);
	CombatDamage damage = *data;

	std::shared_ptr<Player> attackerPlayer = nullptr;
	if (caster) {
		attackerPlayer = caster->getPlayer();
	}

	std::shared_ptr<Monster> targetMonster = nullptr;
	if (target) {
		targetMonster = target->getMonster();
	}

	std::shared_ptr<Monster> attackerMonster = nullptr;
	if (caster) {
		attackerMonster = caster->getMonster();
	}

	std::shared_ptr<Player> targetPlayer = nullptr;
	if (target) {
		targetPlayer = target->getPlayer();
	}

	if (attackerPlayer) {
		std::shared_ptr<Item> item = attackerPlayer->getWeapon();
		damage = applyImbuementElementalDamage(attackerPlayer, item, damage);
		g_events().eventPlayerOnCombat(attackerPlayer, target, item, damage);

		if (targetPlayer && targetPlayer->getSkull() != SKULL_BLACK) {
			if (damage.primary.type != COMBAT_HEALING) {
				damage.primary.value /= 2;
			}
			if (damage.secondary.type != COMBAT_HEALING) {
				damage.secondary.value /= 2;
			}
		}

		damage.damageMultiplier += attackerPlayer->wheel()->getMajorStatConditional("Divine Empowerment", WheelMajor_t::DAMAGE);
		g_logger().debug("Wheel Divine Empowerment damage multiplier {}", damage.damageMultiplier);
	}

	if (g_game().combatBlockHit(damage, caster, target, params.blockedByShield, params.blockedByArmor, params.itemId != 0)) {
		return;
	}

	// Player attacking monster
	if (attackerPlayer && targetMonster) {
		const std::unique_ptr<PreySlot> &slot = attackerPlayer->getPreyWithMonster(targetMonster->getRaceId());
		if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Damage && slot->bonusTimeLeft > 0) {
			damage.primary.value += static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
			damage.secondary.value += static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
		}
	}

	// Monster attacking player
	if (attackerMonster && targetPlayer) {
		const std::unique_ptr<PreySlot> &slot = targetPlayer->getPreyWithMonster(attackerMonster->getRaceId());
		if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Defense && slot->bonusTimeLeft > 0) {
			damage.primary.value -= static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
			damage.secondary.value -= static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
		}
	}

	if (g_game().combatChangeHealth(caster, target, damage)) {
		CombatConditionFunc(caster, target, params, &damage);
		CombatDispelFunc(caster, target, params, nullptr);
	}
}

CombatDamage Combat::applyImbuementElementalDamage(std::shared_ptr<Player> attackerPlayer, std::shared_ptr<Item> item, CombatDamage damage) {
	if (!item) {
		return damage;
	}

	if (item->getWeaponType() == WEAPON_AMMO && attackerPlayer && attackerPlayer->getInventoryItem(CONST_SLOT_LEFT) != nullptr) {
		item = attackerPlayer->getInventoryItem(CONST_SLOT_LEFT);
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		if (imbuementInfo.imbuement->combatType == COMBAT_NONE
			|| damage.primary.type == COMBAT_HEALING
			|| damage.secondary.type == COMBAT_HEALING) {
			continue;
		}

		float damagePercent = imbuementInfo.imbuement->elementDamage / 100.0;

		damage.secondary.type = imbuementInfo.imbuement->combatType;
		damage.secondary.value = damage.primary.value * (damagePercent);
		damage.primary.value = damage.primary.value * (1 - damagePercent);

		if (imbuementInfo.imbuement->soundEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(item->getPosition(), imbuementInfo.imbuement->soundEffect, item->getHoldingPlayer());
		}

		// If damage imbuement is set, we can return without checking other slots
		break;
	}

	return damage;
}

void Combat::CombatManaFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data) {
	assert(data);
	CombatDamage damage = *data;
	if (damage.primary.value < 0) {
		if (caster && target && caster->getPlayer() && target->getSkull() != SKULL_BLACK && target->getPlayer()) {
			damage.primary.value /= 2;
		}
	}
	if (g_game().combatChangeMana(caster, target, damage)) {
		CombatConditionFunc(caster, target, params, nullptr);
		CombatDispelFunc(caster, target, params, nullptr);
	}
}

bool Combat::checkFearConditionAffected(std::shared_ptr<Player> player) {
	if (player->isImmuneFear()) {
		return false;
	}

	if (player->hasCondition(CONDITION_FEARED)) {
		return false;
	}

	auto party = player->getParty();
	if (party) {
		auto affectedCount = (party->getMemberCount() + 5) / 5;
		g_logger().debug("[{}] Player is member of a party, {} members can be feared", __FUNCTION__, affectedCount);

		for (const auto member : party->getMembers()) {
			if (member->hasCondition(CONDITION_FEARED)) {
				affectedCount -= 1;
			}
		}

		if (affectedCount <= 0) {
			return false;
		}
	}

	return true;
}

void Combat::CombatConditionFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage* data) {
	if (params.origin == ORIGIN_MELEE && data && data->primary.value == 0 && data->secondary.value == 0) {
		return;
	}

	for (const auto &condition : params.conditionList) {
		std::shared_ptr<Player> player = nullptr;
		if (target) {
			player = target->getPlayer();
		}
		if (player) {
			// Cleanse charm rune (target as player)
			if (player->isImmuneCleanse(condition->getType())) {
				player->sendCancelMessage("You are still immune against this spell.");
				return;
			} else if (caster && caster->getMonster()) {
				uint16_t playerCharmRaceid = player->parseRacebyCharm(CHARM_CLEANSE, false, 0);
				if (playerCharmRaceid != 0) {
					const auto mType = g_monsters().getMonsterType(caster->getName());
					if (mType && playerCharmRaceid == mType->info.raceid) {
						const auto charm = g_iobestiary().getBestiaryCharm(CHARM_CLEANSE);
						if (charm && (charm->chance > normal_random(0, 100))) {
							if (player->hasCondition(condition->getType())) {
								player->removeCondition(condition->getType());
							}
							player->setImmuneCleanse(condition->getType());
							player->sendCancelMessage(charm->cancelMsg);
							return;
						}
					}
				}
			}

			if (condition->getType() == CONDITION_FEARED && !checkFearConditionAffected(player)) {
				return;
			}
		}

		if (caster == target || target && !target->isImmune(condition->getType())) {
			auto conditionCopy = condition->clone();
			if (caster) {
				conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
				conditionCopy->setPositionParam(CONDITION_PARAM_CASTER_POSITION, caster->getPosition());
			}

			// TODO: infight condition until all aggressive conditions has ended
			if (target) {
				target->addCombatCondition(conditionCopy);
			}
		}
	}
}

void Combat::CombatDispelFunc(std::shared_ptr<Creature>, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage*) {
	if (target) {
		target->removeCombatCondition(params.dispelType);
	}
}

void Combat::CombatNullFunc(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params, CombatDamage*) {
	CombatConditionFunc(caster, target, params, nullptr);
	CombatDispelFunc(caster, target, params, nullptr);
}

void Combat::combatTileEffects(const CreatureVector &spectators, std::shared_ptr<Creature> caster, std::shared_ptr<Tile> tile, const CombatParams &params) {
	if (params.itemId != 0) {
		uint16_t itemId = params.itemId;
		switch (itemId) {
			case ITEM_FIREFIELD_PERSISTENT_FULL:
				itemId = ITEM_FIREFIELD_PVP_FULL;
				break;

			case ITEM_FIREFIELD_PERSISTENT_MEDIUM:
				itemId = ITEM_FIREFIELD_PVP_MEDIUM;
				break;

			case ITEM_FIREFIELD_PERSISTENT_SMALL:
				itemId = ITEM_FIREFIELD_PVP_SMALL;
				break;

			case ITEM_ENERGYFIELD_PERSISTENT:
				itemId = ITEM_ENERGYFIELD_PVP;
				break;

			case ITEM_POISONFIELD_PERSISTENT:
				itemId = ITEM_POISONFIELD_PVP;
				break;

			case ITEM_MAGICWALL_PERSISTENT:
				itemId = ITEM_MAGICWALL;
				break;

			case ITEM_WILDGROWTH_PERSISTENT:
				itemId = ITEM_WILDGROWTH;
				break;

			default:
				break;
		}

		if (caster) {
			std::shared_ptr<Player> casterPlayer;
			if (caster->isSummon()) {
				casterPlayer = caster->getMaster()->getPlayer();
			} else {
				casterPlayer = caster->getPlayer();
			}

			if (casterPlayer) {
				if (g_game().getWorldType() == WORLD_TYPE_NO_PVP || tile->hasFlag(TILESTATE_NOPVPZONE)) {
					if (itemId == ITEM_FIREFIELD_PVP_FULL) {
						itemId = ITEM_FIREFIELD_NOPVP;
					} else if (itemId == ITEM_POISONFIELD_PVP) {
						itemId = ITEM_POISONFIELD_NOPVP;
					} else if (itemId == ITEM_ENERGYFIELD_PVP) {
						itemId = ITEM_ENERGYFIELD_NOPVP;
					} else if (itemId == ITEM_MAGICWALL) {
						itemId = ITEM_MAGICWALL_SAFE;
					} else if (itemId == ITEM_WILDGROWTH) {
						itemId = ITEM_WILDGROWTH_SAFE;
					}
				} else if (itemId == ITEM_FIREFIELD_PVP_FULL || itemId == ITEM_POISONFIELD_PVP || itemId == ITEM_ENERGYFIELD_PVP || itemId == ITEM_MAGICWALL || itemId == ITEM_WILDGROWTH) {
					casterPlayer->addInFightTicks();
				}
			}
		}

		std::shared_ptr<Item> item = Item::CreateItem(itemId);
		if (caster) {
			item->setAttribute(ItemAttribute_t::OWNER, caster->getID());
		}

		ReturnValue ret = g_game().internalAddItem(tile, item);
		if (ret == RETURNVALUE_NOERROR) {
			item->startDecaying();
		}
	}

	if (params.tileCallback) {
		params.tileCallback->onTileCombat(caster, tile);
	}

	if (params.impactEffect != CONST_ME_NONE) {
		Game::addMagicEffect(spectators, tile->getPosition(), params.impactEffect);
	}

	if (params.soundImpactEffect != SoundEffect_t::SILENCE) {
		g_game().sendDoubleSoundEffect(tile->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
	} else if (params.soundCastEffect != SoundEffect_t::SILENCE) {
		g_game().sendSingleSoundEffect(tile->getPosition(), params.soundCastEffect, caster);
	}
}

void Combat::postCombatEffects(std::shared_ptr<Creature> caster, const Position &origin, const Position &pos, const CombatParams &params) {
	if (caster && params.distanceEffect != CONST_ANI_NONE) {
		addDistanceEffect(caster, origin, pos, params.distanceEffect);
	}

	if (params.soundImpactEffect != SoundEffect_t::SILENCE) {
		g_game().sendDoubleSoundEffect(pos, params.soundCastEffect, params.soundImpactEffect, caster);
	} else if (params.soundCastEffect != SoundEffect_t::SILENCE) {
		g_game().sendSingleSoundEffect(pos, params.soundCastEffect, caster);
	}
}

void Combat::addDistanceEffect(std::shared_ptr<Creature> caster, const Position &fromPos, const Position &toPos, uint16_t effect) {
	if (effect == CONST_ANI_WEAPONTYPE) {
		if (!caster) {
			return;
		}

		std::shared_ptr<Player> player = caster->getPlayer();
		if (!player) {
			return;
		}

		switch (player->getWeaponType()) {
			case WEAPON_AXE:
				effect = CONST_ANI_WHIRLWINDAXE;
				break;
			case WEAPON_SWORD:
				effect = CONST_ANI_WHIRLWINDSWORD;
				break;
			case WEAPON_CLUB:
				effect = CONST_ANI_WHIRLWINDCLUB;
				break;
			case WEAPON_MISSILE: {
				auto weapon = player->getWeapon();
				if (weapon) {
					const auto &iType = Item::items[weapon->getID()];
					effect = iType.shootType;
				}
				break;
			}
			default:
				effect = CONST_ANI_NONE;
				break;
		}
	}

	if (effect != CONST_ANI_NONE) {
		g_game().addDistanceEffect(fromPos, toPos, effect);
	}
}

void Combat::doChainEffect(const Position &origin, const Position &dest, uint8_t effect) {
	if (effect > 0) {
		stdext::arraylist<Direction> dirList(128);
		FindPathParams fpp;
		fpp.minTargetDist = 0;
		fpp.maxTargetDist = 1;
		fpp.maxSearchDist = 9;
		Position pos = origin;
		if (g_game().map.getPathMatching(origin, dirList, FrozenPathingConditionCall(dest), fpp)) {
			for (auto dir : dirList) {
				pos = getNextPosition(dir, pos);
				g_game().addMagicEffect(pos, effect);
			}
		}
		g_game().addMagicEffect(dest, effect);
	}
}

bool Combat::doCombatChain(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, bool aggressive) const {
	if (!params.chainCallback) {
		return false;
	}

	uint8_t maxTargets;
	uint8_t chainDistance;
	bool backtracking = false;
	params.chainCallback->onChainCombat(caster, maxTargets, chainDistance, backtracking);
	auto targets = pickChainTargets(caster, params, chainDistance, maxTargets, backtracking, aggressive, target);

	g_logger().debug("[{}] Chain targets: {}", __FUNCTION__, targets.size());
	if (targets.empty() || targets.size() == 1 && targets.begin()->second.empty()) {
		return false;
	}

	for (const auto &[from, toVector] : targets) {
		auto combat = this;
		for (auto to : toVector) {
			auto nextTarget = g_game().getCreatureByID(to);
			if (!nextTarget) {
				continue;
			}
			combat->doChainEffect(from, nextTarget->getPosition(), combat->params.chainEffect);
			combat->doCombat(caster, nextTarget, from);
		}
	}

	return true;
}

bool Combat::doCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target) const {
	if (caster != nullptr && params.chainCallback) {
		return doCombatChain(caster, target, params.aggressive);
	}

	return doCombat(caster, target, caster != nullptr ? caster->getPosition() : Position());
}

bool Combat::doCombat(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin) const {
	// target combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, target);
		if (damage.primary.type != COMBAT_MANADRAIN) {
			doCombatHealth(caster, target, origin, damage, params);
		} else {
			doCombatMana(caster, target, origin, damage, params);
		}
	} else {
		doCombatDefault(caster, target, origin, params);
	}

	return true;
}

bool Combat::doCombat(std::shared_ptr<Creature> caster, const Position &position) const {
	if (caster != nullptr && params.chainCallback) {
		return doCombatChain(caster, caster, params.aggressive);
	}

	// area combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, nullptr);
		if (damage.primary.type != COMBAT_MANADRAIN) {
			doCombatHealth(caster, position, area, damage, params);
		} else {
			doCombatMana(caster, position, area, damage, params);
		}
	} else {
		auto origin = caster != nullptr ? caster->getPosition() : Position();
		CombatFunc(caster, origin, position, area, params, CombatNullFunc, nullptr);
	}

	return true;
}

void Combat::CombatFunc(std::shared_ptr<Creature> caster, const Position &origin, const Position &pos, const std::unique_ptr<AreaCombat> &area, const CombatParams &params, CombatFunction func, CombatDamage* data) {
	std::forward_list<std::shared_ptr<Tile>> tileList;

	if (caster) {
		getCombatArea(caster->getPosition(), pos, area, tileList);
	} else {
		getCombatArea(pos, pos, area, tileList);
	}

	uint32_t maxX = 0;
	uint32_t maxY = 0;

	// calculate the max viewable range
	for (std::shared_ptr<Tile> tile : tileList) {
		const Position &tilePos = tile->getPosition();

		uint32_t diff = Position::getDistanceX(tilePos, pos);
		if (diff > maxX) {
			maxX = diff;
		}

		diff = Position::getDistanceY(tilePos, pos);
		if (diff > maxY) {
			maxY = diff;
		}
	}

	const int32_t rangeX = maxX + MAP_MAX_VIEW_PORT_X;
	const int32_t rangeY = maxY + MAP_MAX_VIEW_PORT_Y;

	int affected = 0;
	for (std::shared_ptr<Tile> tile : tileList) {
		if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
			continue;
		}

		if (CreatureVector* creatures = tile->getCreatures()) {
			const std::shared_ptr<Creature> topCreature = tile->getTopCreature();
			for (auto &creature : *creatures) {
				if (params.targetCasterOrTopMost) {
					if (caster && caster->getTile() == tile) {
						if (creature != caster) {
							continue;
						}
					} else if (creature != topCreature) {
						continue;
					}
				}

				if (!params.aggressive || (caster != creature && Combat::canDoCombat(caster, creature, params.aggressive) == RETURNVALUE_NOERROR)) {
					affected++;
				}
			}
		}
	}

	CombatDamage tmpDamage;
	if (data) {
		tmpDamage.origin = data->origin;
		tmpDamage.primary.type = data->primary.type;
		tmpDamage.primary.value = data->primary.value;
		tmpDamage.secondary.type = data->secondary.type;
		tmpDamage.secondary.value = data->secondary.value;
		tmpDamage.critical = data->critical;
		tmpDamage.fatal = data->fatal;
		tmpDamage.criticalDamage = data->criticalDamage;
		tmpDamage.criticalChance = data->criticalChance;
		tmpDamage.damageMultiplier = data->damageMultiplier;
		tmpDamage.damageReductionMultiplier = data->damageReductionMultiplier;
		tmpDamage.healingMultiplier = data->healingMultiplier;
		tmpDamage.manaLeech = data->manaLeech;
		tmpDamage.lifeLeech = data->lifeLeech;
		tmpDamage.healingLink = data->healingLink;
		tmpDamage.instantSpellName = data->instantSpellName;
		tmpDamage.runeSpellName = data->runeSpellName;
		tmpDamage.lifeLeechChance = data->lifeLeechChance;
		tmpDamage.manaLeechChance = data->manaLeechChance;
	}

	// Wheel of destiny get beam affected total
	auto spectators = Spectators().find<Player>(pos, true, rangeX, rangeX, rangeY, rangeY);
	std::shared_ptr<Player> casterPlayer = caster ? caster->getPlayer() : nullptr;
	uint8_t beamAffectedTotal = casterPlayer ? casterPlayer->wheel()->getBeamAffectedTotal(tmpDamage) : 0;
	uint8_t beamAffectedCurrent = 0;

	tmpDamage.affected = affected;
	for (std::shared_ptr<Tile> tile : tileList) {
		if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
			continue;
		}

		if (CreatureVector* creatures = tile->getCreatures()) {
			const std::shared_ptr<Creature> topCreature = tile->getTopCreature();
			for (auto &creature : *creatures) {
				if (params.targetCasterOrTopMost) {
					if (caster && caster->getTile() == tile) {
						if (creature != caster) {
							continue;
						}
					} else if (creature != topCreature) {
						continue;
					}
				}

				if (!params.aggressive || (caster != creature && Combat::canDoCombat(caster, creature, params.aggressive) == RETURNVALUE_NOERROR)) {
					// Wheel of destiny update beam mastery damage
					if (casterPlayer) {
						casterPlayer->wheel()->updateBeamMasteryDamage(tmpDamage, beamAffectedTotal, beamAffectedCurrent);
					}
					func(caster, creature, params, &tmpDamage);
					if (params.targetCallback) {
						params.targetCallback->onTargetCombat(caster, creature);
					}

					if (params.targetCasterOrTopMost) {
						break;
					}
				}
			}
		}
		combatTileEffects(spectators.data(), caster, tile, params);
	}

	// Wheel of destiny update beam mastery damage
	if (casterPlayer) {
		casterPlayer->wheel()->updateBeamMasteryDamage(tmpDamage, beamAffectedTotal, beamAffectedCurrent);
	}

	postCombatEffects(caster, origin, pos, params);
}

void Combat::doCombatHealth(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params) {
	doCombatHealth(caster, target, caster ? caster->getPosition() : Position(), damage, params);
}

void Combat::doCombatHealth(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, CombatDamage &damage, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target, params.aggressive) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (target && params.combatType == COMBAT_HEALING && target->getMonster()) {
		if (target != caster) {
			return;
		}
	}

	applyExtensions(caster, target, damage, params);

	if (canCombat) {
		if (target && caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, origin, target->getPosition(), params.distanceEffect);
		}

		CombatHealthFunc(caster, target, params, &damage);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		if (target && params.soundImpactEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(target->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
		} else if (target && params.soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(target->getPosition(), params.soundCastEffect, caster);
		}
	}
}

void Combat::doCombatHealth(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params) {
	applyExtensions(caster, nullptr, damage, params);
	const auto origin = caster ? caster->getPosition() : Position();
	CombatFunc(caster, origin, position, area, params, CombatHealthFunc, &damage);
}

void Combat::doCombatMana(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params) {
	doCombatMana(caster, target, caster ? caster->getPosition() : Position(), damage, params);
}

void Combat::doCombatMana(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, CombatDamage &damage, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target, params.aggressive) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	applyExtensions(caster, target, damage, params);

	if (canCombat) {
		if (caster && target && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, origin, target->getPosition(), params.distanceEffect);
		}

		CombatManaFunc(caster, target, params, &damage);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		if (target && params.soundImpactEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(target->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
		} else if (target && params.soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(target->getPosition(), params.soundCastEffect, caster);
		}
	}
}

void Combat::doCombatMana(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, CombatDamage &damage, const CombatParams &params) {
	applyExtensions(caster, nullptr, damage, params);
	const auto origin = caster ? caster->getPosition() : Position();
	CombatFunc(caster, origin, position, area, params, CombatManaFunc, &damage);
}

void Combat::doCombatCondition(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params) {
	const auto origin = caster ? caster->getPosition() : Position();
	CombatFunc(caster, origin, position, area, params, CombatConditionFunc, nullptr);
}

void Combat::doCombatCondition(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target, params.aggressive) == RETURNVALUE_NOERROR);
	if ((caster == target || canCombat) && params.impactEffect != CONST_ME_NONE) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (canCombat) {
		if (caster && target && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}

		CombatConditionFunc(caster, target, params, nullptr);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		if (target && params.soundImpactEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(target->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
		} else if (target && params.soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(target->getPosition(), params.soundCastEffect, caster);
		}
	}
}

void Combat::doCombatDispel(std::shared_ptr<Creature> caster, const Position &position, const std::unique_ptr<AreaCombat> &area, const CombatParams &params) {
	const auto origin = caster ? caster->getPosition() : Position();
	CombatFunc(caster, origin, position, area, params, CombatDispelFunc, nullptr);
}

void Combat::doCombatDispel(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target, params.aggressive) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (canCombat) {
		CombatDispelFunc(caster, target, params, nullptr);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		if (target && caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}

		if (target && params.soundImpactEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(target->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
		} else if (target && params.soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(target->getPosition(), params.soundCastEffect, caster);
		}
	}
}

void Combat::doCombatDefault(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const CombatParams &params) {
	doCombatDefault(caster, target, caster ? caster->getPosition() : Position(), params);
}

void Combat::doCombatDefault(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, const Position &origin, const CombatParams &params) {
	if (!params.aggressive || (caster != target && Combat::canDoCombat(caster, target, params.aggressive) == RETURNVALUE_NOERROR)) {
		auto spectators = Spectators().find<Player>(target->getPosition(), true);

		CombatNullFunc(caster, target, params, nullptr);
		combatTileEffects(spectators.data(), caster, target->getTile(), params);

		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		/*
		if (params.impactEffect != CONST_ME_NONE) {
			g_game().addMagicEffect(target->getPosition(), params.impactEffect);
		}
		*/

		if (caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, origin, target->getPosition(), params.distanceEffect);
		}

		if (params.soundImpactEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(target->getPosition(), params.soundCastEffect, params.soundImpactEffect, caster);
		} else if (params.soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(target->getPosition(), params.soundCastEffect, caster);
		}
	}
}

void Combat::setInstantSpellName(const std::string &value) {
	instantSpellName = value;
}

void Combat::setRuneSpellName(const std::string &value) {
	runeSpellName = value;
}

std::vector<std::pair<Position, std::vector<uint32_t>>> Combat::pickChainTargets(std::shared_ptr<Creature> caster, const CombatParams &params, uint8_t chainDistance, uint8_t maxTargets, bool backtracking, bool aggressive, std::shared_ptr<Creature> initialTarget /* = nullptr */) {
	if (!caster) {
		return {};
	}

	std::vector<std::pair<Position, std::vector<uint32_t>>> resultMap;
	std::vector<std::shared_ptr<Creature>> targets;
	phmap::flat_hash_set<uint32_t> visited;

	if (initialTarget && initialTarget != caster) {
		targets.push_back(initialTarget);
		visited.insert(initialTarget->getID());
		resultMap.push_back({ caster->getPosition(), { initialTarget->getID() } });
	} else {
		targets.push_back(caster);
		maxTargets++;
	}

	const int maxBacktrackingAttempts = 10; // Can be adjusted as needed
	while (!targets.empty() && targets.size() <= maxTargets) {
		auto currentTarget = targets.back();
		auto spectators = Spectators().find<Creature>(currentTarget->getPosition(), false, chainDistance, chainDistance, chainDistance, chainDistance);
		g_logger().debug("Combat::pickChainTargets: currentTarget: {}, spectators: {}", currentTarget->getName(), spectators.size());

		double closestDistance = std::numeric_limits<double>::max();
		std::shared_ptr<Creature> closestSpectator = nullptr;
		for (const auto &spectator : spectators) {
			if (!spectator || visited.contains(spectator->getID())) {
				continue;
			}
			if (!isValidChainTarget(caster, currentTarget, spectator, params, aggressive)) {
				visited.insert(spectator->getID());
				continue;
			}

			double distance = Position::getEuclideanDistance(currentTarget->getPosition(), spectator->getPosition());
			if (distance < closestDistance) {
				closestDistance = distance;
				closestSpectator = spectator;
			}
		}

		if (closestSpectator) {
			g_logger().debug("Combat::pickChainTargets: closestSpectator: {}", closestSpectator->getName());

			bool found = false;
			for (auto &[pos, vec] : resultMap) {
				if (pos == currentTarget->getPosition()) {
					vec.push_back(closestSpectator->getID());
					found = true;
					break;
				}
			}
			if (!found) {
				resultMap.push_back({ currentTarget->getPosition(), { closestSpectator->getID() } });
			}

			targets.push_back(closestSpectator);
			visited.insert(closestSpectator->getID());
			continue;
		} else if (backtracking) {
			targets.pop_back();
			if (targets.size() <= maxBacktrackingAttempts) {
				continue;
			}
		}
		break;
	}

	return resultMap;
}

bool Combat::isValidChainTarget(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> currentTarget, std::shared_ptr<Creature> potentialTarget, const CombatParams &params, bool aggressive) {
	bool canCombat = canDoCombat(caster, potentialTarget, aggressive) == RETURNVALUE_NOERROR;
	bool pick = params.chainPickerCallback ? params.chainPickerCallback->onChainCombat(caster, potentialTarget) : true;
	bool hasSight = g_game().isSightClear(currentTarget->getPosition(), potentialTarget->getPosition(), true);
	return canCombat && pick && hasSight;
}

//**********************************************************//

uint32_t ValueCallback::getMagicLevelSkill(std::shared_ptr<Player> player, const CombatDamage &damage) const {
	if (!player) {
		return 0;
	}

	uint32_t magicLevelSkill = player->getMagicLevel();
	// Wheel of destiny
	if (player && player->wheel()->getInstant("Runic Mastery") && damage.instantSpellName.empty()) {
		const std::shared_ptr<Spell> spell = g_spells().getRuneSpellByName(damage.runeSpellName);
		// Rune conjuring spell have the same name as the rune item spell.
		const std::shared_ptr<InstantSpell> conjuringSpell = g_spells().getInstantSpellByName(damage.runeSpellName);
		if (spell && conjuringSpell && conjuringSpell != spell && normal_random(0, 100) <= 25) {
			uint32_t castResult = conjuringSpell->canCast(player) ? 20 : 10;
			magicLevelSkill += magicLevelSkill * castResult / 100;
		}
	}

	return magicLevelSkill + player->getSpecializedMagicLevel(damage.primary.type, true);
}

void ValueCallback::getMinMaxValues(std::shared_ptr<Player> player, CombatDamage &damage, bool useCharges) const {
	// onGetPlayerMinMaxValues(...)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[ValueCallback::getMinMaxValues - Player {} formula {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 player->getName(), fmt::underlying(type));
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	int16_t elementAttack = 0; // To calculate elemental damage after executing spell script and get real damage.
	int32_t attackValue = 7; // default start attack value
	int parameters = 1;
	bool shouldCalculateSecondaryDamage = false;

	switch (type) {
		case COMBAT_FORMULA_LEVELMAGIC: {
			// onGetPlayerMinMaxValues(player, level, maglevel)
			lua_pushnumber(L, player->getLevel());
			lua_pushnumber(L, getMagicLevelSkill(player, damage));
			parameters += 2;
			break;
		}

		case COMBAT_FORMULA_SKILL: {
			// onGetPlayerMinMaxValues(player, attackSkill, attackValue, attackFactor)
			std::shared_ptr<Item> tool = player->getWeapon();
			const WeaponShared_ptr weapon = g_weapons().getWeapon(tool);
			std::shared_ptr<Item> item = nullptr;

			if (weapon) {
				attackValue = tool->getAttack();
				if (tool->getWeaponType() == WEAPON_AMMO) {
					item = player->getWeapon(true);
					if (item) {
						attackValue += item->getAttack();
					}
				}

				CombatType_t elementType = weapon->getElementType();
				damage.secondary.type = elementType;

				if (elementType != COMBAT_NONE) {
					if (weapon) {
						elementAttack = weapon->getElementDamageValue();
						shouldCalculateSecondaryDamage = true;
						attackValue += elementAttack;
					}
				} else {
					shouldCalculateSecondaryDamage = false;
				}

				if (useCharges) {
					auto charges = tool->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
					if (charges != 0) {
						g_game().transformItem(tool, tool->getID(), charges - 1);
					}
				}
			}

			lua_pushnumber(L, player->getWeaponSkill(item ? item : tool));
			lua_pushnumber(L, attackValue);
			lua_pushnumber(L, player->getAttackFactor());
			parameters += 3;
			break;
		}

		default: {
			g_logger().warn("[ValueCallback::getMinMaxValues] - Unknown callback type");
			scriptInterface->resetScriptEnv();
			return;
		}
	}

	int size0 = lua_gettop(L);
	if (lua_pcall(L, parameters, 2, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		int32_t defaultDmg = normal_random(
			LuaScriptInterface::getNumber<int32_t>(L, -2),
			LuaScriptInterface::getNumber<int32_t>(L, -1)
		);

		if (shouldCalculateSecondaryDamage) {
			double factor = (double)elementAttack / (double)attackValue; // attack value here is phys dmg + element dmg
			int32_t elementDamage = std::round(defaultDmg * factor);
			int32_t physDmg = std::round(defaultDmg * (1.0 - factor));
			damage.primary.value = physDmg;
			damage.secondary.value = elementDamage;
		} else {
			damage.primary.value = defaultDmg;
			damage.secondary.type = COMBAT_NONE;
			damage.secondary.value = 0;
		}

		lua_pop(L, 2);
	}

	if ((lua_gettop(L) + parameters + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

//**********************************************************//

void TileCallback::onTileCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Tile> tile) const {
	// onTileCombat(creature, pos)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[TileCallback::onTileCombat - Creature {} type {} on tile x: {} y: {} z: {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature->getName(), fmt::underlying(type), (tile->getPosition()).getX(), (tile->getPosition()).getY(), (tile->getPosition()).getZ());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
	LuaScriptInterface::pushPosition(L, tile->getPosition());

	scriptInterface->callFunction(2);
}

//**********************************************************//

void TargetCallback::onTargetCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const {
	// onTargetCombat(creature, target)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[TargetCallback::onTargetCombat - Creature {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature->getName());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}

	int size0 = lua_gettop(L);

	if (lua_pcall(L, 2, 0 /*nReturnValues*/, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}

	if ((lua_gettop(L) + 2 /*nParams*/ + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

//**********************************************************//

void ChainCallback::onChainCombat(std::shared_ptr<Creature> creature, uint8_t &maxTargets, uint8_t &chainDistance, bool &backtracking) const {
	// onChainCombat(creature)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[ChainCallback::onTargetCombat - Creature {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature->getName());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	int size0 = lua_gettop(L);
	if (lua_pcall(L, 1, 3 /*nReturnValues*/, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}
	maxTargets = LuaScriptInterface::getNumber<uint8_t>(L, -3);
	chainDistance = LuaScriptInterface::getNumber<uint8_t>(L, -2);
	backtracking = LuaScriptInterface::getBoolean(L, -1);
	lua_pop(L, 3);

	if ((lua_gettop(L) + 1 /*nParams*/ + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

bool ChainPickerCallback::onChainCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const {
	// onChainCombat(creature, target)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[ChainPickerCallback::onTargetCombat - Creature {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature->getName());
		return true;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return true;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}

	int size0 = lua_gettop(L);
	bool result = true;

	if (lua_pcall(L, 2, 1 /*nReturnValues*/, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}
	result = LuaScriptInterface::getBoolean(L, -1);
	lua_pop(L, 1);

	if ((lua_gettop(L) + 2 /*nParams*/ + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
	return result;
}

//**********************************************************//

void AreaCombat::clear() {
	std::ranges::fill(areas, nullptr);
}

AreaCombat::AreaCombat(const AreaCombat &rhs) {
	hasExtArea = rhs.hasExtArea;
	for (uint_fast8_t i = 0; i <= Direction::DIRECTION_LAST; ++i) {
		if (const auto &area = rhs.areas[i]) {
			areas[i] = area->clone();
		}
	}
}

void AreaCombat::getList(const Position &centerPos, const Position &targetPos, std::forward_list<std::shared_ptr<Tile>> &list) const {
	const std::unique_ptr<MatrixArea> &area = getArea(centerPos, targetPos);
	if (!area) {
		return;
	}

	uint32_t centerY, centerX;
	area->getCenter(centerY, centerX);

	Position tmpPos(targetPos.x - centerX, targetPos.y - centerY, targetPos.z);
	uint32_t cols = area->getCols();
	for (uint32_t y = 0, rows = area->getRows(); y < rows; ++y) {
		for (uint32_t x = 0; x < cols; ++x) {
			if (area->getValue(y, x) != 0 && g_game().isSightClear(targetPos, tmpPos, true)) {
				list.push_front(g_game().map.getOrCreateTile(tmpPos));
			}
			tmpPos.x++;
		}
		tmpPos.x -= cols;
		tmpPos.y++;
	}
}

void AreaCombat::copyArea(const std::unique_ptr<MatrixArea> &input, const std::unique_ptr<MatrixArea> &output, MatrixOperation_t op) const {
	uint32_t centerY, centerX;
	input->getCenter(centerY, centerX);

	if (op == MATRIXOPERATION_COPY) {
		for (uint32_t y = 0; y < input->getRows(); ++y) {
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				(*output)[y][x] = (*input)[y][x];
			}
		}

		output->setCenter(centerY, centerX);
	} else if (op == MATRIXOPERATION_MIRROR) {
		for (uint32_t y = 0; y < input->getRows(); ++y) {
			uint32_t rx = 0;
			for (int32_t x = input->getCols(); --x >= 0;) {
				(*output)[y][rx++] = (*input)[y][x];
			}
		}

		output->setCenter(centerY, (input->getRows() - 1) - centerX);
	} else if (op == MATRIXOPERATION_FLIP) {
		for (uint32_t x = 0; x < input->getCols(); ++x) {
			uint32_t ry = 0;
			for (int32_t y = input->getRows(); --y >= 0;) {
				(*output)[ry++][x] = (*input)[y][x];
			}
		}

		output->setCenter((input->getCols() - 1) - centerY, centerX);
	} else {
		// rotation
		int32_t rotateCenterX = (output->getCols() / 2) - 1;
		int32_t rotateCenterY = (output->getRows() / 2) - 1;
		int32_t angle;

		switch (op) {
			case MATRIXOPERATION_ROTATE90:
				angle = 90;
				break;

			case MATRIXOPERATION_ROTATE180:
				angle = 180;
				break;

			case MATRIXOPERATION_ROTATE270:
				angle = 270;
				break;

			default:
				angle = 0;
				break;
		}

		double angleRad = M_PI * angle / 180.0;

		double a = std::cos(angleRad);
		double b = -std::sin(angleRad);
		double c = std::sin(angleRad);
		double d = std::cos(angleRad);

		const uint32_t rows = input->getRows();
		for (uint32_t x = 0, cols = input->getCols(); x < cols; ++x) {
			for (uint32_t y = 0; y < rows; ++y) {
				// calculate new coordinates using rotation center
				int32_t newX = x - centerX;
				int32_t newY = y - centerY;

				// perform rotation
				int32_t rotatedX = static_cast<int32_t>(round(newX * a + newY * b));
				int32_t rotatedY = static_cast<int32_t>(round(newX * c + newY * d));

				// write in the output matrix using rotated coordinates
				(*output)[rotatedY + rotateCenterY][rotatedX + rotateCenterX] = (*input)[y][x];
			}
		}

		output->setCenter(rotateCenterY, rotateCenterX);
	}
}

std::unique_ptr<MatrixArea> AreaCombat::createArea(const std::list<uint32_t> &list, uint32_t rows) {
	uint32_t cols;
	if (rows == 0) {
		cols = 0;
	} else {
		cols = list.size() / rows;
	}

	auto area = std::make_unique<MatrixArea>(rows, cols);

	uint32_t x = 0;
	uint32_t y = 0;

	for (uint32_t value : list) {
		if (value == 1 || value == 3) {
			area->setValue(y, x, true);
		}

		if (value == 2 || value == 3) {
			area->setCenter(y, x);
		}

		++x;

		if (cols == x) {
			x = 0;
			++y;
		}
	}
	return area;
}

void AreaCombat::setupArea(const std::list<uint32_t> &list, uint32_t rows) {
	auto northArea = createArea(list, rows);

	const uint32_t maxOutput = std::max<uint32_t>(northArea->getCols(), northArea->getRows()) * 2;

	auto southArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(northArea, southArea, MATRIXOPERATION_ROTATE180);

	auto eastArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(northArea, eastArea, MATRIXOPERATION_ROTATE90);

	auto westArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(northArea, westArea, MATRIXOPERATION_ROTATE270);

	areas[DIRECTION_NORTH] = std::move(northArea);
	areas[DIRECTION_SOUTH] = std::move(southArea);
	areas[DIRECTION_EAST] = std::move(eastArea);
	areas[DIRECTION_WEST] = std::move(westArea);
}

void AreaCombat::setupArea(int32_t length, int32_t spread) {
	std::list<uint32_t> list;

	uint32_t rows = length;
	int32_t cols = 1;

	if (spread != 0) {
		cols = ((length - (length % spread)) / spread) * 2 + 1;
	}

	int32_t colSpread = cols;

	for (uint32_t y = 1; y <= rows; ++y) {
		int32_t mincol = cols - colSpread + 1;
		int32_t maxcol = cols - (cols - colSpread);

		for (int32_t x = 1; x <= cols; ++x) {
			if (y == rows && x == ((cols - (cols % 2)) / 2) + 1) {
				list.push_back(3);
			} else if (x >= mincol && x <= maxcol) {
				list.push_back(1);
			} else {
				list.push_back(0);
			}
		}

		if (spread > 0 && y % spread == 0) {
			--colSpread;
		}
	}

	setupArea(list, rows);
}

void AreaCombat::setupArea(int32_t radius) {
	int32_t area[13][13] = {
		{ 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0 },
		{ 0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0 },
		{ 0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0 },
		{ 0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0 },
		{ 0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0 },
		{ 8, 7, 6, 5, 4, 2, 1, 2, 4, 5, 6, 7, 8 },
		{ 0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0 },
		{ 0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0 },
		{ 0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0 },
		{ 0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0 },
		{ 0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 }
	};

	std::list<uint32_t> list;

	for (auto &row : area) {
		for (int cell : row) {
			if (cell == 1) {
				list.push_back(3);
			} else if (cell > 0 && cell <= radius) {
				list.push_back(1);
			} else {
				list.push_back(0);
			}
		}
	}

	setupArea(list, 13);
}

void AreaCombat::setupExtArea(const std::list<uint32_t> &list, uint32_t rows) {
	if (list.empty()) {
		return;
	}

	hasExtArea = true;

	// NORTH-WEST
	auto nwArea = createArea(list, rows);

	const uint32_t maxOutput = std::max<uint32_t>(nwArea->getCols(), nwArea->getRows()) * 2;

	// NORTH-EAST
	auto neArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(nwArea, neArea, MATRIXOPERATION_MIRROR);

	// SOUTH-WEST
	auto swArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(nwArea, swArea, MATRIXOPERATION_FLIP);

	// SOUTH-EAST
	auto seArea = std::make_unique<MatrixArea>(maxOutput, maxOutput);
	copyArea(swArea, seArea, MATRIXOPERATION_MIRROR);

	areas[DIRECTION_NORTHWEST] = std::move(nwArea);
	areas[DIRECTION_SOUTHWEST] = std::move(swArea);
	areas[DIRECTION_NORTHEAST] = std::move(neArea);
	areas[DIRECTION_SOUTHEAST] = std::move(seArea);
}

//**********************************************************//

void MagicField::onStepInField(const std::shared_ptr<Creature> &creature) {
	// remove magic walls/wild growth
	if (!isBlocking() && g_game().getWorldType() == WORLD_TYPE_NO_PVP && id == ITEM_MAGICWALL_SAFE || id == ITEM_WILDGROWTH_SAFE) {
		if (!creature->isInGhostMode()) {
			g_game().internalRemoveItem(static_self_cast<Item>(), 1);
		}

		return;
	}

	const ItemType &it = items[getID()];
	if (it.conditionDamage) {
		auto conditionCopy = it.conditionDamage->clone();
		auto ownerId = getAttribute<uint32_t>(ItemAttribute_t::OWNER);
		if (ownerId) {
			bool harmfulField = true;
			auto itemTile = getTile();
			if (g_game().getWorldType() == WORLD_TYPE_NO_PVP || itemTile && itemTile->hasFlag(TILESTATE_NOPVPZONE)) {
				std::shared_ptr<Creature> owner = g_game().getCreatureByID(ownerId);
				if (owner) {
					if (owner->getPlayer() || (owner->isSummon() && owner->getMaster()->getPlayer())) {
						harmfulField = false;
					}
				}
			}

			std::shared_ptr<Player> targetPlayer = creature->getPlayer();
			if (targetPlayer) {
				const std::shared_ptr<Player> attackerPlayer = g_game().getPlayerByID(ownerId);
				if (attackerPlayer) {
					if (Combat::isProtected(attackerPlayer, targetPlayer)) {
						harmfulField = false;
					}
				}
			}

			if (!harmfulField || (OTSYS_TIME() - createTime <= 5000) || creature->hasBeenAttacked(ownerId)) {
				conditionCopy->setParam(CONDITION_PARAM_OWNER, ownerId);
			}
		}

		creature->addCondition(conditionCopy);
	}
}

void Combat::applyExtensions(std::shared_ptr<Creature> caster, std::shared_ptr<Creature> target, CombatDamage &damage, const CombatParams &params) {
	if (damage.extension || !caster || damage.primary.type == COMBAT_HEALING) {
		return;
	}

	g_logger().trace("[Combat::applyExtensions] - Applying extensions for {} on {}. Initial damage: {}", caster->getName(), target ? target->getName() : "null", damage.primary.value);

	// Critical hit
	uint16_t chance = 0;
	int32_t bonus = 50;
	auto player = caster->getPlayer();
	auto monster = caster->getMonster();
	if (player) {
		chance = player->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE);
		bonus = player->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE);
		if (target) {
			uint16_t playerCharmRaceid = player->parseRacebyCharm(CHARM_LOW, false, 0);
			if (playerCharmRaceid != 0) {
				const auto mType = g_monsters().getMonsterType(target->getName());
				if (mType && playerCharmRaceid == mType->info.raceid) {
					const auto charm = g_iobestiary().getBestiaryCharm(CHARM_LOW);
					if (charm) {
						chance += charm->percent;
						g_game().sendDoubleSoundEffect(target->getPosition(), charm->soundCastEffect, charm->soundImpactEffect, caster);
					}
				}
			}
		}
	} else if (monster) {
		chance = monster->critChance();
	}

	bonus += damage.criticalDamage;
	double multiplier = 1.0 + static_cast<double>(bonus) / 100;
	chance += (uint16_t)damage.criticalChance;

	if (chance != 0 && uniform_random(1, 100) <= chance) {
		damage.critical = true;
		damage.primary.value *= multiplier;
		damage.secondary.value *= multiplier;
	}

	if (player) {
		// Fatal hit (onslaught)
		if (auto playerWeapon = player->getInventoryItem(CONST_SLOT_LEFT);
			playerWeapon != nullptr && playerWeapon->getTier() > 0) {
			double_t fatalChance = playerWeapon->getFatalChance();
			double_t randomChance = uniform_random(0, 10000) / 100;
			if (fatalChance > 0 && randomChance < fatalChance) {
				damage.fatal = true;
				damage.primary.value += static_cast<int32_t>(std::round(damage.primary.value * 0.6));
				damage.secondary.value += static_cast<int32_t>(std::round(damage.secondary.value * 0.6));
			}
		}
	} else if (monster) {
		damage.primary.value *= monster->getAttackMultiplier();
		damage.secondary.value *= monster->getAttackMultiplier();
	}
}
