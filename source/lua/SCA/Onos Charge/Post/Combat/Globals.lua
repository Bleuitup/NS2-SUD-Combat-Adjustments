-- Charge comes with the Onos, as it does in vanilla now. Combat still treats it as an ability
-- that has to be unlocked and hands it out with Tier 2. Taking it off that list leaves Tier 2
-- with Bone Shield and Tier 3 with Stomp.
--
-- The list only decides what the evolve menu shows as unlocked. What actually lets the Onos
-- charge is in NS2Utility.lua in this piece.
table.removevalue(kCombatAlienTierTwoTechIds, kTechId.Charge)
