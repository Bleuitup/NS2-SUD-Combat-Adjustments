-- Only load these changes inside the Server VM
if not Server then return end

-- Combat's 5 minute XP catch-up, made to work.
--
-- Every 5 minutes of a round Combat means to raise anyone below 61% of the average XP up to
-- that mark ("Awarding X XP to help you catch up with your teammates..."). Its check only
-- fires when the round clock is exactly divisible by 5 minutes, and a running clock almost never
-- lands on an exact value, so in practice it never happened. Here it fires once each time the
-- round passes a 5 minute mark. Everything else is Combat's: the same 61%, the same average of
-- both teams, the same message.

local nextCatchUpTime

local oldOnUpdate = NS2Gamerules.OnUpdate
function NS2Gamerules:OnUpdate(timePassed)

    oldOnUpdate(self, timePassed)

    if self:GetGameState() ~= kGameState.Started then
        nextCatchUpTime = nil
        return
    end

    local interval = kCombatRebalanceInterval or 300
    local gameLength = Shared.GetTime() - self:GetGameStartTime()

    if not nextCatchUpTime then
        nextCatchUpTime = interval
    end

    if gameLength >= nextCatchUpTime then

        nextCatchUpTime = nextCatchUpTime + interval

        local avgXp = Experience_GetAvgXp()
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            if player:GetIsPlaying() then
                player:BalanceXp(avgXp)
            end
        end

    end

end
