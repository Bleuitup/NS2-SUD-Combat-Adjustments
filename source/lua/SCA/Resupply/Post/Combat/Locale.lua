-- Buy menu descriptions of Resupply and Improved Resupply (see ExperienceData.lua and
-- MarineTeam.lua next to this). The %s is filled in by Combat: 5 seconds in both.

local kDescriptions =
{
    enUS =
    {
        COMBAT_RESUPPLY_DESCRIPTION = "You get Resupply. Ammo and Medpacks drop for you every %s seconds, and you can call Medpacks and Ammopacks on demand with your request menu. A call resets your resupply cooldown and adds 5 seconds. Your Medpacks heal 40 at once and 10 over time, instead of 25 and 25.",
        COMBAT_IMPROVED_RESUPPLY_DESCRIPTION = "Call a second pack before your resupply cooldown runs out: you can call whenever 10 seconds or less are left, and each call adds +%s seconds, up to 15. Requires Resupply.",
    },

    esES =
    {
        COMBAT_RESUPPLY_DESCRIPTION = "Recibes Resupply. Te caen munición y medpacks cada %s segundos, y puedes pedir medpacks y munición cuando quieras con el menú de peticiones. Pedir reinicia tu reabastecimiento y le suma 5 segundos. Tus medpacks curan 40 al instante y 10 con el tiempo, en lugar de 25 y 25.",
        COMBAT_IMPROVED_RESUPPLY_DESCRIPTION = "Pide un segundo pack antes de que termine tu reabastecimiento: puedes pedir siempre que falten 10 segundos o menos, y cada pedido suma +%s segundos, hasta 15. Requiere Resupply.",
    },
}

for language, messages in pairs(kCombatLocaleMessages) do
    local descriptions = kDescriptions[language]
    for key in pairs(kDescriptions.enUS) do
        -- A language without its own text here drops Combat's outdated one and shows the English.
        messages[key] = descriptions and descriptions[key] or nil
    end
end
