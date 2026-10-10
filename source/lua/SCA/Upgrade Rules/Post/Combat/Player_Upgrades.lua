-- Combat's Player:CoEnableUpgrade with two rules added. The rest is Combat's code, kept in the
-- same order so the two can be compared side by side:
--   1. An upgrade's requirement can be met by any one of several upgrades
--      (CombatUpgrade:GetAllRequirements).
--   2. Hive traits are locked by the hive trait rule when the "Hive Traits" piece is loaded.

local kSpendResourcesSoundName = PrecacheAsset("sound/NS2.fev/marine/common/player_spend_nanites")

-- "sg or hmg", for the "You need ... first" hint.
local function GetRequirementsText(upgrade)

	local textCodes = {}
	for _, upgradeId in ipairs(upgrade:GetAllRequirements()) do
		table.insert(textCodes, GetUpgradeFromId(upgradeId):GetTextCode())
	end

	return table.concat(textCodes, " or ")

end

function Player:CoEnableUpgrade(upgrades)

	self:CheckCombatData()
	local validUpgrades = {}
	local newPosition
	-- support multiple upgrades

	-- The evolve menu sends every selected trait in one go, in menu order. Put them in an order
	-- the hive trait rule accepts, or a legal selection would be refused halfway.
	if SCA_OrderHiveTraitPurchases then
		upgrades = SCA_OrderHiveTraitPurchases(self, upgrades)
	end

	for _, upgrade in ipairs(upgrades) do

        local alreadyGotUpgrade = false
        local noRoom = false
        local notInTechRange = false
		local heavyTechCooldown = false
		local mutuallyExclusive = false
		local hardCapped = upgrade:GetIsHardCapped(self)
		local nearComm = upgrade:GetNeedsNearComm()
		local mutuallyExclusiveDescription = ""
        local gotRequirements = upgrade:GetHasRequirements(function(upgradeId) return self:GetHasCombatUpgrade(upgradeId) end)
        local techId = upgrade:GetTechId()
        local neededLvl = upgrade:GetLevels()
        local team = upgrade:GetTeam()
		--local desc = upgrade:GetDescription()

        -- Loop over the other items in the player's tech tree.
        for _, entry in ipairs(self.combatTable.techtree) do

            -- do i have the Up already?
            if entry:GetId() == upgrade:GetId() then
               alreadyGotUpgrade = true
            end

			-- Check for whether we have a mutually exclusive upgrade here...
			if upgrade:GetMutuallyExclusive() then
				for _, mutuallyExclusiveUpgrade in ipairs(upgrade:GetMutuallyExclusive()) do
					if entry:GetId() == mutuallyExclusiveUpgrade then
						mutuallyExclusive = true
						mutuallyExclusiveDescription = entry:GetDescription()
					end
				end
			end
        end

        -- Hive trait rule, checked against what the player owns right now. That includes the
        -- upgrades accepted earlier in this same purchase.
        local hiveTraitLockMessage
        if not alreadyGotUpgrade and SCA_GetHiveTraitBlockersForPlayer then
            local blockers = SCA_GetHiveTraitBlockersForPlayer(self, techId)
            if blockers then
                hiveTraitLockMessage = SCA_GetHiveTraitLockMessage(upgrade:GetDescription(), blockers)
            end
        end

        -- Check whether we have room to evolve and the player is near a hive/command station for evolving to onos/exo
        if self:isa("Alien") then
            local lifeFormTechId = kTechId.Skulk
            if self:GetIsAlive() and not hardCapped then
                if upgrade:GetType() == kCombatUpgradeTypes.Class then
                    lifeFormTechId = self:GetTechId()
                else
                    lifeFormTechId = techId
                end
            end

            local position, success = self:HasRoomToEvolve(lifeFormTechId)

            if not success then
                noRoom = true
			else
				newPosition = position
			end

            if nearComm and not hardCapped then
				if (Shared.GetTime() - self.combatTable.timeLastHeavyTech) < kHeavyTechCooldown then
					heavyTechCooldown = true
				else
					if #GetEntitiesForTeamWithinRange("CommandStructure", self:GetTeamNumber(), self:GetOrigin(), kTechRange) == 0 then
						notInTechRange = true
					else
						self.combatTable.timeLastHeavyTech = Shared.GetTime()
					end
				end
			end
        else
            if nearComm and not hardCapped then

				if (Shared.GetTime() - self.combatTable.timeLastHeavyTech) < kHeavyTechCooldown then
					heavyTechCooldown = true
				else

					if #GetEntitiesForTeamWithinRange("CommandStructure", self:GetTeamNumber(), self:GetOrigin(), kTechRange) == 0 then
						notInTechRange = true
					else
						self.combatTable.timeLastHeavyTech = Shared.GetTime()
					end
				end
            end
        end

        -- Sanity checks before we actually go further.
        if not gotRequirements then
            self:spendlvlHints("neededOtherUp", GetRequirementsText(upgrade))
        elseif (not self:isa(team)) and not (self:isa("Exo") and team == "Marine") then
            self:spendlvlHints("wrong_team", team)
		elseif hardCapped then
			self:spendlvlHints("hardCapped", upgrade:GetTextCode())
        elseif alreadyGotUpgrade then
            self:spendlvlHints("already_owned", upgrade:GetTextCode())
        elseif hiveTraitLockMessage then
            self:SendDirectMessage(hiveTraitLockMessage)
        elseif noRoom then
            self:spendlvlHints("no_room")
        elseif notInTechRange then
            self:spendlvlHints("not_in_techrange", team)
		elseif heavyTechCooldown then
            self:spendlvlHints("heavytech_cooldown", team)
        elseif self:GetLvlFree() < neededLvl then
            self:spendlvlHints("neededLvl", neededLvl)
		elseif mutuallyExclusive then
			self:spendlvlHints("mutuallyExclusive", mutuallyExclusiveDescription)
        else
            table.insert(validUpgrades, upgrade)
            -- insert the up to the personal techtree
            table.insert(self.combatTable.techtree, upgrade)
            -- subtract the needed lvl
            self:SubtractLvlFree(neededLvl)

            local pointText = (neededLvl > 1) and "points" or "point"
            self:SendDirectMessage(upgrade:GetDescription() .. " purchased for " .. neededLvl .. " upgrade " .. pointText)

			if self:isa("Marine") or self:isa("Exo") then
				Shared.PlayPrivateSound(self, kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())
			end

            -- Special logic for alien lifeforms
            if self:isa("Alien") and upgrade:GetType() == kCombatUpgradeTypes.Class then
                self.combatTable.currentLifeForm = upgrade
            end
        end
	end

	-- Apply all missing upgrades.
    if table.maxn(validUpgrades) > 0 then
        if self:isa("Alien")  then
            -- special treatment for aliens cause they will hatch with all upgrades)
            self:ApplyAllUpgrades(nil, validUpgrades)
        else
            for _, upgrade in ipairs(validUpgrades) do
				-- Refund the mutually exclusive upgrades if we bought e.g. exo...
				-- call it first before ApplyAllUpgrades, or the efundMutuallyExclusiveUpgrades function is not getting called right
				self:RefundMutuallyExclusiveUpgrades(upgrade)
                self:ApplyAllUpgrades(nil, upgrade)
            end
        end
    end

end
