-- Advanced Swipe as a Combat upgrade: 1 point, needs Tier 3 (which itself needs Tier 2).
-- Any lifeform can buy it; only the Fade's Swipe uses it.

-- Nothing to hand out when it is bought: the damage bonus looks at the purchase list itself
-- (GetHasAdvancedSwipe in DamageTypes.lua). Having a function here also keeps Combat from
-- looking for a tech tree entry, which this upgrade does not have.
local function GiveAdvancedSwipe(player)
end

local upgrade = CombatAlienUpgrade()

upgrade:Initialize(kCombatUpgrades.AdvancedSwipe, "advswipe", "Advanced Swipe", kTechId.AdvancedSwipe, GiveAdvancedSwipe, kCombatUpgrades.TierThree, 1, kCombatUpgradeTypes.Tech, false, 0, nil, false)

table.insert(UpsList, upgrade)
