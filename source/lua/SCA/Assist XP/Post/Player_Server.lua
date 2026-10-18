-- Only load these changes inside the Server VM
if not Server then return end

-- A player back at full health and armor starts a fresh assist record: damage taken before that
-- no longer earns anyone a share of the kill XP (see PointGiverMixin.lua in this piece).
local oldOnUpdatePlayer = Player.OnUpdatePlayer
function Player:OnUpdatePlayer(deltaTime)

    oldOnUpdatePlayer(self, deltaTime)

    if self.scaAssistDamage and self:GetIsAlive()
       and self:GetHealth() >= self:GetMaxHealth() and self:GetArmor() >= self:GetMaxArmor() then
        self:ClearAssistDamage()
    end

end
