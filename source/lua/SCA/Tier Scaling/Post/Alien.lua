-- Per-player biomass. Combat has no hives to count, so a player's biomass follows the tiers they
-- bought: 1 at the start, 5 with tier 2, 9 with tier 3. Carapace armor (below) and biomass health
-- (BiomassHealthMixin.lua) both scale from it the way they do in vanilla.
function Alien:GetCombatBiomassLevel()

    local level = 1

    if self.combatTwoHives then
        level = level + 4
    end

    if self.combatThreeHives then
        level = level + 4
    end

    return level

end

-- Vanilla Carapace at full shells: a flat bonus plus a bonus per biomass level.
-- Combat's version gives everyone the biomass 12 maximum instead.
function Alien:UpdateArmorAmount(carapaceLevel)

    local baseArmor = self:GetBaseArmor()
    local newMaxArmor = baseArmor

    if GetHasCarapaceUpgrade(self) then
        newMaxArmor = baseArmor + self:GetBaseCarapaceArmorBuff() + self:GetCarapaceBonusPerBiomass() * self:GetCombatBiomassLevel()
    end

    -- Preserve current armor percentage when max changes.
    if newMaxArmor ~= self.maxArmor then
        local pct = (self.maxArmor and self.maxArmor > 0) and (self.armor / self.maxArmor) or 0
        self.maxArmor = newMaxArmor
        self:SetArmor(self.maxArmor * pct)
    end

    -- Keep Combat's per-player tier -> vanilla flags sync for health/tech.
    if self:GetTeamNumber() ~= kTeamReadyRoom then
        self.twoHives   = self.combatTwoHives   or false
        self.threeHives = self.combatThreeHives or false
    end

    -- Refresh health to align with current per-player biomass flags.
    self:UpdateHealthAmount(0)

end
