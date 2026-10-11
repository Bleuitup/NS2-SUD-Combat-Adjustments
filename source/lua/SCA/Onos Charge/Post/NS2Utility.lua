-- The Onos can charge when its "one hive" flag is set. Combat sets that flag from the Tier 2
-- purchase for every lifeform; for the Onos it is simply on.
local oldUpdateAbilityAvailability = UpdateAbilityAvailability
function UpdateAbilityAvailability(forAlien, ...)

    oldUpdateAbilityAvailability(forAlien, ...)

    if forAlien:isa("Onos") then
        forAlien.oneHive = true
    end

end
