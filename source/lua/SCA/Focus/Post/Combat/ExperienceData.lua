-- Focus costs 1 point, like the other traits. Combat has it at 2.
local focus = GetUpgradeFromId(kCombatUpgrades.Focus)
if focus then
    focus.levels = 1
end
