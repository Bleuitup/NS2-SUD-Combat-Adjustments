-- Lines above Combat's XP bar saying how much XP you just got and why:
--
--     +26 XP  Killed a Lerk
--     +8.4 XP  Damaging the Hive
--
-- The amount is in the larger font, the reason in the smaller one. A new gain of the same kind on
-- the same target adds to the line already showing instead of starting a new one, so welding or
-- shooting the Hive builds up on one line. A line stays for kHoldTime seconds after its last gain,
-- then fades out. At most kMaxLines show; a new one pushes the oldest out.
--
-- Position: above vanilla's inventory (weapon icons and ammo for marines, abilities for aliens,
-- Options > Advanced > INVENTORY), measured from the HUD itself every frame, so it follows the
-- GUI scale, the resolution and the ammo modes. It is measured even while the inventory is faded
-- out, so the lines don't jump each time it appears. With no inventory (option set to HIDE, Exo,
-- dead) the lines sit just above Combat's XP bar instead. kBottomOffset is in plain pixels, like
-- the XP bar (GUIExperienceBar.lua); fonts and line spacing follow the game's GUI scale.

class 'GUISCAXpMessages' (GUIScript)

local kMaxLines = 4
local kHoldTime = 3
local kCatchUpHoldTime = 5
local kFadeTime = 1

local kBottomOffset = -82   -- center of the lowest line, clear of the XP bar and its level text
local kInventoryGap = 8     -- between the top of the inventory and the lowest line
local kLineSpacing = 34
local kGap = 10             -- between the amount and the reason
local kShadowOffset = 2

local kAmountFont = Fonts.kAgencyFB_Medium
local kReasonFont = Fonts.kAgencyFB_Small
local kReasonColor = Color(0.92, 0.92, 0.92, 1)
local kShadowColor = Color(0, 0, 0, 0.8)

-- Sources that count separate events, shown as "(x2)" when more than one adds to a line.
local kCountedSources =
{
    [kSCAXpSource.Kill] = true,
    [kSCAXpSource.Assist] = true,
    [kSCAXpSource.Nearby] = true,
    [kSCAXpSource.DiedNearby] = true,
}

-- Text ----------------------------------------------------------------------------------------

local kNames =
{
    JetpackMarine = "Jetpack Marine",
    CommandStation = "Command Station",
    PowerPoint = "Power Node",
    TunnelEntrance = "Tunnel",
    TunnelExit = "Tunnel",
}

local kEmptyExosuit = { en = "empty Exosuit", es = "Exosuit vacío", pt = "Exosuit vazio" }

local kText =
{
    en =
    {
        kill = "Killed %s", killStructure = "Destroyed %s",
        assist = "Assisted on %s kill", assistStructure = "Helped destroy %s",
        nearby = "Teammate killed %s nearby", nearbyStructure = "Teammate destroyed %s nearby",
        died = "%s died nearby", diedStructure = "%s was destroyed nearby",
        damage = "Damaging the %s",
        weldPlayers = "Welding teammates", weld = "Welding the %s",
        heal = "Healing",
        catchUp = "Catch-up to the team average",
        bonus = " (+%d for higher level)",
    },
    es =
    {
        kill = "Kill: %s", killStructure = "Destrucción: %s",
        assist = "Asistencia: %s", assistStructure = "Asistencia: %s",
        nearby = "Kill cercana de tu equipo: %s", nearbyStructure = "Destrucción cercana de tu equipo: %s",
        died = "Muerte cercana: %s", diedStructure = "Destrucción cercana: %s",
        damage = "Dañando: %s",
        weldPlayers = "Soldando compañeros", weld = "Soldando: %s",
        heal = "Curando",
        catchUp = "Nivelación al promedio del equipo",
        bonus = " (+%d por nivel más alto)",
    },
    pt =
    {
        kill = "Abate: %s", killStructure = "Destruição: %s",
        assist = "Assistência: %s", assistStructure = "Assistência: %s",
        nearby = "Abate de um aliado perto: %s", nearbyStructure = "Destruição de um aliado perto: %s",
        died = "Morte próxima: %s", diedStructure = "Destruição próxima: %s",
        damage = "Danificando: %s",
        weldPlayers = "Soldando aliados", weld = "Soldando: %s",
        heal = "Curando",
        catchUp = "Recuperação até a média do time",
        bonus = " (+%d por nível mais alto)",
    },
}

