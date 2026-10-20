-- Only load these changes inside the Server VM
if not Server then return end

-- Gorge healing XP. Combat pays it from a local function called by OnTag, so the whole spray is
-- tagged. Damage the spray does to enemies sets its own source inside this one.
local oldOnTag = HealSprayMixin.OnTag
function HealSprayMixin:OnTag(...)
    SCA_WithXpSource({ source = kSCAXpSource.Heal }, oldOnTag, self, ...)
end
