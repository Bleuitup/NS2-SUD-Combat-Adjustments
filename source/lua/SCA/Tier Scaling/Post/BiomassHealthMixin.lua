if Server then

    -- Biomass health from the player's own tiers (see Alien:GetCombatBiomassLevel): tier 2 adds
    -- four biomass levels and tier 3 five, as in Combat. The same level drives Carapace.
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
