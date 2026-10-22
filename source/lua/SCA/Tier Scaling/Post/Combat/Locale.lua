-- Tooltips of the Tier 2 and Tier 3 upgrades in the evolve menu. Combat's say the biomass is for
-- health only and name Xenocide for Tier 3; here the biomass also counts for Carapace
-- (BiomassHealthMixin.lua and Alien.lua next to this), and Xenocide is gone.

local kTooltips =
{
    enUS =
    {
        BIOMASS_TWO_TOOLTIP = "Unlocks tier 2 abilities for your life form such as Leap and Metabolize. Also gives +4 biomass for your health and Carapace.",
        BIOMASS_THREE_TOOLTIP = "Unlocks tier 3 abilities for your life form such as Stab and Stomp. Also gives +5 biomass for your health and Carapace.",
    },

    esES =
    {
        BIOMASS_TWO_TOOLTIP = "Desbloquea las habilidades de rango 2 para tu clase, como Leap y Metabolize. También agrega +4 de biomasa a tu vida y a Carapace.",
        BIOMASS_THREE_TOOLTIP = "Desbloquea las habilidades de rango 3 para tu clase, como Stab y Stomp. También agrega +5 de biomasa a tu vida y a Carapace.",
    },
}

for language, messages in pairs(kCombatLocaleMessages) do

    local tooltips = kTooltips[language]
    for key in pairs(kTooltips.enUS) do
        -- A language without its own text here drops Combat's outdated one and shows the English.
        messages[key] = tooltips and tooltips[key] or nil
    end

end
