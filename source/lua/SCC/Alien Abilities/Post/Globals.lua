-- File: lua/MyOverlay/NoXenocide_Post.lua
-- Hook:
-- ModLoader.SetupFileHook("lua/Combat/ExperienceData.lua", "lua/MyOverlay/NoXenocide_Post.lua", "post")

if not kCombatCompMode and type(kCombatAlienTierThreeTechIds) == "table" then
    -- remove Xenocide if present (handle duplicates safely)
    for i = #kCombatAlienTierThreeTechIds, 1, -1 do
        if kCombatAlienTierThreeTechIds[i] == kTechId.Xenocide then
            table.remove(kCombatAlienTierThreeTechIds, i)
        end
    end
end