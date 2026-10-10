-- Combat's `requirements` field holds a single upgrade. This adds alternatives next to it, so an
-- upgrade can unlock from any one of several (e.g. Flamethrower from Shotgun or Machine Gun).

function CombatUpgrade:GetAlternativeRequirements()
	return self.alternativeRequirements
end

function CombatUpgrade:SetAlternativeRequirements(upgradeIds)
	self.alternativeRequirements = upgradeIds
end

-- Every upgrade id that satisfies this upgrade's requirement, or nil if it has none.
function CombatUpgrade:GetAllRequirements()

	local requirements = self:GetRequirements()
	if not requirements then
		return nil
	end

	local all = { requirements }
	local alternatives = self:GetAlternativeRequirements()
	if alternatives then
		for _, upgradeId in ipairs(alternatives) do
			table.insert(all, upgradeId)
		end
	end

	return all

end

-- hasUpgrade(upgradeId) tells whether the buyer owns that upgrade.
function CombatUpgrade:GetHasRequirements(hasUpgrade)

	local all = self:GetAllRequirements()
	if not all then
		return true
	end

	for _, upgradeId in ipairs(all) do
		if hasUpgrade(upgradeId) then
			return true
		end
	end

	return false

end
