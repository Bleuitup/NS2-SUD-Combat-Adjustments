-- Marine weapon tree
--
-- Combat sells the Machine Gun as an upgrade on top of the Shotgun (2 + 1 points), from when it
-- was the stronger gun. It is a sidegrade now, so here the two sit side by side:
--
--   Shotgun      2 points   locked while you own the Machine Gun
--   Machine Gun  2 points   locked while you own the Shotgun
--   Flamethrower / Grenade Launcher   1 point, need the Shotgun OR the Machine Gun
--
-- Descriptions for the buy menu are in Locale.lua next to this file.

local shotgun = GetUpgradeFromId(kCombatUpgrades.Shotgun)
local machineGun = GetUpgradeFromId(kCombatUpgrades.HeavyMachineGun)

-- Takes an upgrade out of another upgrade's exclusion list, leaving the rest of the list alone
-- (other weapon mods add their own entries to it).
local function RemoveExclusion(upgrade, upgradeId)
    local mutuallyExclusive = upgrade:GetMutuallyExclusive()
    if mutuallyExclusive then
        table.removevalue(mutuallyExclusive, upgradeId)
    end
end

local function AddExclusion(upgrade, upgradeId)
    if not upgrade.mutuallyExclusive then
        upgrade.mutuallyExclusive = {}
    end
    table.insertunique(upgrade.mutuallyExclusive, upgradeId)
end

if shotgun and machineGun then

    AddExclusion(shotgun, kCombatUpgrades.HeavyMachineGun)

    machineGun.requirements = nil
    machineGun.levels = shotgun:GetLevels()
    -- Kept when you die, like the Shotgun. Combat hands the Machine Gun back on death.
    machineGun.refundUpgrade = shotgun:GetRefundUpgrade()
    RemoveExclusion(machineGun, kCombatUpgrades.Flamethrower)
    RemoveExclusion(machineGun, kCombatUpgrades.GrenadeLauncher)
    AddExclusion(machineGun, kCombatUpgrades.Shotgun)

    -- Not in Combat's competitive mode.
    for _, upgradeId in ipairs({ kCombatUpgrades.Flamethrower, kCombatUpgrades.GrenadeLauncher }) do

        local upgrade = GetUpgradeFromId(upgradeId)
        if upgrade then
            upgrade:SetAlternativeRequirements({ kCombatUpgrades.HeavyMachineGun })
            RemoveExclusion(upgrade, kCombatUpgrades.HeavyMachineGun)
        end

    end

end
