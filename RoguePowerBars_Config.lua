

function RoguePowerBarConfigFrame_OnLoad()

	RoguePowerBarConfigFrame_Title:SetText(ADDON_NAME.." V "..ADDON_VERSION);

	RoguePowerBarConfigFrame_OptionHeader:SetTextColor(1,1,1);
	RoguePowerBarConfigFrame_SettingsHeader:SetTextColor(1,1,1);

	RoguePowerBarConfigFrame_LockOption_DescribeText:SetText("Lock bars");
	RoguePowerBarConfigFrame_LockOption_CheckBox:SetScript("onClick", function() Lock(RoguePowerBarConfigFrame_LockOption_CheckBox:GetChecked()) end);

	RoguePowerBarConfigFrame_InvertOption_DescribeText:SetText("Invert the status bars");
	RoguePowerBarConfigFrame_InvertOption_CheckBox:SetScript("onClick", function() Config_SetInvert() end);

	RoguePowerBarConfigFrame_TextOption_DescribeText:SetText("Enable text on status bars");
	RoguePowerBarConfigFrame_TextOption_CheckBox:SetScript("onClick", function() Config_SetTextOnBars(RoguePowerBarConfigFrame_TextOption_CheckBox:GetChecked()) end);

	RoguePowerBarConfigFrame_FlashOption_DescribeText:SetText("Flash when few seconds is left");
	RoguePowerBarConfigFrame_FlashOption_CheckBox:SetScript("onClick", function() Config_SetFlashOnBars(RoguePowerBarConfigFrame_FlashOption_CheckBox:GetChecked()) end);

	RoguePowerBarConfigFrame_DurationOption_DescribeText:SetText("Enable duration text");
	RoguePowerBarConfigFrame_DurationOption_CheckBox:SetScript("onClick", function() Config_SetDurationOnBars(RoguePowerBarConfigFrame_DurationOption_CheckBox:GetChecked()) end);

	RoguePowerBarConfigFrame_ScaleSlider_SliderText:SetText("Scale");
	RoguePowerBarConfigFrame_ScaleSlider_Slider:SetMinMaxValues(0.25, 3.0);
	RoguePowerBarConfigFrame_ScaleSlider_Slider:SetValueStep(0.05);
	RoguePowerBarConfigFrame_ScaleSlider_Slider:SetScript("OnValueChanged", function() Config_SetScaleValue(RoguePowerBarConfigFrame_ScaleSlider_Slider:GetValue()) end);

	RoguePowerBarConfigFrame_AlphaSlider_SliderText:SetText("Transparent/Alpha");
	RoguePowerBarConfigFrame_AlphaSlider_Slider:SetMinMaxValues(0.0, 1.0);
	RoguePowerBarConfigFrame_AlphaSlider_Slider:SetValueStep(0.05);
	RoguePowerBarConfigFrame_AlphaSlider_Slider:SetScript("OnValueChanged", function() Config_SetAlpha(RoguePowerBarConfigFrame_AlphaSlider_Slider:GetValue()) end);

	RoguePowerBarConfigFrame_SortOrder_DropDownLabel:SetText("Sort order");
	RoguePowerBarConfigFrame_BarTexture_DropDownLabel:SetText("Bar style");

end


function RoguePowerBarConfigFrame_OnShow()

	InitializeStausBarOption();

	RoguePowerBarConfigFrame_ScaleSlider_Slider:SetValue(RoguePowerBarsOptions.scale);
	RoguePowerBarConfigFrame_AlphaSlider_Slider:SetValue(RoguePowerBarsOptions.alpha);

	RoguePowerBarConfigFrame_InvertOption_CheckBox:SetChecked(RoguePowerBarsOptions.invert);
	RoguePowerBarConfigFrame_TextOption_CheckBox:SetChecked(RoguePowerBarsOptions.showtext);
	RoguePowerBarConfigFrame_FlashOption_CheckBox:SetChecked(RoguePowerBarsOptions.fade);
	RoguePowerBarConfigFrame_DurationOption_CheckBox:SetChecked(RoguePowerBarsOptions.durationText);
	RoguePowerBarConfigFrame_LockOption_CheckBox:SetChecked((RoguePowerBarsOptions.locked));

	SetDurationTextExample(RoguePowerBarsOptions.durationText);
	SetTextOnBarsExample(RoguePowerBarsOptions.showtext);
	
	RoguePowerBarExample_StatusBar:SetMinMaxValues(0, 10);
	RoguePowerBarExample_StatusBar:SetValue(7);
	RoguePowerBarExample:SetBackdropColor(0, 0, 0, 0.8);

	RoguePowerBarExample_StatusBar:SetStatusBarTexture(RoguePowerBarsOptions.barTexture);

	local backDropTable = RoguePowerBarExample_BarBackGround:GetBackdrop();
	backDropTable.bgFile = RoguePowerBarsOptions.barTexture;
	
	RoguePowerBarExample_BarBackGround:SetBackdrop(backDropTable);
	RoguePowerBarExample_BarBackGround:SetBackdropColor(0.3, 0.5, 1, 0.3);

