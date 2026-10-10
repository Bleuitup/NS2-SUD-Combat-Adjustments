-- Buy menu description of Improved Resupply, with the Medpack change from MedPack.lua.
-- The %s is filled in by Combat with the cooldown it adds.

local kDescriptions =
{
    enUS = "Call Medpacks and Ammopacks on demand using your request menu. Your Medpacks heal 40 at once and 10 over time, instead of 25 and 25. Requires Resupply. Resets and adds +%s seconds to your resupply cooldown when used.",

    esES = "Pide medpacks y munición cuando quieras con el menú de peticiones. Tus medpacks curan 40 al instante y 10 con el tiempo, en lugar de 25 y 25. Requiere Resupply. Al usarlo, reinicia tu reabastecimiento y le suma +%s segundos.",
}

for language, messages in pairs(kCombatLocaleMessages) do
    -- A language without its own text here drops Combat's outdated one and shows the English.
    messages["COMBAT_IMPROVED_RESUPPLY_DESCRIPTION"] = kDescriptions[language]
end
