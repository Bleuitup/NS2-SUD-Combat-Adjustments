-- Has to happen right after Combat builds this enum: Combat's network messages are registered
-- straight afterwards and take their size from it.
debug.appendtoenum(kCombatUpgrades, "AdvancedSwipe")