end


function RoguePowerBarConfigFrameCloseButton_OnClick()

	RoguePowerBarConfigFrame:Hide();

end


function BarStyleDropDown_OnShow()

	if RoguePowerBarsOptions.barTexture == BANTO_TEXTURE then
		UIDropDownMenu_SetText("Banto");
	elseif RoguePowerBarsOptions.barTexture == BLIZZARD_TEXTURE then
		UIDropDownMenu_SetText("Blizzard");
	elseif RoguePowerBarsOptions.barTexture == LITESTEP_TEXTURE then
		UIDropDownMenu_SetText("LiteStep");
	elseif RoguePowerBarsOptions.barTexture == OTRAVI_TEXTURE then
		UIDropDownMenu_SetText("Otravi");
	elseif RoguePowerBarsOptions.barTexture == SMOOTH_TEXTURE then
		UIDropDownMenu_SetText("Smooth");
	end

end


function SortOrderDropDown_OnShow()

	if RoguePowerBarsOptions.sort == MIN_TIMELEFT then
		UIDropDownMenu_SetText("Min time left");
	elseif RoguePowerBarsOptions.sort == MAX_TIMELEFT then
		UIDropDownMenu_SetText("Max time left");
	elseif RoguePowerBarsOptions.sort == MAXTIME then
		UIDropDownMenu_SetText("Max time");
	elseif RoguePowerBarsOptions.sort == OWNORDER then
		UIDropDownMenu_SetText("Definied order");
	elseif RoguePowerBarsOptions.sort == NAME then
		UIDropDownMenu_SetText("Name");
	end

end


function SortOrderDropDown_Initialize()

	local info = UIDropDownMenu_CreateInfo();
	
	info.text = "Min time left";
	info.func = function(x) DropDown_OnClick(MIN_TIMELEFT) end;
	info.value = MIN_TIMELEFT;
	UIDropDownMenu_AddButton(info);

	info.text = "Max time left";
	info.func = function() DropDown_OnClick(MAX_TIMELEFT) end;
	info.value = MAX_TIMELEFT;
	UIDropDownMenu_AddButton(info);

	info.text = "Max time";
	info.func = function() DropDown_OnClick(MAXTIME) end;
	info.value = MAXTIME;
	UIDropDownMenu_AddButton(info);

	info.text = "Defined order";
	info.func = function() DropDown_OnClick(OWNORDER) end;
	info.value = OWNORDER;
	UIDropDownMenu_AddButton(info);

	info.text = "Name";
	info.func = function() DropDown_OnClick(NAME) end;
	info.value = NAME;
	UIDropDownMenu_AddButton(info);
	
	UIDropDownMenu_SetSelectedValue(RoguePowerBarConfigFrame_SortOrder, RoguePowerBarsOptions.sort);

end


function BarStyleDropDown_Initialize()

	local info = UIDropDownMenu_CreateInfo();

	info.text = "Banto";
	info.func = function() BarStyleDropDown_OnClick(BANTO_TEXTURE) end;
	info.value = BATNO_TEXTURE;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Blizzard";
	info.func = function() BarStyleDropDown_OnClick(BLIZZARD_TEXTURE) end;
	info.value = BLIZZARD_TEXTURE;
	UIDropDownMenu_AddButton(info);

	info.text = "LiteStep";
	info.func = function() BarStyleDropDown_OnClick(LITESTEP_TEXTURE) end;
	info.value = LITESTEP_TEXTURE;
	UIDropDownMenu_AddButton(info);


	info.text = "Otravi";
	info.func = function() BarStyleDropDown_OnClick(OTRAVI_TEXTURE) end;
	info.value = OTRAVI_TEXTURE;
	UIDropDownMenu_AddButton(info);

	info.text = "Smooth";
	info.func = function() BarStyleDropDown_OnClick(SMOOTH_TEXTURE) end;
	info.value = SMOOTH_TEXTURE;
	UIDropDownMenu_AddButton(info);

	UIDropDownMenu_SetSelectedValue(RoguePowerBarConfigFrame_BarTexture, RoguePowerBarsOptions.barTexture);

end



