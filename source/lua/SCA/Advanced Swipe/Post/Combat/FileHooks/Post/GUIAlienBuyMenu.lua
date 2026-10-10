-- Evolve menu: Advanced Swipe is only on offer while the Fade is the lifeform shown in the menu.
-- That is a Fade looking at its own menu, or a Skulk that has picked the Fade to evolve into.
-- Pick another lifeform, or come back as a Skulk, and the button is gone again.
--
-- The menu puts every button at one of two stored positions each frame, so a button that is
-- not on offer gets both of them moved off screen: it can then be neither seen, hovered nor
-- clicked.
local kOffScreen = Vector(-100000, -100000, 0)

local oldUpdate = GUIAlienBuyMenu.Update
function GUIAlienBuyMenu:Update(deltaTime)

    local offered = self.selectedAlienType == AlienTechIdToIndex(kTechId.Fade)

    for _, currentButton in ipairs(self.upgradeButtons) do

        if currentButton.TechId == kTechId.AdvancedSwipe then

            if not currentButton.scaUnselectedPosition then
                currentButton.scaUnselectedPosition = currentButton.UnselectedPosition
                currentButton.scaSelectedPosition = currentButton.SelectedPosition
            end

            if offered then

                currentButton.UnselectedPosition = currentButton.scaUnselectedPosition
                currentButton.SelectedPosition = currentButton.scaSelectedPosition

            else

                currentButton.UnselectedPosition = kOffScreen
                currentButton.SelectedPosition = kOffScreen

                -- Selected for a Fade that is no longer picked: do not buy it for another lifeform.
                if currentButton.Selected and not currentButton.Purchased then
                    currentButton.Selected = false
                    table.removevalue(self.upgradeList, currentButton.TechId)
                end

            end

            currentButton.Icon:SetIsVisible(offered)

        end

    end

    oldUpdate(self, deltaTime)

end
