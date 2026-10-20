-- One XP gain and where it came from, sent from the server to the player who got it.
-- See Player_Server.lua in this piece for the sender and GUISCAXpMessages.lua for the display.

kSCAXpSource = enum({ "Other", "Kill", "Assist", "Nearby", "DiedNearby", "Damage", "Weld", "Heal", "CatchUp" })

local kSCAXpGainMessage =
{
    amount = "float",
    bonus = "float",           -- the part of amount that is Combat's higher-level bonus
    source = "enum kSCAXpSource",
    target = "string (32)",    -- class name of what was killed, damaged or welded
    targetIsPlayer = "boolean",
}

Shared.RegisterNetworkMessage("SCAXpGain", kSCAXpGainMessage)
