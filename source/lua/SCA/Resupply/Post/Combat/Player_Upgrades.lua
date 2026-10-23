-- Combat clears its resupply flags here on team change and refunds; clear SCA's with them.
local oldResetLite = Player.Reset_Lite
function Player:Reset_Lite(...)
    oldResetLite(self, ...)
    if self.combatTable then
        self.combatTable.scaExtendedResupply = false
    end
end
