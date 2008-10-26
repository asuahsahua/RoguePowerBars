
local buffpanel = nil;
local debuffpanel = nil;

function RoguePowerBar_GUIFrame_OnLoad(panel)
	panel.name = "RoguePowerBars";
	panel.okay = function (self) RoguePowerBar_GUIFrame_Close(); end;
	panel.cancel = function (self) RoguePowerBar_GUIFrame_CancelOrLoad(); end;
	
	buffpanel = CreateFrame("ScrollFrame", "BuffPanel");
	buffpanel.name = "Buffs";
	buffpanel.parent = "RoguePowerBars";
	buffpanel:SetScript("OnShow", InitializeBuffCheckboxes);
	
	debuffpanel = CreateFrame("FRAME", "DebuffPanel");
	debuffpanel.name = "Debuffs";
	debuffpanel.parent = "RoguePowerBars";
	
	InterfaceOptions_AddCategory(panel);
	InterfaceOptions_AddCategory(buffpanel);
	InterfaceOptions_AddCategory(debuffpanel);
	
end

function RoguePowerBar_GUIFrame_Close()

end

function RoguePowerBar_GUIFrame_CancelOrLoad()

end

function InitializeBuffCheckboxes()

	local posX = 20;
	local posY = 0;
	local numberOfEachRow = 1;
	local rowPosition = 1;
	local column = 0;

	for i=1, getn(RoguePowerBar_Bars) do

		if not RoguePowerBar_Bars[i].HideFromConfig then

			local statusBar = RoguePowerBar_Bars[i];

			local name = ROGUEPOWERBAR_NAME..i.."_Option";

			local f = CreateFrame("Frame", name, buffpanel, "NormalCheckBoxTemplate")
	
			local text = getglobal(name.."_DescribeText");
			local chkBox = getglobal(name.."_CheckBox");

			text:SetText(statusBar.BasedOnAuraName);

			chkBox:SetChecked(statusBar.Enabled);

			chkBox:SetScript("OnClick", function() OptionsCheckButtonOnClick(statusBar, i) end);

			posY = -(rowPosition*19+50);

			f:SetPoint("TOPLEFT", posX, posY);

--			if numberOfEachRow == 14 then
--				rowPosition = 0;
--				numberOfEachRow = 0;
--				column = column + 1;
--			end
			

			posX = 20 + (180*column);

			f:Show();

			numberOfEachRow = numberOfEachRow + 1;
			rowPosition = rowPosition + 1;
			
		end

	end

end

function OptionsCheckButtonOnClick(statusBar, i)

	if not ROGUEPOWERBAR_VARIABLES_LOADED then
		RoguePowerBar_LoadVariables(2);
	end

	statusBar.Enabled = not	statusBar.Enabled;

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode = {};
	end

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode[i] = statusBar.Enabled;

	if statusBar.Enabled then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<"..statusBar.BasedOnAuraName.." is now enabled>|r");
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<"..statusBar.BasedOnAuraName.." is now disabled>|r");
	end

end