if Server then

    -- Vanilla always queues the same amount of healing over time. This takes an optional
    -- amount, so a Medpack can queue less (see MedPack.lua in this piece).
    function RegenerationMixin:AddRegeneration(amount)

        local max = self:GetMaxHealth() - self:GetHealth()

        self.regenerationHealth = math.min(self.regenerationHealth + (amount or self.regenerationValue), max)

        self.regenerating = true

    end

end
