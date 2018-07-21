local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

----------------------------------------------------------------------
-- Imports custom textures into SharedMedia
local BANTO_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureBanto.tga"
local LITESTEP_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureLiteStep.tga"
local OTRAVI_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureCanvas.tga"
local SMOOTH_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureSmooth.tga"

function RoguePowerBars:ImportCustomTextures()
	SharedMedia:Register("statusbar", "BantoBar", BANTO_TEXTURE)
	SharedMedia:Register("statusbar", "LiteStep", LITESTEP_TEXTURE)
	SharedMedia:Register("statusbar", "Otravi", OTRAVI_TEXTURE)
	SharedMedia:Register("statusbar", "Smooth", SMOOTH_TEXTURE)
end