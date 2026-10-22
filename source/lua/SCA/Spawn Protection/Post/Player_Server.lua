-- Only load these changes inside the Server VM
if not Server then return end

-- Each team's own spawn protection time (see NS2Gamerules.lua in this piece).
--
-- Combat sets a player's protection end on the first update after they spawn, from
-- kCombatMarineSpawnProtectTime for both teams. Setting it first, from the player's own team,
-- leaves Combat nothing to set; the rest of Combat's spawn protection runs as before.
local oldOnUpdatePlayer = Player.OnUpdatePlayer
function Player:OnUpdatePlayer(deltaTime)

    local combatTable = self.combatTable
    if combatTable and combatTable.activeSpawnProtect and not combatTable.deactivateSpawnProtect
       and self:GetIsAlive() and (self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index) then
        combatTable.deactivateSpawnProtect = Shared.GetTime() + SCA_GetSpawnProtectTime(self:GetTeamNumber())
    end

    oldOnUpdatePlayer(self, deltaTime)

end
