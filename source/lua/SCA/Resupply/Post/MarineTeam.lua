-- Only load these changes inside the Server VM
if not Server then return end

-- Improved Resupply: a second Medpack or Ammopack call.
--
-- Combat's call rule, with "timer" the next automatic resupply on the HUD: you can call when the
-- timer is at 5 or less, and a call sets it to 10 (resets it to 5 and adds 5). That stays as
-- Combat has it, for Resupply. Improved Resupply also allows a call while the timer is between 5
-- and 10, adding 5 to it, so the timer goes up to 15: two calls in a row, then one each time it
-- is back down to 10. Medpack and Ammopack calls share the timer, as in Combat.

local kPackTechIds =
{
    [kTechId.MarineAlertNeedMedpack] = MedPack.kMapName,
    [kTechId.MarineAlertNeedAmmo] = AmmoPack.kMapName,
}

local oldTriggerAlert = MarineTeam.TriggerAlert
function MarineTeam:TriggerAlert(techId, entity, force)

    local combatTable = entity and entity.combatTable
    local before = combatTable and combatTable.lastResupply

    local result = oldTriggerAlert(self, techId, entity, force)

    local mapName = kPackTechIds[techId]
    local now = Shared.GetTime()

    -- Combat drops the pack itself when the timer is at 5 or less; this is only the 5 to 10 case.
    if mapName and before and combatTable.scaExtendedResupply and combatTable.hasImprovedResupply
       and combatTable.lastResupply == before and before > now and before <= now + kImprovedResupplyExtra
       and entity:isa("Player") and entity:GetIsAlive() then

        local newTime = before + kImprovedResupplyExtra
        combatTable.lastResupply = newTime
        entity.lastResupply = newTime

        local position = entity:GetOrigin()
        local pack = CreateEntity(mapName, position, self:GetTeamNumber())
        pack:TriggerEffects("medpack_commander_drop", { effecthostcoords = Coords.GetTranslation(position) })

    end

    return result

end
