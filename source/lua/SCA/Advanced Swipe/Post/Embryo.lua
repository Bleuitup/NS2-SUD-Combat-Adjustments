-- Keep Advanced Swipe out of the upgrades an egg hands to the hatching alien.
--
-- Combat passes every bought upgrade to the egg, and the alien then stores each one in one of
-- its upgrade slots. There are 12 slots and Combat's own alien upgrades already fill all 12.
-- Advanced Swipe does not need a slot: its damage bonus goes by the purchase list.
local oldSetGestationData = Embryo.SetGestationData
function Embryo:SetGestationData(techIds, ...)

    local filtered = {}
    for _, techId in ipairs(techIds) do
        if techId ~= kTechId.AdvancedSwipe then
            table.insert(filtered, techId)
        end
    end

    oldSetGestationData(self, filtered, ...)

end
