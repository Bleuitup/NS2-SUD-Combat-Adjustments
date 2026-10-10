-- Advanced Swipe: +kAdvancedSwipeDamageScalar on swipe damage for a player who bought it.
--
-- Every argument after damage is passed through untouched with "...".

-- The purchase list is the one record of the upgrade that follows a player through every
-- respawn and evolution.
function GetHasAdvancedSwipe(player)
    return player ~= nil and player.GetHasCombatUpgrade ~= nil
       and player:GetHasCombatUpgrade(kCombatUpgrades.AdvancedSwipe)
end

local oldGetUpgradedDamage = NS2Gamerules_GetUpgradedDamage

function NS2Gamerules_GetUpgradedDamage(attacker, doer, damage, ...)

    if doer
    and doer.kMapName == "swipe"
    and GetHasAdvancedSwipe(attacker) then
        return damage * kAdvancedSwipeDamageScalar
    end

    return oldGetUpgradedDamage(attacker, doer, damage, ...)

end
