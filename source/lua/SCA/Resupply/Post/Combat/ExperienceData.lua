-- Resupply now also does what Improved Resupply did in Combat: Medpack and Ammopack calls from
-- the request menu, and Medtech #2 Medpacks (MedPack.lua). Improved Resupply instead lets you
-- call a second pack before the cooldown is over (MarineTeam.lua). Both still cost 1 point.

local function GiveResupply(player)
    player.combatTable.hasResupply = true
    player.combatTable.lastResupply = 0
    player.combatTable.hasImprovedResupply = true -- Combat's flag for calls and SCA's for Medtech #2
end

local function GiveImprovedResupply(player)
    GiveResupply(player)
    player.combatTable.scaExtendedResupply = true
end

local resupply = GetUpgradeFromId(kCombatUpgrades.Resupply)
if resupply then
    resupply.upgradeFunc = GiveResupply
    resupply.useCustomFunc = true
end

local improvedResupply = GetUpgradeFromId(kCombatUpgrades.ImprovedResupply)
if improvedResupply then
    improvedResupply.upgradeFunc = GiveImprovedResupply
    improvedResupply.useCustomFunc = true
end
