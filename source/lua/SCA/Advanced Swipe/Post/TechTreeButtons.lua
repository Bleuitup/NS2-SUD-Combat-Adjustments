
local kTechIdToMaterialOffset = debug.getupvaluex(GetMaterialXYOffset, "kTechIdToMaterialOffset")

-- ui/buildmenu.dds is vanilla's sheet with one more row at the bottom. Vanilla ends at cell 191
-- (16 rows of 12); the Advanced Swipe icon is the first cell of the new row.
if kTechIdToMaterialOffset then
    kTechIdToMaterialOffset[kTechId.AdvancedSwipe] = 192
end
