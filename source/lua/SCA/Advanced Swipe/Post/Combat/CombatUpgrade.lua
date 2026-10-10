-- The evolve menu lights an ability's icon when this says it is unlocked. Advanced Swipe is
-- unlocked for whoever bought it.
local oldGetIsTechUnlocked = GetIsTechUnlocked
function GetIsTechUnlocked(player, techId)

    if techId == kTechId.AdvancedSwipe then

        if Server then
            return GetHasAdvancedSwipe(player)
        end

        -- Client: the purchases the server told this player about.
        local upgrade = GetUpgradeFromTechId(techId)
        return upgrade ~= nil and player.GotItemAlready ~= nil and player:GotItemAlready(upgrade)

    end

    return oldGetIsTechUnlocked(player, techId)

end
