-- Only load these changes inside the Server VM
if not Server then return end

-- A structure (or ARC, egg, any other non-player) back at full health and armor starts a fresh
-- assist record, as players do (Player_Server.lua in this piece). Checked once a second for the
-- few entities that hold a record. The Hive, Command Station and Armory pay XP as they are
-- damaged rather than on death, so their record never pays anyone.

local kCheckInterval = 1
local nextCheckTime = 0

local oldOnUpdate = NS2Gamerules.OnUpdate
function NS2Gamerules:OnUpdate(timePassed)

    oldOnUpdate(self, timePassed)

    local now = Shared.GetTime()
    if now < nextCheckTime then
        return
    end
    nextCheckTime = now + kCheckInterval

    for entityId in pairs(SCA_AssistRecordHolders) do

        local entity = Shared.GetEntity(entityId)

        if not entity or not entity.scaAssistDamage then
            SCA_AssistRecordHolders[entityId] = nil
        elseif entity:GetIsAlive()
               and entity:GetHealth() >= entity:GetMaxHealth() and entity:GetArmor() >= entity:GetMaxArmor() then
            entity:ClearAssistDamage()
            SCA_AssistRecordHolders[entityId] = nil
        end

    end

end
