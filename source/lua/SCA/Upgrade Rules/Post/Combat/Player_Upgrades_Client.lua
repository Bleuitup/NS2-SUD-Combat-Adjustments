local function GetHasCombatUpgrade(player, upgradeId)

    if player.combatUpgrades then
        for _, id in ipairs(player.combatUpgrades) do
            if tonumber(id) == upgradeId then
                return true
            end
        end
    end

    return false

end

-- Whether the marine buy menu offers an upgrade or grays it out.
-- Same checks the server makes: any one of the upgrade's requirements is enough, and owning an
-- upgrade it excludes (Shotgun vs Machine Gun) locks it.
function Player:GotRequirements(upgrade)

    if not upgrade then
        return false
    end

    local function hasUpgrade(upgradeId)
        return GetHasCombatUpgrade(self, upgradeId)
    end

    if not upgrade:GetHasRequirements(hasUpgrade) then
        return false
    end

    local mutuallyExclusive = upgrade:GetMutuallyExclusive()
    if mutuallyExclusive then
        for _, upgradeId in ipairs(mutuallyExclusive) do
            if hasUpgrade(upgradeId) then
                return false
            end
        end
    end

    return true

end
