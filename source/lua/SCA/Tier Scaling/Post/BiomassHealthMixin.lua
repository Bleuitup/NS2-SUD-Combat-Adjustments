if Server then

    -- Biomass health from the player's own tiers (see Alien:GetCombatBiomassLevel): tier 2 and
    -- tier 3 add four biomass levels each. Combat's version adds four, then five.
    function BiomassHealthMixin:UpdateHealthAmount()

        local bioMassLevel = self.GetCombatBiomassLevel and self:GetCombatBiomassLevel() or 1
        local newBiomassHealth = math.max(0, bioMassLevel - 1) * self:GetHealthPerBioMass()

        if newBiomassHealth ~= self.biomassHealth then
            -- maxHealth is a integer
            local healthDelta = math.round(newBiomassHealth - self.biomassHealth)
            self:AdjustMaxHealth(self:GetMaxHealth() + healthDelta)
            self.biomassHealth = newBiomassHealth
        end

    end

end
