-- Only load these changes inside the Server VM
if not Server then return end

-- Combat pays for a Babbler kill in its own OnKill: the killer, then teammates nearby.
local oldOnKill = Babbler.OnKill
function Babbler:OnKill(attacker, ...)

    -- Same owner lookup as Combat's, so a mine or another owned thing credits its owner.
    local killer = attacker
    if killer ~= nil and not HasMixin(killer, "Scoring") and killer.GetOwner then
        killer = killer:GetOwner()
    end

    SCA_WithXpSource({ source = kSCAXpSource.Kill, target = self, killer = killer }, oldOnKill, self, attacker, ...)

end
