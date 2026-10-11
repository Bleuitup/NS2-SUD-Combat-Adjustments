-- Setup Filehooks based on the folder structure inside the FileHooks folder
-- Warning: Paths are case sensitive at Linux
--
-- The path under Halt/Post/Pre/Replace must mirror the hooked file's real path below lua/:
--   SCA/<piece>/Post/Balance.lua                 hooks lua/Balance.lua
--   SCA/<piece>/Post/Weapons/Marine/Shotgun.lua  hooks lua/Weapons/Marine/Shotgun.lua
--   SCA/<piece>/Post/Combat/Globals.lua          hooks lua/Combat/Globals.lua (Combat's own file)
--
-- Combat loads its own files (lua/Combat/...) after all of vanilla, so a value Combat sets there
-- has to be hooked on the Combat file. A post hook on the vanilla file runs too early and gets
-- overwritten.
--
-- Piece names end up inside a Lua pattern, so keep them to letters, digits and spaces.
local function SetupFilehookFolder(folderPath, modPath, hookType)
	local files = {}
	local path = string.format("%s*.lua", folderPath)
	Shared.GetMatchingFileNames(path, true, files)

	--Log("Loading %s Filehooks: %s", hookType, files)

	for i = 1, #files do
		local filePath = files[i]
		local vanillaFilePath = string.gsub(filePath, modPath, "")
		ModLoader.SetupFileHook(vanillaFilePath, filePath, hookType)
	end

end

local function SetupFilehookFolders(modPath)
	if Server then
		Server.AddRestrictedFileHashes(modPath .. "/*")
	end
	local folders = { "Halt", "Post", "Pre", "Replace" }
	for i = 1, #folders do
		local hookType = folders[i]
		local modPath = string.format("%s/%s/", modPath, hookType)
		local folderPath = string.format("lua/%s", modPath)
		SetupFilehookFolder(folderPath, modPath, string.lower(hookType))
	end
end

-- Remove a line to switch that piece off. "Weapon Tree" and the server side of "Hive Traits"
-- need "Upgrade Rules".
local pieces = {

"Advanced Swipe",
"Alien Abilities",
"Aura",
"Focus",
"Hitpoints",
"Hive Traits",
"Kill XP",
"Onos Charge",
"Resupply",
"Spawn Protection",
"Stomp",
"Tier Scaling",
"Upgrade Rules",
"Weapon Tree",
"Weapons",
"Welding XP",
"Xenocide"
}

for i = 1, #pieces do

	local fix = pieces[i]
	local hookedFolder = string.format("SCA/%s", fix)
	SetupFilehookFolders(hookedFolder)

end

print("loaded SCA")
