-- Only load these changes inside the Server VM
if not Server then return end

-- Spawn protection that wears off late in the round.
--
-- The round's time limit is split into five equal parts. For the first two, Combat's own time
-- applies. The start of each of the last three takes a share of that time away. The last step
-- stays for the rest of the round and for overtime.
--
-- Marines lose a fifth each time, aliens half that: aliens come back as skulks, marines with all
-- their gear. With Combat's 3 seconds and a 25 minute round:
--   from 10:00   marines 2.4 (-20%)   aliens 2.7 (-10%)
--   from 15:00   marines 1.8 (-40%)   aliens 2.4 (-20%)
--   from 20:00   marines 1.2 (-60%)   aliens 2.1 (-30%)
-- A different time limit moves the drops with it: they always sit at 40%, 60% and 80% of the round.
--
-- Combat reads kCombatMarineSpawnProtectTime for both teams when a player spawns. That value is
-- the marines' time here; Player_Server.lua in this piece gives aliens theirs.

local kIntervals = 5       -- equal parts the round is split into
local kFullIntervals = 2   -- parts that pass before the first drop
local kDrops = 3
local kDropScalar = { [kTeam1Index] = 0.2, [kTeam2Index] = 0.1 }   -- share of Combat's time each drop takes away
local kWarningTime = 30

local combatTime      -- Combat's own spawn protection time
local appliedDrops = 0 -- number of drops in effect
local warnedDrop      -- drop the last warning was sent for

local function GetTimeAfterDrops(teamNumber, drops)
    return (combatTime or kCombatMarineSpawnProtectTime) * (1 - (kDropScalar[teamNumber] or kDropScalar[kTeam1Index]) * drops)
end

-- Spawn protection for a player of this team right now.
function SCA_GetSpawnProtectTime(teamNumber)
    return GetTimeAfterDrops(teamNumber, appliedDrops)
end

-- Each team hears its own time.
local function Announce(format, drops)
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
        local teamNumber = player:GetTeamNumber()
        if kDropScalar[teamNumber] then
            player:SendDirectMessage(string.format(format, string.format("%.1f seconds", GetTimeAfterDrops(teamNumber, drops))))
        end
    end
end

local oldOnUpdate = NS2Gamerules.OnUpdate
function NS2Gamerules:OnUpdate(timePassed)

    oldOnUpdate(self, timePassed)

    if not combatTime then
        combatTime = kCombatMarineSpawnProtectTime
    end

    -- Outside a running round Combat's own time applies.
    local drops = 0

    if self:GetGameState() == kGameState.Started and kCombatTimeLimit and kCombatTimeLimit > 0 then

        local intervalLength = kCombatTimeLimit / kIntervals
        local gameLength = Shared.GetTime() - self:GetGameStartTime()
        drops = math.max(0, math.min(kDrops, math.floor(gameLength / intervalLength) - (kFullIntervals - 1)))

        local nextDrop = drops + 1
        local nextDropTime = (nextDrop + kFullIntervals - 1) * intervalLength
        if nextDrop <= kDrops and warnedDrop ~= nextDrop
           and intervalLength > kWarningTime and gameLength >= nextDropTime - kWarningTime then

            warnedDrop = nextDrop
            Announce("Spawn protection drops to %s in " .. kWarningTime .. " seconds.", nextDrop)

        end

        if drops > appliedDrops then
            Announce("Spawn protection is now %s.", drops)
        end

    else
        warnedDrop = nil
    end

    if drops ~= appliedDrops then
        appliedDrops = drops
        kCombatMarineSpawnProtectTime = GetTimeAfterDrops(kTeam1Index, drops)
    end

end