local kLocaleToLanguage = { esES = "es", ptBR = "pt" }

local function GetLanguage()
    return kLocaleToLanguage[Client.GetOptionString("locale", "enUS")] or "en"
end

local function GetName(className, language)
    if className == "Exosuit" then
        return kEmptyExosuit[language]
    end
    -- "PhaseGate" -> "Phase Gate"
    return kNames[className] or string.gsub(className, "(%l)(%u)", "%1 %2")
end

-- English only: "a Lerk", "an Onos". Spanish and Portuguese name the target after a colon.
local function WithArticle(name, language, capitalize)
    if language ~= "en" then
        return name
    end
    local article = string.find(name, "^[AEIOUaeiou]") and "an " or "a "
    if capitalize then
        article = string.upper(string.sub(article, 1, 1)) .. string.sub(article, 2)
    end
    return article .. name
end

local function GetReason(line, language)

    local text = kText[language]
    local source = line.source
    local name = GetName(line.target, language)
    local isPlayer = line.targetIsPlayer

    local reason
    if source == kSCAXpSource.Kill then
        reason = string.format(isPlayer and text.kill or text.killStructure, WithArticle(name, language))
    elseif source == kSCAXpSource.Assist then
        reason = string.format(isPlayer and text.assist or text.assistStructure, WithArticle(name, language))
    elseif source == kSCAXpSource.Nearby then
        reason = string.format(isPlayer and text.nearby or text.nearbyStructure, WithArticle(name, language))
    elseif source == kSCAXpSource.DiedNearby then
        reason = string.format(isPlayer and text.died or text.diedStructure, WithArticle(name, language, true))
    elseif source == kSCAXpSource.Damage then
        reason = string.format(text.damage, name)
    elseif source == kSCAXpSource.Weld then
        reason = isPlayer and text.weldPlayers or string.format(text.weld, name)
    elseif source == kSCAXpSource.Heal then
        reason = text.heal
    elseif source == kSCAXpSource.CatchUp then
        reason = text.catchUp
    else
        return ""
    end

    if line.count > 1 then
        reason = reason .. string.format(" (x%d)", line.count)
    end

    if line.bonus >= 1 then
        reason = reason .. string.format(text.bonus, math.floor(line.bonus + 0.5))
    end

    return reason

end

local function GetAmountText(amount, language)
    local text
    if amount >= 10 then
        text = string.format("+%d XP", math.floor(amount + 0.5))
    else
        text = string.gsub(string.format("+%.1f XP", amount), "%.0 XP$", " XP")
    end
    if language ~= "en" then
        text = string.gsub(text, "%.", ",")
    end
    return text
end

-- Script -------------------------------------------------------------------------------------

local function CreateText(font)
    local item = GUIManager.CreateTextItem()
    item:SetFontName(font)
    item:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    item:SetTextAlignmentX(GUIItem.Align_Min)
    item:SetTextAlignmentY(GUIItem.Align_Center)
    return item
end

local function DestroyLine(line)
    for _, item in ipairs(line.items) do
        GUI.DestroyItem(item)
    end
    line.items = {}
end

function GUISCAXpMessages:Initialize()
    self.lines = {}
    SCA_XpMessagesGUI = self
end

function GUISCAXpMessages:Uninitialize()
    for _, line in ipairs(self.lines) do
        DestroyLine(line)
    end
    self.lines = {}
    if SCA_XpMessagesGUI == self then
        SCA_XpMessagesGUI = nil
    end
