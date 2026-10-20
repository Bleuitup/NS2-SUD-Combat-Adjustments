-- XP gains from the server, shown by GUISCAXpMessages.lua in this piece. Dropped when the script
-- isn't running (ready room, spectating).
local function OnSCAXpGain(message)
    if SCA_XpMessagesGUI then
        SCA_XpMessagesGUI:AddGain(message)
    end
end
Client.HookNetworkMessage("SCAXpGain", OnSCAXpGain)
