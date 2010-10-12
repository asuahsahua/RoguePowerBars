
local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")

function OnUIUpdate(frame,tick,...)
	RoguePowerBars:OnUIUpdate(frame,tick);-- self,elapsed
end

function BarsAreLocked()
	local arelocked = RoguePowerBars.db.profile.settings.Locked;
	return arelocked;
end

function OnBarsetMove(frame)
	RoguePowerBars:OnBarsetMove(frame);
end