end

local function GetAmountColor()
    local player = Client.GetLocalPlayer()
    if player and player:GetTeamNumber() == kTeam2Index then
        return kAlienTeamColorFloat
    end
    return kMarineTeamColorFloat
end

-- Sets the line's text and works out its width, so the amount and reason sit centered as a pair.
local function UpdateLineText(line)

    local language = GetLanguage()
    local amountText = GetAmountText(line.amount, language)
    local reasonText = GetReason(line, language)

    line.amountShadow:SetText(amountText)
    line.amountItem:SetText(amountText)
    line.reasonShadow:SetText(reasonText)
    line.reasonItem:SetText(reasonText)

    line.amountWidth = line.amountItem:GetTextWidth(amountText)
    line.reasonWidth = reasonText ~= "" and line.reasonItem:GetTextWidth(reasonText) or 0

end

function GUISCAXpMessages:AddGain(message)

    local now = Shared.GetTime()

    -- Welding any teammate is one line, whoever it is.
    local target = message.target
    if message.source == kSCAXpSource.Weld and message.targetIsPlayer then
        target = "players"
    end
    local key = message.source .. "|" .. target

    local holdTime = message.source == kSCAXpSource.CatchUp and kCatchUpHoldTime or kHoldTime

    for _, line in ipairs(self.lines) do
        if line.key == key then
            line.amount = line.amount + message.amount
            line.bonus = line.bonus + message.bonus
            if kCountedSources[message.source] then
                line.count = line.count + 1
            end
            line.holdUntil = now + holdTime
            UpdateLineText(line)
            return
        end
    end

    if #self.lines >= kMaxLines then
        DestroyLine(self.lines[1])
        table.remove(self.lines, 1)
    end

    local line =
    {
        key = key,
        source = message.source,
        target = message.target,
        targetIsPlayer = message.targetIsPlayer,
        amount = message.amount,
        bonus = message.bonus,
        count = 1,
        holdUntil = now + holdTime,
    }

    line.amountShadow = CreateText(kAmountFont)
    line.amountItem = CreateText(kAmountFont)
    line.reasonShadow = CreateText(kReasonFont)
    line.reasonItem = CreateText(kReasonFont)
    line.items = { line.amountShadow, line.amountItem, line.reasonShadow, line.reasonItem }

    UpdateLineText(line)
    table.insert(self.lines, line)

end

-- Inventory -----------------------------------------------------------------------------------

local kInventoryHidden = 1          -- Options > Advanced > INVENTORY: HIDE
local kInventoryAmmoModes = { [2] = true, [4] = true }   -- SHOW AMMO, ALWAYS ON + AMMO

-- Vanilla's layout (Hud/GUIInventory.lua), for when the HUD can't be read: icons 120 above the
-- bottom, 48 tall, ammo numbers in a row above them. Scaled by the GUI scale.
local kEstimatedInventoryTop = 120 + 48
local kEstimatedAmmoRow = 24

local function GetInventoryMode()
    return GUIInventory and GUIInventory.kInventoryMode or 0
end

local function GetShowsAmmo()
    return kInventoryAmmoModes[GetInventoryMode()] and PlayerUI_GetTeamType() == kMarineTeamType
end

-- Screen Y (pixels from the top) of the top of the inventory as the HUD drew it, or nil when there
-- is no inventory on screen.
local function MeasureInventoryTop()

    local hud = ClientUI.GetScript("Hud/Marine/GUIMarineHUD") or ClientUI.GetScript("GUIAlienHUD")
    if not hud then
        return nil, false
    end

    local inventory = hud.inventoryDisplay
    if not inventory or not inventory.background or not inventory.background:GetIsVisible() then
        return nil, true
    end

    local icons = inventory.inventoryIcons
    if not icons or #icons == 0 then
        return nil, true
    end

    local width, height = Client.GetScreenWidth(), Client.GetScreenHeight()
    local showsAmmo = GetShowsAmmo()

    local top
    for _, icon in ipairs(icons) do
        local y = icon.Graphic.guiItem:GetScreenPosition(width, height).y
        if showsAmmo then
            y = math.min(y, icon.AmmoDisplayCenter.guiItem:GetScreenPosition(width, height).y)
        end
        top = top and math.min(top, y) or y
    end

    return top, true