function InitializeStausBarOption()

	local posX = 20;
	local posY = 0;
	local numberOfEachRow = 1;
	local rowPosition = 1;
	local column = 0;

	for i=1, getn(RoguePowerBar_Bars) do

		if not RoguePowerBar_Bars[i].HideFromConfig then

			local statusBar = RoguePowerBar_Bars[i];

			local name = ROGUEPOWERBAR_NAME..i.."_Option";

			local f = CreateFrame("Frame", name, RoguePowerBarConfigFrame, "NormalCheckBoxTemplate")
	
			local text = getglobal(name.."_DescribeText");
			local chkBox = getglobal(name.."_CheckBox");

			text:SetText(statusBar.BasedOnAuraName);

			chkBox:SetChecked(statusBar.Enabled);

			chkBox:SetScript("OnClick", function() OptionsCheckButtonOnClick(statusBar, i) end);

			posY = -(rowPosition*19+50);

			f:SetPoint("TOPLEFT", posX, posY);

			if numberOfEachRow == 10 then
				rowPosition = 0;
				numberOfEachRow = 0;
				column = column + 1;
			end

			posX = 20 + (150*column);

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


function Config_UnlockConfigOption()

	if ROGUEPOWERBAR_INITIALIZED then

		RoguePowerBarsOptions.locked = false;

		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked = RoguePowerBarsOptions.locked;

		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." is unlocked");

		RoguePowerBar:EnableMouse(1);

	end

end


function Config_LockConfigOption()

	if ROGUEPOWERBAR_INITIALIZED then

		RoguePowerBarsOptions.locked = true;

		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked = RoguePowerBarsOptions.locked;

		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." is locked");

		RoguePowerBar:EnableMouse(0);

	end

end


function Config_SetScaleValue(scale)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].scale = scale;
	RoguePowerBarsOptions.scale = scale;
				
	RoguePowerBar:SetScale(RoguePowerBarsOptions.scale * UIParent:GetScale());

end


function Config_SetInvert()

	RoguePowerBarsOptions.invert = not RoguePowerBarsOptions.invert;

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].invert = RoguePowerBarsOptions.invert;

	if RoguePowerBarsOptions.invert then
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." inversion on");
	else
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." inversion off");
	end

	
	if RoguePowerBarsOptions.invert then
		RoguePowerBarExample_StatusBar:SetValue(3);
	else
		RoguePowerBarExample_StatusBar:SetValue(7);
	end

end


function Config_SetTextOnBars(value)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].text = value;
	RoguePowerBarsOptions.showtext = value;

	if value then
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." enable text on bars");
	else
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." disable text on bars");
	end
	
	SetTextOnBarsExample(RoguePowerBarsOptions.showtext);

end


function Config_SetFlashOnBars(value)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].fade = value;
	RoguePowerBarsOptions.fade = value;

	if value then
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." enable flash on bars");
	else
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." disable flash on bars");
	end

end


function Config_SetDurationOnBars(value)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].enableDuration = value;
	RoguePowerBarsOptions.durationText = value;

	if value then
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." enable duration text on bars");
	else
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." disable duration text on bars");
	end
	
	SetDurationTextExample(RoguePowerBarsOptions.durationText);
end


function Config_SetAlpha(alpha)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].alpha = alpha;
	RoguePowerBarsOptions.alpha = alpha;

	RoguePowerBar:SetAlpha(alpha);
	
	RoguePowerBarExample:SetAlpha(alpha);
	
end


function DropDown_OnClick(value)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].sort = value;
	RoguePowerBarsOptions.sort = value;

	UIDropDownMenu_SetSelectedValue(RoguePowerBarConfigFrame_SortOrder, value);

end


function BarStyleDropDown_OnClick(value)

	RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].barTexture = value;
	RoguePowerBarsOptions.barTexture = value;

	UIDropDownMenu_SetSelectedValue(RoguePowerBarConfigFrame_BarTexture, value);

	RoguePowerBarExample_StatusBar:SetStatusBarTexture(value);

	local backDropTable = RoguePowerBarExample_BarBackGround:GetBackdrop();
	backDropTable.bgFile = value;
	
	RoguePowerBarExample_BarBackGround:SetBackdrop(backDropTable);
	RoguePowerBarExample_BarBackGround:SetBackdropColor(0.3, 0.5, 1, 0.3);

end


function Lock(value)

	RoguePowerBarsOptions.locked = value;
	
	if value then
		Config_LockConfigOption();
	else
		Config_UnlockConfigOption();
	end
end


function SetDurationTextExample(value)

	if value then
		RoguePowerBarExample_DurationText:SetText("00:06");
		RoguePowerBarExample_DurationText:SetTextColor(1,1,1);
	else
		RoguePowerBarExample_DurationText:SetText("");
	end

end


function SetTextOnBarsExample(value)

	if value then
		RoguePowerBarExample_DescribeText:SetText("Text on Statusbar");
		RoguePowerBarExample_DescribeText:SetTextColor(1,1,1);
	else
		RoguePowerBarExample_DescribeText:SetText("");
	end

end