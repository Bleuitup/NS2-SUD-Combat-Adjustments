-- Hive trait rule
--
-- Aliens cannot stack traits from one hive type. A trait is locked while another hive type has
-- fewer traits than the one it belongs to, so the picks have to go around: one from each hive
-- type before a second from any, two from each before a third.
--
-- A hive type with nothing left to buy never blocks (all of its traits owned, or none on offer,
-- as with the Shade traits in Combat's competitive mode).
--
-- Ink-Taunt is not a hive trait and is not counted.
--
-- This file holds the rule itself and runs on both sides. The server applies it when an upgrade
-- is bought (Upgrade Rules/Post/Combat/Player_Upgrades.lua), the client uses it to lock buttons
-- in the evolve menu.

local kHiveTraits =
{
    { name = "Crag",  techIds = { kTechId.Carapace, kTechId.Regeneration, kTechId.Vampirism } },
    { name = "Shift", techIds = { kTechId.Celerity, kTechId.Adrenaline, kTechId.Crush } },
    { name = "Shade", techIds = { kTechId.Camouflage, kTechId.Aura, kTechId.Focus } },
}

local function GetHiveForTrait(techId)

    for _, hive in ipairs(kHiveTraits) do
        if table.icontains(hive.techIds, techId) then
            return hive
        end
    end

    return nil

end

-- Returns nil when techId can be taken (or is not a hive trait at all). Otherwise returns the
-- hive types that need a trait first, as a list of { name = "Shift", traits = { techId, ... } }
-- where traits are the ones still on offer there.
--
-- hasTrait(techId) tells whether the player holds that trait.
function SCA_GetHiveTraitBlockers(techId, hasTrait)

    local ownHive = GetHiveForTrait(techId)
    if not ownHive then
        return nil
    end

    local ownCount = 0
    for _, traitTechId in ipairs(ownHive.techIds) do
        if traitTechId ~= techId and hasTrait(traitTechId) then
            ownCount = ownCount + 1
        end
    end

    local blockers = {}
    for _, hive in ipairs(kHiveTraits) do

        if hive ~= ownHive then

            local count = 0
            local onOffer = {}
            for _, traitTechId in ipairs(hive.techIds) do
                if hasTrait(traitTechId) then
                    count = count + 1
                elseif GetUpgradeFromTechId(traitTechId) then
                    table.insert(onOffer, traitTechId)
                end
            end

            if count < ownCount and #onOffer > 0 then
                table.insert(blockers, { name = hive.name, traits = onOffer })
            end

        end

    end

    if #blockers == 0 then
        return nil
    end

    return blockers

end

-- Chat message for a refused purchase, e.g.
-- "Regeneration is locked. Take a Shift trait and a Shade trait first."
function SCA_GetHiveTraitLockMessage(upgradeDescription, blockers)

    local parts = {}
    for _, blocker in ipairs(blockers) do
        table.insert(parts, string.format("a %s trait", blocker.name))
    end

    return string.format("%s is locked. Take %s first.", upgradeDescription, table.concat(parts, " and "))

end

-- Puts the hive traits of one purchase into an order the rule accepts and leaves everything else
-- where it was, ahead of them. Traits that stay locked whatever the order go last; the purchase
-- itself refuses those.
function SCA_OrderHiveTraitPurchases(player, upgrades)

    -- Traits the player owns, plus the ones already placed in the new order.
    local held = {}
    for _, hive in ipairs(kHiveTraits) do
        for _, traitTechId in ipairs(hive.techIds) do
            local trait = GetUpgradeFromTechId(traitTechId)
            if trait and player:GetHasCombatUpgrade(trait:GetId()) then
                held[traitTechId] = true
            end
        end
    end

    local function hasTrait(traitTechId)
        return held[traitTechId] == true
    end

    local ordered = {}
    local traits = {}
    for _, upgrade in ipairs(upgrades) do
        local techId = upgrade:GetTechId()
        if GetHiveForTrait(techId) and not held[techId] then
            table.insert(traits, upgrade)
        else
            table.insert(ordered, upgrade)
        end
    end

    while #traits > 0 do

        local pick
        for i, upgrade in ipairs(traits) do
            if not SCA_GetHiveTraitBlockers(upgrade:GetTechId(), hasTrait) then
                pick = i
                break
            end
        end

        if not pick then
            break
        end

        local upgrade = table.remove(traits, pick)
        held[upgrade:GetTechId()] = true
        table.insert(ordered, upgrade)

    end

    for _, upgrade in ipairs(traits) do
        table.insert(ordered, upgrade)
    end

    return ordered

end
