-- Only load these changes inside the Server VM
if not Server then return end

-- Spawn protection that wears off over the round.
--
-- It starts at 80% of Combat's own time. The round's time limit is split into five equal
-- intervals; each one after the first takes another 25% of the starting time away, down to a
-- floor. With Combat's 3 seconds and a 25 minute round: 2.4, 1.8, 1.2, 0.6 and 0.1 seconds, one
-- step every 5 minutes. Overtime keeps the last step.
--
-- Combat reads kCombatMarineSpawnProtectTime for both teams when a player spawns, so changing
-- that one value is enough.

local kStartScalar = 0.8
local kIntervals = 5
local kStepScalar = 0.25
local kMinimumTime = 0.1
local kWarningTime = 30

local combatTime        -- Combat's own spawn protection time
local appliedInterval   -- interval (0 = first) whose time is in effect
local warnedInterval    -- interval the last warning was sent for

local function GetTimeForInterval(interval)
    local startTime = combatTime * kStartScalar
    return math.max(kMinimumTime, startTime * (1 - kStepScalar * interval))
end

local function GetTimeText(interval)
    return string.format("%.1f seconds", GetTimeForInterval(interval))
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

    -- Outside a running round the first interval's time applies.
    local interval = 0

    if self:GetGameState() == kGameState.Started and kCombatTimeLimit and kCombatTimeLimit > 0 then

        local intervalLength = kCombatTimeLimit / kIntervals
        local gameLength = Shared.GetTime() - self:GetGameStartTime()
        interval = math.min(kIntervals - 1, math.floor(gameLength / intervalLength))

        local nextInterval = interval + 1
        if nextInterval < kIntervals and warnedInterval ~= nextInterval
           and intervalLength > kWarningTime and gameLength >= nextInterval * intervalLength - kWarningTime then

            warnedInterval = nextInterval
            Announce(string.format("Spawn protection drops to %s in %d seconds.", GetTimeText(nextInterval), kWarningTime))

        end

        if appliedInterval and interval > appliedInterval then
            Announce(string.format("Spawn protection is now %s.", GetTimeText(interval)))
        end

    else
        warnedInterval = nil
    end

    if interval ~= appliedInterval then
        appliedInterval = interval
        kCombatMarineSpawnProtectTime = GetTimeForInterval(interval)
    end

end
