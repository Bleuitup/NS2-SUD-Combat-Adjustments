-- Resupply also makes Medpacks heal more up front, like Medpack Tech #2 on the pub:
-- 40 at once and 10 over time instead of 25 and 25. It goes by who picks the Medpack up, so it
-- covers both the automatic resupply and the Medpack an owner calls for.
local kImprovedMedpackHeal = 40
local kImprovedMedpackRegeneration = 10

-- Vanilla's OnTouch with the two amounts made variable.
function MedPack:OnTouch(recipient)

    if not recipient.timeLastMedpack or recipient.timeLastMedpack + self.kPickupDelay <= Shared.GetTime() then

        local heal = MedPack.kHealth
        local regeneration = nil -- vanilla's amount

        if recipient.combatTable and recipient.combatTable.hasImprovedResupply then
            heal = kImprovedMedpackHeal
            regeneration = kImprovedMedpackRegeneration
        end

        local oldHealth = recipient:GetHealth()
        recipient:AddHealth(heal, false, true)
        recipient:AddRegeneration(regeneration)
        recipient.timeLastMedpack = Shared.GetTime()

        self:TriggerEffects("medpack_pickup", { effecthostcoords = self:GetCoords() })

        -- Handle Stats
        if Server then

            local commanderStats = StatsUI_GetStatForCommander(StatsUI_GetMarineCommmaderSteamID())

            -- If the medpack hits immediatly expireTime is 0
            if ConditionalValue(self.expireTime == 0, Shared.GetTime(), self.expireTime - kItemStayTime) + 0.025 > Shared.GetTime() then
                commanderStats["medpack"].hitsAcc = commanderStats["medpack"].hitsAcc + 1
            end

            commanderStats["medpack"].misses = commanderStats["medpack"].misses - 1
            commanderStats["medpack"].picks = commanderStats["medpack"].picks + 1
            commanderStats["medpack"].refilled = commanderStats["medpack"].refilled + recipient:GetHealth() - oldHealth

        end

    end

end
