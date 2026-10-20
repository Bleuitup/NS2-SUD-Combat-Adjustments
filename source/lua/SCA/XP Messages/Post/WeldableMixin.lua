-- Only load these changes inside the Server VM
if not Server then return end

-- Welding XP (SCA's Welding XP piece, or Combat's own).
local oldOnWeld = WeldableMixin.OnWeld
function WeldableMixin:OnWeld(...)
    SCA_WithXpSource({ source = kSCAXpSource.Weld, target = self }, oldOnWeld, self, ...)
end
