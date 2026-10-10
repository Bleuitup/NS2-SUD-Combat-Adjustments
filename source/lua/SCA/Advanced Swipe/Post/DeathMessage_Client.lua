-- The Advanced Swipe kill feed icon is the row added below vanilla's 51 in ui/inventory_icons.dds
-- (row 51, counting from 0). Its enum number is taken dynamically in Globals.lua, so pin the
-- texture row here rather than trusting the number.
local kAdvancedSwipeIconCell = 51
local kSubImageHeight = 64

local oldGetTechOffsetY = DeathMsgUI_GetTechOffsetY
function DeathMsgUI_GetTechOffsetY(iconIndex)
    if iconIndex and iconIndex == kDeathMessageIcon.AdvancedSwipe then
        return kAdvancedSwipeIconCell * kSubImageHeight
    end
    return oldGetTechOffsetY(iconIndex)
end
