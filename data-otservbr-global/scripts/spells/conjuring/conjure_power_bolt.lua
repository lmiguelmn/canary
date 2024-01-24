local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(0, 3450, 10, CONST_ME_MAGIC_BLUE)
end

spell:name("Conjure Power Bolt")
spell:words("exevo con vis")
spell:group("support")
spell:vocation("royal paladin;true")
spell:id(95)
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(59)
spell:mana(700)
spell:soul(4)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
