-- Only load these changes inside the Server VM
if not Server then return end

-- Hive, Command Station and Armory pay XP as they are damaged (Combat's StaticTargetMixin).
local oldOnTakeDamage = StaticTargetMixin.OnTakeDamage
function StaticTargetMixin:OnTakeDamage(...)
    SCA_WithXpSource({ source = kSCAXpSource.Damage, target = self }, oldOnTakeDamage, self, ...)
end
