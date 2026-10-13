-- Only load these changes inside the Server VM
if not Server then return end

-- Spawn protection that wears off late in the round.
--
-- The round's time limit is split into five equal parts. For the first two, Combat's own time
-- applies. The start of each of the last three takes a fifth of that time away. The last step
-- stays for the rest of the round and for overtime.
--
-- With Combat's 3 seconds and a 25 minute round: 3 seconds until 10:00, then 2.4 (-20%) from
-- 10:00, 1.8 (-40%) from 15:00 and 1.2 (-60%) from 20:00 on. A different time limit moves the
-- drops with it: they always sit at 40%, 60% and 80% of the round.
--
-- Combat reads kCombatMarineSpawnProtectTime for both teams when a player spawns, so changing
-- that one value is enough.

local kIntervals = 5       -- equal parts the round is split into
local kFullIntervals = 2   -- parts that pass before the first drop
local kDrops = 3
local kDropScalar = 0.2    -- share of Combat's own time each drop takes away
local kWarningTime = 30

local combatTime      -- Combat's own spawn protection time
local appliedDrops    -- number of drops in effect
local warnedDrop      -- drop the last warning was sent for

local function GetTimeAfterDrops(drops)
    return combatTime * (1 - kDropScalar * drops)
end

local function GetTimeText(drops)
    return string.format("%.1f seconds", GetTimeAfterDrops(drops))
end

local function Announce(message)
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
        player:SendDirectMessage(message)
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
            Announce(string.format("Spawn protection drops to %s in %d seconds.", GetTimeText(nextDrop), kWarningTime))

        end

        if appliedDrops and drops > appliedDrops then
            Announce(string.format("Spawn protection is now %s.", GetTimeText(drops)))
        end

    else
        warnedDrop = nil
    end

    if drops ~= appliedDrops then
        appliedDrops = drops
        kCombatMarineSpawnProtectTime = GetTimeAfterDrops(drops)
    end

end
