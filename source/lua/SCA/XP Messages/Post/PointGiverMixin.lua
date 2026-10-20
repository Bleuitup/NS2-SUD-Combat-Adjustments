-- Only load these changes inside the Server VM
if not Server then return end

-- Kill XP (players, structures, ARCs, eggs...): the killer, assisters and teammates nearby.
-- Who is who is worked out per receiver in Player_Server.lua in this piece.
local oldGiveXpForKill = PointGiverMixin.GiveXpForKill
function PointGiverMixin:GiveXpForKill(dying, killer)

    local source =
    {
        source = kSCAXpSource.Kill,
        target = dying,
        killer = killer,
        assisters = SCA_GetXpAssisters and SCA_GetXpAssisters(dying) or {},
        levelBonus = true,
    }

    SCA_WithXpSource(source, oldGiveXpForKill, self, dying, killer)

end
