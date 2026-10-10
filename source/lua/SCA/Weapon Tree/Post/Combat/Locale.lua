-- Buy menu descriptions for the weapons whose rules change in ExperienceData.lua next to this file.

local kDescriptions =
{
    enUS =
    {
        COMBAT_SHOTGUN_DESCRIPTION = "You get a Shotgun. You can't have it together with a Machine Gun.",
        COMBAT_MACHINE_GUN_DESCRIPTION = "You get a Machine Gun. You can't have it together with a Shotgun.",
        COMBAT_FLAMETHROWER_DESCRIPTION = "You get a Flamethrower, but you need a Shotgun or a Machine Gun first.",
        COMBAT_GRENADELAUNCHER_DESCRIPTION = "You get a Grenade Launcher, but you need a Shotgun or a Machine Gun first.",
    },

    esES =
    {
        COMBAT_SHOTGUN_DESCRIPTION = "Recibes una escopeta. No puedes tenerla junto con una ametralladora.",
        COMBAT_MACHINE_GUN_DESCRIPTION = "Recibes una ametralladora. No puedes tenerla junto con una escopeta.",
        COMBAT_FLAMETHROWER_DESCRIPTION = "Recibes un lanzallamas, pero primero necesitas una escopeta o una ametralladora.",
        COMBAT_GRENADELAUNCHER_DESCRIPTION = "Recibes un lanza granadas, pero primero necesitas una escopeta o una ametralladora.",
    },
}

for language, messages in pairs(kCombatLocaleMessages) do

    local descriptions = kDescriptions[language]
    for key in pairs(kDescriptions.enUS) do
        -- A language without its own text here drops Combat's outdated one and shows the English.
        messages[key] = descriptions and descriptions[key] or nil
    end

end
