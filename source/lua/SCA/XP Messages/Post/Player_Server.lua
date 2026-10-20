-- Only load these changes inside the Server VM
if not Server then return end

-- Tells each player where their XP comes from.
--
-- Combat gives XP through Player:AddXp from many places. The code around each of those places
-- (wrapped in the other files of this piece) pushes a "source" on a stack before Combat runs and
-- pops it after; AddXp reads the top of the stack. A kill's source is worked out per receiver: the
-- killer, an assister (SCA's Assist XP piece), a teammate nearby, or nobody killed it.
--
-- Hive, Command Station and Armory damage, welding and healing come in many small amounts, so
-- they are added up and sent at most every kBatchInterval seconds. Everything else is sent at once.

local kBatchInterval = 0.25

local sourceStack = {}

function SCA_PushXpSource(source)
    table.insert(sourceStack, source)
end

function SCA_PopXpSource()
    table.remove(sourceStack)
end

-- Called every server tick from NS2Gamerules.lua, where no source can be active. Clears anything
-- an error might have left behind so it can't label later XP.
function SCA_ResetXpSources()
    if #sourceStack > 0 then
        sourceStack = {}
    end
end

-- Runs fn with source on top of the stack.
function SCA_WithXpSource(source, fn, ...)
    SCA_PushXpSource(source)
    fn(...)
    SCA_PopXpSource()
end

local kBatched =
{
    [kSCAXpSource.Damage] = true,
    [kSCAXpSource.Weld] = true,
    [kSCAXpSource.Heal] = true,
}

local pending = {}   -- [player entity id] = { [key] = message }
local nextFlushTime = 0

local function Send(player, message)
    Server.SendNetworkMessage(player, "SCAXpGain", message, true)
end

local function Classify(player, source)

    local message = { amount = 0, bonus = 0, source = kSCAXpSource.Other, target = "", targetIsPlayer = false }

    if not source then
        return message
    end

    message.source = source.source

    local target = source.target
    if target then
        message.target = target:GetClassName()
        message.targetIsPlayer = target:isa("Player")
    end

    if source.source == kSCAXpSource.Kill then

        if source.killer == player then
            message.source = kSCAXpSource.Kill
        elseif source.assisters and table.icontains(source.assisters, player) then
            message.source = kSCAXpSource.Assist
        elseif source.killer then
            message.source = kSCAXpSource.Nearby
        else
            message.source = kSCAXpSource.DiedNearby
        end

        if source.levelBonus and target then
            message.bonus = GetXpLevelDiff(target, player)
        end

    end

    return message

end

local function QueueXpGain(player, amount)

    if player:GetIsVirtual() then
        return
    end

    local message = Classify(player, sourceStack[#sourceStack])
    message.amount = amount
    message.bonus = math.min(message.bonus, amount)

    if not kBatched[message.source] then
        Send(player, message)
        return
    end

    local playerId = player:GetId()
    pending[playerId] = pending[playerId] or {}

    local key = message.source .. "|" .. message.target
    local queued = pending[playerId][key]
    if queued then
        queued.amount = queued.amount + amount
    else
        pending[playerId][key] = message
    end

end

-- Called every server tick from NS2Gamerules.lua.
function SCA_FlushXpGains()

    local now = Shared.GetTime()
    if now < nextFlushTime then
        return
    end
    nextFlushTime = now + kBatchInterval

    for playerId, messages in pairs(pending) do
        local player = Shared.GetEntity(playerId)
        if player and player:isa("Player") then
            for _, message in pairs(messages) do
                Send(player, message)
            end
        end
    end

    pending = {}

end

-- Only what the player actually got: nothing past the top level, where Combat stops counting.
local oldAddXp = Player.AddXp
function Player:AddXp(amount)

    local before = self:GetXp()
    oldAddXp(self, amount)
    local gained = self:GetXp() - before

    if gained > 0 then
        QueueXpGain(self, gained)
    end

end

-- Combat's catch-up, with the chat message replaced by this piece's display.
function Player:BalanceXp(avgXp)

    local xpDiff = avgXp - self:GetXp()
    if xpDiff > 0 then
        SCA_WithXpSource({ source = kSCAXpSource.CatchUp }, self.AddXp, self, xpDiff)
    end

end
