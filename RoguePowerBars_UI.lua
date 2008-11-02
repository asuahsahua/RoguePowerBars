
local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")

function OnUIUpdate(tick, frame)
	RoguePowerBars:OnUIUpdate(tick, frame);
end

function BarsAreLocked()
	local arelocked = RoguePowerBars.db.profile.settings.Locked;
	return arelocked;
end