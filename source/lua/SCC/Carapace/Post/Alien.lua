-- lua/Combat/FileHooks/Post/Alien.lua
-- Forces Carapace to use "full 3/3" behavior and ties armor scaling to
-- per-player Combat biomass steps: 1 (start), 5 (two hives), 9 (three hives).

local function GetCombatBiomassForArmor(self)
    -- Only map biomass for armor if the player actually owns Carapace.
    if not GetHasCarapaceUpgrade(self) then
        return 0
    end

    -- Exact targets requested:
    if self.combatThreeHives then
        return 9
    elseif self.combatTwoHives then
        return 5
    else
        return 1
    end
end

function Alien:UpdateArmorAmount(carapaceLevel)
    -- Always compute from vanilla lifeform-specific methods.
    local baseArmor = self:GetBaseArmor()
    local newMaxArmor = baseArmor

    if GetHasCarapaceUpgrade(self) then
        -- Force "full shells" (3/3): no 1/3 or 2/3 tiers.
        -- Use vanilla-style Carapace formula with our mapped biomass level.
        local biomassLevel = GetCombatBiomassForArmor(self)

        local C0 = self.GetBaseCarapaceArmorBuff and self:GetBaseCarapaceArmorBuff() or 0
        local Cb = self.GetCarapaceBonusPerBiomass and self:GetCarapaceBonusPerBiomass() or 0

        -- Full level (3/3) => multiply by 1.0
        newMaxArmor = baseArmor + (C0 + Cb * biomassLevel)
    end

    -- Preserve current armor percentage when max changes.
    if newMaxArmor ~= self.maxArmor then
        local pct = (self.maxArmor and self.maxArmor > 0) and (self.armor / self.maxArmor) or 0
        self.maxArmor = newMaxArmor
        self:SetArmor(self.maxArmor * pct)
    end

    -- Keep Combat’s existing per-player tier -> vanilla flags sync for health/tech.
    if self:GetTeamNumber() ~= kTeamReadyRoom then
        self.twoHives   = self.combatTwoHives   or false
        self.threeHives = self.combatThreeHives or false
    end

    -- Refresh health to align with current per-player biomass flags.
    self:UpdateHealthAmount(0)
end
