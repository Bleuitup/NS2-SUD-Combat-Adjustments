-- Advanced Swipe as a Combat upgrade: 1 point, needs Tier 3 (which itself needs Tier 2).
-- Only a Fade can buy it, or a Skulk evolving into one in the same purchase. The evolve menu
-- only offers it then (Combat/FileHooks/Post/GUIAlienBuyMenu.lua in this piece); the lifeform
-- requirement below makes the server refuse it for anyone else, e.g. through /buy.

-- Nothing to hand out when it is bought: the damage bonus looks at the purchase list itself
-- (GetHasAdvancedSwipe in DamageTypes.lua). Having a function here also keeps Combat from
-- looking for a tech tree entry, which this upgrade does not have.
local function GiveAdvancedSwipe(player)
end

local upgrade = CombatAlienUpgrade()

upgrade:Initialize(kCombatUpgrades.AdvancedSwipe, "advswipe", "Advanced Swipe", kTechId.AdvancedSwipe, GiveAdvancedSwipe, kCombatUpgrades.TierThree, 1, kCombatUpgradeTypes.Tech, false, 0, nil, false)

-- From the "Upgrade Rules" piece.
if upgrade.SetLifeformRequirement then
    upgrade:SetLifeformRequirement(kCombatUpgrades.Fade)
end

table.insert(UpsList, upgrade)
