-- Menu button that opens the SCA changelog. Taken from Blast to the Past's changelog button.
--
-- The icon is a mate gourd, 160x160 uncompressed RGBA with mipmaps, the same format as vanilla's
-- ui/newMenu/wikiButton.dds. GUIMenuPowerButton fades the hover texture in over the regular one,
-- so the two states are drawn at the same size and position.

Script.Load("lua/menu2/GUIMenuExitButton.lua")
Script.Load("lua/menu2/wrappers/Tooltip.lua")

Script.Load("lua/SCA/Changelog/Shared/GUISCAChangelogWindow.lua")

local baseClass = GUIMenuExitButton
baseClass = GetTooltipWrappedClass(baseClass)
class "GUISCAChangelogButton" (baseClass)

GUISCAChangelogButton.kTextureRegular = PrecacheAsset("ui/sca_changelog_icon.dds")
GUISCAChangelogButton.kTextureHover   = PrecacheAsset("ui/sca_changelog_icon_over.dds")

GUISCAChangelogButton.kShadowScale = Vector(10, 5, 1)

function GUISCAChangelogButton:OnPressed()
    self.changelog:Open()
end

function GUISCAChangelogButton:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1
    baseClass.Initialize(self, params, errorDepth)

    self:SetTooltip("NS2 SUD Combat Adjustments Changelog")

    self.changelog = CreateGUIObject("scaChangelog", GUISCAChangelogWindow, nil)
    self:HookEvent(GetMainMenu(), "OnClosed", self.OnMainMenuClosed)

    -- Parented to nil, the window would draw under overlays like the server browser. The nav bar
    -- sits above them and carries the menu's resolution scale, so the window moves onto it once
    -- the nav bar exists (it doesn't yet when the link buttons are made, hence the poll).
    self.callback = self:AddTimedCallback(self.NavBarPollCallback, 0.5, true)

end

function GUISCAChangelogButton:NavBarPollCallback()
    local navBar = GetNavBar()
    if not navBar then return end

    self.changelog:SetParent(navBar)

    self:RemoveTimedCallback(self.callback)
    self.callback = nil
end

function GUISCAChangelogButton:OnMainMenuClosed()
    self.changelog:Close()
end
