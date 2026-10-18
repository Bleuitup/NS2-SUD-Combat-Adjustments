-- Only load these changes inside the Server VM
if not Server then return end

-- ARC spawns that are not skipped.
--
-- Combat picks one random spot near the Marine base for a new ARC and checks that a path leads
-- from it to the hive. If that one spot fails, Combat gives up without a word and the next ARC
-- only comes a full interval later; in testing about one spawn in four was lost that way. Here
-- the spot is picked again until one has a path, and the server log says so when none does.
--
-- Combat's own MarineTeam:SpawnARC, with the retries added.

local kSpawnTries = 10

local function Log(message)
    Shared.Message("[SCA] " .. message)
end

-- A spot a few meters around the ARC spawn point, as Combat looks for one.
local function FindSpawnSpot(team)

    local extents = Vector(0.2, 0.2, 0.2) -- LookupTechData(kTechId.ARC, kTechDataMaxExtents)
    for p = 1, 20 do
        local spot = GetRandomSpawnForCapsule(extents.y, extents.x, team:GetARCSpawnPoint() + Vector(0, p * 0.1 + 4, 0), 2, 6)
        if spot then
            return spot
        end
    end

    return nil

end

function MarineTeam:SpawnARC()

    local arcPos

    for try = 1, kSpawnTries do

        local spot = FindSpawnSpot(self)
        if spot and self:PathExistsToEnemyCommand(spot) then
            arcPos = spot
            if try > 1 then
                Log(string.format("ARC spawn spot found on try %d of %d", try, kSpawnTries))
            end
            break
        end

    end

    -- Combat's own last resort
    if not arcPos then
        local fallback = self:GetARCSpawnPoint() + Vector(2, 1, 2)
        if self:PathExistsToEnemyCommand(fallback) then
            arcPos = fallback
        end
    end

    if not arcPos then
        Log(string.format("ARC not spawned: no spot near the Marine base had a path to the hive in %d tries", kSpawnTries))
        return
    end

    local newEnt = CreateEntity(ARC.kMapName, arcPos, self:GetTeamNumber())
    SetRandomOrientation(newEnt)
    newEnt:TriggerEffects("spawnSoundEffects")
    GetGamerules():SpawnedARC()

end
