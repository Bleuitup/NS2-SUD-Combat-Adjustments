local oldBuildTechData = BuildTechData

function BuildTechData()

    local techData = oldBuildTechData()

    -- The Fade category puts it among the Fade's abilities in the evolve menu.
    -- Name and tooltip are resolved from Combat/Locale.lua in this piece.
    local advancedSwipe = {
        [kTechDataId] = kTechId.AdvancedSwipe,
        [kTechDataDisplayName] = "SCA_ADVANCED_SWIPE",
        [kTechDataTooltipInfo] = "SCA_ADVANCED_SWIPE_TOOLTIP",
        [kTechDataCategory] = kTechId.Fade
    }

    table.insert(techData, advancedSwipe)

    return techData

end
