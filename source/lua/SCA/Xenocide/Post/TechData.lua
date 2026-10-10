-- The evolve menu lists each lifeform's abilities from here. Xenocide is gone (see
-- Combat/Globals.lua in this piece), so it should not sit on the Skulk as an ability that never
-- lights up.
local oldGetTechForCategory = GetTechForCategory

local skulkAbilities
function GetTechForCategory(techId)

    if techId ~= kTechId.Skulk then
        return oldGetTechForCategory(techId)
    end

    if not skulkAbilities then

        skulkAbilities = {}
        for _, abilityTechId in ipairs(oldGetTechForCategory(techId)) do
            if abilityTechId ~= kTechId.Xenocide then
                table.insert(skulkAbilities, abilityTechId)
            end
        end

    end

    return skulkAbilities

end
