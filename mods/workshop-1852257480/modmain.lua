_G = GLOBAL
require = _G.require
tonumber = _G.tonumber
ACTIONS = _G.ACTIONS
TUNING = _G.TUNING
STRINGS = _G.STRINGS
ismastersim = _G.TheNet:GetIsServer()

Assets =
{
	Asset("ANIM", "anim/domesticationbeefalowidget.zip"),
	Asset("ANIM", "anim/obediencebeefalowidget.zip")
}

TUNING.BEEFALOWIDGETHOR = GetModConfigData("horizontal") or 0
TUNING.BEEFALOWIDGETVER = GetModConfigData("vertical") or -30
modimport("scripts/patches/beefalodomestication.lua")

if GetModConfigData("info") then
	local conflict_mods = "disabled"
	for k, v in ipairs(_G.ModManager.enabledmods) do
		if v == "workshop-666155465" then
			conflict_mods = "enabled"
			break
		end	
	end
	if conflict_mods == "disabled" then
		modimport("scripts/patches/beefaloinformation.lua")
	end
end