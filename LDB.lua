local self = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("RoguePowerBars", {
	type = "launcher",
	icon = "Interface\\Icons\\INV_ThrowingKnife_04",
	label= "RoguePowerBars",
	OnClick = function(clickedframe, button)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars);
	end,
	OnTooltipShow = function(tooltip)
			tooltip:AddLine("RoguePowerBars")
			tooltip:AddLine(L["Click to open options."])
	end,
})

