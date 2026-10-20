-- Adds the SCA changelog button (the mate gourd) next to the Wiki and Discord buttons, in the main
-- menu and in the in-game menu (GUIMainMenuInGame inherits this method). Vanilla's comment on
-- CreateLinksButtons: "Method so that mods can easily add their own buttons."

Script.Load("lua/SCA/Changelog/Shared/GUISCAChangelogButton.lua")

local oldCreateLinksButtons = GUIMainMenu.CreateLinksButtons

function GUIMainMenu:CreateLinksButtons()

    oldCreateLinksButtons(self)

    CreateGUIObject("scaChangelogButton", GUISCAChangelogButton, self.linkButtonsHolder)

end
