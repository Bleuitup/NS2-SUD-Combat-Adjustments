-- Only load these changes inside the Server VM
if not Server then return end

-- Assisters share kill XP.
--
-- Combat gives a kill's XP to the killer (even if dead) and to every teammate who is alive and
-- either within 15 m of the victim or within 40 m and able to see it. Damage plays no part. Here
-- the receivers also include every enemy of the victim who dealt more than 10% of its health and
-- armor (armor counting double, as vanilla weighs damage for assists), wherever they are and even
-- if they have died since. The split is Combat's: each receiver gets 10% of the kill's value plus
-- an equal share of the other 90%, plus their own level bonus.
--
-- The 40 m line-of-sight share is dropped: it stood in for long-range help before damage counted,
-- and the assisters above cover that now. Teammates within 15 m still share.
--
-- Only damage since the victim was last at full health and armor counts (see Player_Server.lua
-- and NS2Gamerules.lua in this piece, for players and for everything else). The scoreboard's
-- assist count is vanilla's and is not changed.

local kAssistDamageFraction = 0.1

-- Ids of the non-players holding a record, checked for a full heal in NS2Gamerules.lua.
SCA_AssistRecordHolders = {}

-- SCA's own damage record, kept next to vanilla's (self.damagePoints) so it can be cleared on a
-- full heal without touching the scoreboard's assists.
local function GetRecord(self)
    if not self.scaAssistDamage then
        self.scaAssistDamage = { attackers = {} }
        if not self:isa("Player") then
            SCA_AssistRecordHolders[self:GetId()] = true
        end
    end
    return self.scaAssistDamage
end

function PointGiverMixin:ClearAssistDamage()
    self.scaAssistDamage = nil
end

local oldOnTakeDamage = PointGiverMixin.OnTakeDamage
function PointGiverMixin:OnTakeDamage(damage, attacker, ...)

    if oldOnTakeDamage then
        oldOnTakeDamage(self, damage, attacker, ...)
    end

    if attacker and attacker:isa("Player") and GetAreEnemies(self, attacker) then

        local record = GetRecord(self)
        local attackerId = attacker:GetId()

        if not record[attackerId] then
            record[attackerId] = 0
            table.insert(record.attackers, attackerId)
        end

        record[attackerId] = record[attackerId] + damage

    end

end

-- A player who dies or evolves becomes a new entity; vanilla moves its damage over to the new
-- id, and so does this.
local oldOnEntityChange = PointGiverMixin.OnEntityChange
function PointGiverMixin:OnEntityChange(oldId, newId)

    if oldOnEntityChange then
        oldOnEntityChange(self, oldId, newId)
    end

    local record = self.scaAssistDamage
    if record and record[oldId] then
        if newId and newId ~= Entity.invalidId then
            record[newId] = (record[newId] or 0) + record[oldId]
            table.insertunique(record.attackers, newId)
        end
        record[oldId] = nil
        table.removevalue(record.attackers, oldId)
    end

end

-- Everyone who dealt more than kAssistDamageFraction of the victim's health and armor.
function SCA_GetXpAssisters(dying)

    local record = dying.scaAssistDamage
    if not record then
        return {}
    end

    local totalDamage = dying:GetMaxHealth() + dying:GetMaxArmor() * 2
    local assisters = {}

    for _, attackerId in ipairs(record.attackers) do
        local attacker = Shared.GetEntity(attackerId)
        if attacker and attacker:isa("Player") and totalDamage > 0
           and record[attackerId] / totalDamage > kAssistDamageFraction then
            table.insert(assisters, attacker)
        end
    end

    return assisters

end

-- Combat's GiveXpForKill with the assisters added to the receivers and no line-of-sight share.
function PointGiverMixin:GiveXpForKill(dying, killer)

    local baseXp = GetXpValue(dying)

    local playersInRange = GetEntitiesForTeamWithinRange("Player", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), assistXPRange)

    local receivers = {}
    local function Add(player)
        if not table.icontains(receivers, player) then
            table.insert(receivers, player)
        end
    end

    -- always include the killer even if they are dead!
    if killer then
        Add(killer)
    end

    for _, player in ipairs(playersInRange) do
        if player:GetIsAlive() and killer ~= player then

            -- within 15 m, Combat's own close-range check
            if (self:GetOrigin() - player:GetOrigin()):GetLength() < assistXPRange then
                Add(player)
            end

        end
    end

    -- assisters, wherever they are and alive or not
    for _, player in ipairs(SCA_GetXpAssisters(dying)) do
        if player:GetTeamNumber() ~= dying:GetTeamNumber() then
            Add(player)
        end
    end

    baseXp = baseXp * assistXpAmount

    if #receivers > 0 then

        local xpPerPlayer = math.ceil(baseXp / #receivers * assistPlayerRatio + baseXp * (1 - assistPlayerRatio))
        for _, player in ipairs(receivers) do
            local bonusXp = GetXpLevelDiff(dying, player)
            player:AddXp(xpPerPlayer + bonusXp)
        end

    end

end
