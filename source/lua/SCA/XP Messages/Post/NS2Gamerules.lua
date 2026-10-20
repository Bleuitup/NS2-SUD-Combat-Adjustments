-- Only load these changes inside the Server VM
if not Server then return end

-- Sends the added-up XP gains (see Player_Server.lua in this piece).
local oldOnUpdate = NS2Gamerules.OnUpdate
function NS2Gamerules:OnUpdate(timePassed)

    SCA_ResetXpSources()

    oldOnUpdate(self, timePassed)

    SCA_FlushXpGains()

end
