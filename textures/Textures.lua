local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

----------------------------------------------------------------------
-- Import custom textures into SharedMedia
local TEXTURES = {
    BANTO      = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureBanto.tga",
    LITESTEP   = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureLiteStep.tga",
    OTRAVI     = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureCanvas.tga",
    SMOOTH     = "Interface\\AddOns\\RoguePowerBars\\textures\\BarTextureSmooth.tga"
}

function RoguePowerBars:ImportCustomTextures()
	SharedMedia:Register("statusbar", "BantoBar", TEXTURES.BANTO);
	SharedMedia:Register("statusbar", "LiteStep", TEXTURES.LITESTEP);
	SharedMedia:Register("statusbar", "Otravi", TEXTURES.OTRAVI);
	SharedMedia:Register("statusbar", "Smooth", TEXTURES.SMOOTH);
end