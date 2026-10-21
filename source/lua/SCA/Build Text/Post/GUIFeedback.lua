-- The build text in the top left corner of the menu, e.g.
--   Build 344 - NS2 Combat 6.2 + NS2 SUD Combat Adjustments v1.15b
local kSCAVersion = "1.15b" -- update on every release

local oldInitialize = GUIFeedback.Initialize
function GUIFeedback:Initialize()
    oldInitialize(self)

    local combat = kCombatVersion and ("NS2 Combat " .. tostring(kCombatVersion)) or "NS2 Combat"
    local oldText = self.buildText:GetText()
    local newText = oldText .. " - " .. combat .. " + NS2 SUD Combat Adjustments v" .. kSCAVersion

    self.buildText:SetText(newText)
end
