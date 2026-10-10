-- Name and tooltip of Advanced Swipe in the evolve menu.

local kStrings =
{
    enUS =
    {
        SCA_ADVANCED_SWIPE = "Advanced Swipe",
        SCA_ADVANCED_SWIPE_TOOLTIP = "Fade only: Swipe deals 8% more damage. Needs Tier 3.",
    },

    esES =
    {
        SCA_ADVANCED_SWIPE = "Advanced Swipe",
        SCA_ADVANCED_SWIPE_TOOLTIP = "Solo Fade: Swipe hace un 8% más de daño. Requiere Tier 3.",
    },
}

for language, strings in pairs(kStrings) do

    kCombatLocaleMessages[language] = kCombatLocaleMessages[language] or {}
    for key, text in pairs(strings) do
        kCombatLocaleMessages[language][key] = text
    end

end
