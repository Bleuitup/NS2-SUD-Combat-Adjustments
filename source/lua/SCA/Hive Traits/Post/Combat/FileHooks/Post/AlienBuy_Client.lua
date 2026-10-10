-- Evolve menu: lock the traits the hive trait rule does not allow yet.
-- upgradeTechIdList is everything the player owns or has selected in the menu.

local oldAlienBuy_GetIsUpgradeAllowed = AlienBuy_GetIsUpgradeAllowed
function AlienBuy_GetIsUpgradeAllowed(techId, upgradeTechIdList)

    if not oldAlienBuy_GetIsUpgradeAllowed(techId, upgradeTechIdList) then
        return false
    end

    -- A selected trait stays clickable, or it could not be deselected again.
    if table.icontains(upgradeTechIdList, techId) then
        return true
    end

    return SCA_GetHiveTraitBlockers(techId, function(traitTechId)
        return table.icontains(upgradeTechIdList, traitTechId)
    end) == nil

end
