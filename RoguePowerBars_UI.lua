local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")

function RPB_OnUIUpdate(frame, tick, ...)
	RoguePowerBars:OnUIUpdate(frame, tick) -- self,elapsed
end

function RPB_BarsAreLocked()
	local arelocked = RoguePowerBars.db.profile.settings.Locked
	return arelocked
end

function RPB_OnBarsetMove(frame)
	RoguePowerBars:OnBarsetMove(frame)
end
