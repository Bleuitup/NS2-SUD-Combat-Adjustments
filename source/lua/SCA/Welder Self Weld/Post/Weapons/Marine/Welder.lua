-- Aim down with the welder to weld yourself.
--
-- This is Combat's own feature. On a server that also runs a mod which replaces
-- Welder:PerformWeld after Combat does (Devnull's Interesting Score Screen does, to count weld
-- stats), Combat's version is gone and the self weld with it. This puts it back on top of
-- whatever version is in place, without taking the other mod's changes away.
--
-- If nothing was welded or damaged this tick and the player is looking almost straight down,
-- they get the same armor Combat gives. Where Combat's own version is still the one running it
-- has already added that armor, which shows as the armor having changed, and nothing is added
-- twice.
local kSelfWeldLookDown = 0.9 -- how far down, as in Combat: 1 is straight down

local oldPerformWeld = Welder.PerformWeld
function Welder:PerformWeld(player)

    local armorBefore = player:GetArmor()

    local hitPoint = oldPerformWeld(self, player)

    if not hitPoint and player:GetArmor() == armorBefore then

        local dot = Math.DotProduct(player:GetViewCoords().zAxis, Vector(0, -1, 0))
        if dot > kSelfWeldLookDown then
            player:SetArmor(armorBefore + kWelderFireDelay * kSelfWeldAmount)
        end

    end

    return hitPoint

end
