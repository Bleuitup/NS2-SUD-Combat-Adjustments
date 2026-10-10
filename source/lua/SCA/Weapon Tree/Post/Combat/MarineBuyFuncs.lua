-- Buy menu layout: the Machine Gun sits right under the Shotgun, ahead of the Grenade Launcher
-- and the Flamethrower that come after either of them. Combat lists it last in that column.
local oldCombatMarineBuy_GUISortUps = CombatMarineBuy_GUISortUps
function CombatMarineBuy_GUISortUps(upgradeList)

    local sortedList = oldCombatMarineBuy_GUISortUps(upgradeList)

    -- Entries are upgrades, with the string "nextRow" between columns.
    local function FindUpgrade(techId)
        for index, entry in ipairs(sortedList) do
            if entry ~= "nextRow" and entry:GetTechId() == techId then
                return index
            end
        end
        return nil
    end

    local machineGunIndex = FindUpgrade(kTechId.HeavyMachineGun)
    if machineGunIndex and FindUpgrade(kTechId.Shotgun) then

        local machineGun = table.remove(sortedList, machineGunIndex)
        table.insert(sortedList, FindUpgrade(kTechId.Shotgun) + 1, machineGun)

    end

    return sortedList

end
