-- Tier 3 costs 3 points (Combat: 2). It gives +5 biomass (Alien.lua next to this), one more than
-- Tier 2.
local tierThree = GetUpgradeFromId(kCombatUpgrades.TierThree)
if tierThree then
    tierThree.levels = 3
end
