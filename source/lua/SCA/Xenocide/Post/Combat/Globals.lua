-- No Xenocide.
--
-- Combat decides tier 3 abilities from this list: an ability on it unlocks with the player's own
-- tier 3 purchase. An ability that is not on it falls back to the team's tech tree, where nothing
-- is ever researched in Combat, so it stays locked. This is how Combat's own competitive mode
-- drops Xenocide.
table.removevalue(kCombatAlienTierThreeTechIds, kTechId.Xenocide)
