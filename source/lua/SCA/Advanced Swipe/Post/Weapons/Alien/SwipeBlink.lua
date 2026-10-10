function SwipeBlink:GetDeathIconIndex()
    if GetHasAdvancedSwipe(self:GetParent()) then
        return kDeathMessageIcon.AdvancedSwipe
    else
        return kDeathMessageIcon.Swipe
    end
end
