-- Charge is always unlocked, so its icon is lit under the Onos in the evolve menu.
local oldGetIsTechUnlocked = GetIsTechUnlocked
function GetIsTechUnlocked(player, techId)

    if techId == kTechId.Charge then
        return true
    end

    return oldGetIsTechUnlocked(player, techId)

end
