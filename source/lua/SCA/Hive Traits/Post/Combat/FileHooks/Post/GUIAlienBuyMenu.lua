-- Evolve menu: say why a trait is locked when the player hovers it.

local kLockText =
{
    enUS = { locked = "Locked: first take %s.", trait = "a %s trait (%s)", joiner = " and " },
    esES = { locked = "Bloqueado: primero elige %s.", trait = "una mejora de %s (%s)", joiner = " y " },
}

-- "Locked: first take a Shift trait (Celerity, Adrenaline, Crush) and a Shade trait (...)."
local function GetLockText(blockers)

    local text = kLockText[Locale.GetLocale()] or kLockText.enUS

    local parts = {}
    for _, blocker in ipairs(blockers) do

        local traitNames = {}
        for _, traitTechId in ipairs(blocker.traits) do
            table.insert(traitNames, GetDisplayNameForTechId(traitTechId))
        end

        table.insert(parts, string.format(text.trait, blocker.name, table.concat(traitNames, ", ")))

    end

    return string.format(text.locked, table.concat(parts, text.joiner))

end

local oldUpdate = GUIAlienBuyMenu.Update
function GUIAlienBuyMenu:Update(deltaTime)

    oldUpdate(self, deltaTime)

    local function hasTrait(traitTechId)
        return table.icontains(self.upgradeList, traitTechId)
    end

    for _, currentButton in ipairs(self.upgradeButtons) do

        if not currentButton.Selected and self:_GetIsMouseOver(currentButton.Icon) then

            local blockers = SCA_GetHiveTraitBlockers(currentButton.TechId, hasTrait)
            if blockers then
                local tooltipText = GetTooltipInfoText(currentButton.TechId) .. "\n\n" .. GetLockText(blockers)
                self:_ShowMouseOverInfo(GetDisplayNameForTechId(currentButton.TechId), tooltipText, currentButton.Cost)
            end

        end

    end

end
