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

-- Bots ask this before they try to buy something. Their own checks only know Combat's rules, so
-- without this a bot keeps picking an upgrade the server refuses (a locked hive trait, the
-- Machine Gun next to its Shotgun) and never moves on to the ones it could buy.
local oldGetIsHardCappedForBots = CombatUpgrade.GetIsHardCappedForBots
function CombatUpgrade:GetIsHardCappedForBots(player)

	if oldGetIsHardCappedForBots(self, player) then
		return true
	end

	local mutuallyExclusive = self:GetMutuallyExclusive()
	if mutuallyExclusive then
		for _, upgradeId in ipairs(mutuallyExclusive) do
			if player:GetHasCombatUpgrade(upgradeId) then
				return true
			end
		end
	end

	if SCA_GetHiveTraitBlockersForPlayer and SCA_GetHiveTraitBlockersForPlayer(player, self:GetTechId()) then
		return true
	end

	return false

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
