local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")

function OnUIUpdate(tick, frame)
	RoguePowerBars:OnUIUpdate(tick, frame);
end

function BarsAreLocked()
	local arelocked = RoguePowerBars.db.profile.settings.Locked;
	return arelocked;
end

function RPB_OnMouseDown(frame, arg1, arg2, arg3)
	if arg1 == "LeftButton" and not BarsAreLocked() then
		frame:StartMoving();
	end
end

function RPB_OnMouseUp(frame, arg1)
	if arg1 == "LeftButton" then
		frame:StopMovingOrSizing();
		RoguePowerBars:OnBarsetMove(frame);
	end
end