end

-- Vanilla's numbers, for a living marine or alien whose HUD was replaced by a mod.
local function EstimateInventoryTop(scale)

    local player = Client.GetLocalPlayer()
    if not player or not player:GetIsAlive() or not (player:isa("Marine") or player:isa("Alien")) then
        return nil
    end

    local height = kEstimatedInventoryTop + (GetShowsAmmo() and kEstimatedAmmoRow or 0)
    return Client.GetScreenHeight() - height * scale

end

-- Offset from the bottom of the screen for the center of the lowest line.
local function GetBottomOffset(scale)

    if GetInventoryMode() == kInventoryHidden then
        return kBottomOffset
    end

    -- A HUD mod could lay the inventory out differently; never let that break the XP lines.
    local ok, top, hudFound = pcall(MeasureInventoryTop)
    if not ok then
        top, hudFound = nil, false
    end
    if not top and not hudFound then
        top = EstimateInventoryTop(scale)
    end

    if not top then
        return kBottomOffset
    end

    local offset = top - Client.GetScreenHeight() - (kInventoryGap + kLineSpacing / 2) * scale
    return math.min(offset, kBottomOffset)

end

-- Update ---------------------------------------------------------------------------------------

function GUISCAXpMessages:Update(deltaTime)

    local now = Shared.GetTime()
    local scale = GUIScale(1)
    local amountColor = GetAmountColor()

    -- Drop lines that have faded out.
    for i = #self.lines, 1, -1 do
        local line = self.lines[i]
        if now >= line.holdUntil + kFadeTime then
            DestroyLine(line)
            table.remove(self.lines, i)
        end
    end

    -- Newest line at the bottom, older ones above it.
    local count = #self.lines
    local bottomOffset = count > 0 and GetBottomOffset(scale) or kBottomOffset
    for i, line in ipairs(self.lines) do

        local row = count - i
        local y = bottomOffset - row * kLineSpacing * scale

        local alpha = 1
        if now > line.holdUntil then
            alpha = Clamp(1 - (now - line.holdUntil) / kFadeTime, 0, 1)
        end

        local gap = line.reasonWidth > 0 and kGap or 0
        local totalWidth = (line.amountWidth + gap + line.reasonWidth) * scale
        local amountX = -totalWidth / 2
        local reasonX = amountX + (line.amountWidth + gap) * scale
        local shadow = kShadowOffset * scale

        for _, item in ipairs(line.items) do
            item:SetScale(Vector(scale, scale, 0))
        end

        line.amountItem:SetPosition(Vector(amountX, y, 0))
        line.amountShadow:SetPosition(Vector(amountX + shadow, y + shadow, 0))
        line.reasonItem:SetPosition(Vector(reasonX, y, 0))
        line.reasonShadow:SetPosition(Vector(reasonX + shadow, y + shadow, 0))

        line.amountItem:SetColor(Color(amountColor.r, amountColor.g, amountColor.b, alpha))
        line.reasonItem:SetColor(Color(kReasonColor.r, kReasonColor.g, kReasonColor.b, alpha))
        line.amountShadow:SetColor(Color(kShadowColor.r, kShadowColor.g, kShadowColor.b, kShadowColor.a * alpha))
        line.reasonShadow:SetColor(Color(kShadowColor.r, kShadowColor.g, kShadowColor.b, kShadowColor.a * alpha))

    end

end
