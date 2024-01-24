local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3164, 3)
end

spell:name("Energy Field Rune")
spell:words("adevo grav vis")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(18)
spell:mana(320)
spell:soul(2)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
