-- All code originally property of  Fredrik Normen - 2006-12-27 (Mangrol/Alliance on Mazrigos).
-- Modified by Anthony Marion on 10-20-2008 (Domia/Horde on Maiev).

CLOCK_UPDATE_RATE = 0.02;
TIME_CONSTANT = 60;

_timeSinceLastUpdate = 0;
_timeCounter = 0;
_lastUpdate = 0;
_needsBuffUpdate = false;

ROGUEPOWERBAR_INITIALIZED = false;

_numBuffButtons = 0;
_numBuffsShown = 0;

DEBUG_updates = 0;
DEBUG_sincelastupdate = 0;


function RoguePowerBar_OnEvent(event)
	RoguePowerBar_EventHandler[event](arg1, arg2, arg3, arg4, arg5);

end


function RoguePowerBar_OnLoad()

	_lastUpdate = GetTime();
	
	self_frame = RoguePowerBar;

	--self_frame:RegisterEvent("PLAYER_AURAS_CHANGED");
	self_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	self_frame:RegisterEvent("UNIT_AURA");
	self_frame:RegisterEvent("PLAYER_TARGET_CHANGED");

	SlashCmdList["ROGUEPOWERBAR"] = function(msg)
		RoguePowerBar_SlashCommandHandler(msg);
	end

end

function RoguePowerBar_OnUnitAura(unit)
	if unit == "player" then
		RoguePowerBar_OnAuraChanged();
	elseif unit == "target" then
		RoguePowerBar_OnAuraChanged();
	end
end

function RoguePowerBar_OnPlayerTargetChanged()
	RoguePowerBar_OnAuraChanged();
	-- should really clear out the buff list first.
end

function RoguePowerBar_OnPlayerEnteringWorld()

	--UpdateBuffs();
	UpadateRoguePowerBars(_needsBuffUpdate);

end


function RoguePowerBar_OnUpdate(tick)
	if not ROGUEPOWERBAR_INITIALIZED then
		return;
	end
	local timeNow = GetTime();
	if( (timeNow - _lastUpdate) > CLOCK_UPDATE_RATE ) or _needsBuffUpdate then
		UpadateRoguePowerBars(_needsBuffUpdate);
		_needsBuffUpdate = false;
		_lastUpdate = timeNow;
	end
	

end


function RoguePowerBar_OnAuraChanged()
	_needsBuffUpdate = true;
	
	local timeNow = GetTime();
	
	if ( (timeNow - _lastUpdate) > CLOCK_UPDATE_RATE ) then
		RoguePowerBar_OnUpdate(0);
	end

end


function RoguePowerBar_OnChatMsgSpellPeriodicSelfBuffs(arg1)

	if not ROGUEPOWERBAR_INITIALIZED then
		return;
	end

end


function RoguePowerBar_OnChatMsgSpellSelfDamage(arg1)

	if not ROGUEPOWERBAR_INITIALIZED then
		return;
	end

end


function RoguePowerBar_OnChatMsgSpellAuraGoneSelf(arg1)

	if not ROGUEPOWERBAR_INITIALIZED then
		return;
	end

end


local function BuffsSort_ByMinTimeLeft(a, b)

	if a.TimeLeft < b.TimeLeft then
		return true;
	end

	if a.TimeLeft > b.TimeLeft then
		return false;
	end
	
	return a.Name < b.Name;
	
end


local function BuffsSort_ByMaxTimeLeft(a, b)

	if a.TimeLeft > b.TimeLeft then
		return true;
	end

	if a.TimeLeft < b.TimeLeft then
		return false;
	end
	
	return a.Name < b.Name;
	
end


local function BuffsSort_ByMaxTime(a, b)

	if a.MaxTime > b.MaxTime then
		return true;
	end

	if a.MaxTime < b.MaxTime then
		return false;
	end

	return a.Name < b.Name;

end


local function BuffsSort_ByOwnOrder(a, b)

	if a.OwnOrder < b.OwnOrder then
		return true;
	end

	if a.OwnOrder > b.OwnOrder then
		return false;
	end

	return a.Name < b.Name;

end


local function BuffsSort_ByName(a, b)

	if a.Name < b.Name then
		return true;
	end

	if a.Name > b.Name then
		return false;
	end

	return a.Name < b.Name;

end


function GetBuffInSettings(name)

	for i = 1, getn(RoguePowerBar_Bars) do
	
		if strupper(RoguePowerBar_Bars[i].BasedOnAuraName) == strupper(name) and RoguePowerBar_Bars[i].Enabled then
		   return RoguePowerBar_Bars[i];
		end
	
	end

	return nil;

end


function UpdateBuffs()
	local maxtimes = {};
	local buffs = {};
	local debuffs = {};

	for i = 1, _numBuffsShown do
		local bar = getglobal(ROGUEPOWERBAR_NAME..i)
		if not maxtimes[bar.name] or maxtimes[bar.name] < bar.maxtime then
			maxtimes[bar.name] = bar.maxtime;
		end
	end

	local numBuffs = 0;
	local buffIndex = 1;
	local untilCancelled, stacks, name, rank, texture, buffSettings, expirationTime;

	local buffIndex = 1;

	while buffIndex ~= 0 do
		--- local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura("player", id, "HELPFUL");
		
		local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura("player", buffIndex, "HELPFUL");
		-- buffIndex, untilCancelled, stacks = GetPlayerBuffImp(i);

		if name == nil then break end;
		
		if name then
		
			local buffSettings = GetBuffInSettings(name);
			
			if buffSettings ~= nil then
			
				local timeLeft = expirationTime - GetTime();
				local maxtime = timeLeft;

				if count == 0 and maxtimes[name] and maxtime < maxtimes[name] then
					maxtime = maxtimes[name];
				elseif count > 0 then
					local tempname = name .. " (" .. count .. ")";
					if maxtimes[tempname] and maxtime < maxtimes[tempname] then
						maxtime = maxtimes[tempname];
					end
				end

				table.insert(buffs, 
					{ 
						BuffIndex = buffIndex, 
						Name = name, 
						TimeLeft = timeLeft, 
						MaxTime = maxtime, 
						OwnOrder = buffSettings.DisplayOrder, 
						Settings = buffSettings,
						Texture = texture,
						Type = TYPE_BUFF,
						Stacks = count
					});

			end

		end

		buffIndex = buffIndex + 1;
		
	end
	
	buffIndex = 1;
	i = 1;
	local buffCount = #buffs;
	while buffIndex ~= 0 do
		--buffIndex, untilCancelled, stacks = GetTargetDebuffImp(i);
		
		local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura("target", buffIndex, "HARMFUL|PLAYER");
		if name == nil then break end;

		if name then
			local buffSettings = GetBuffInSettings(name);
			
			if buffSettings ~= nil then
			
				local timeLeft = expirationTime - GetTime();
				local maxtime = timeLeft;
				
				if count == 0 and maxtimes[name] and maxtime < maxtimes[name] then
					maxtime = maxtimes[name];
				elseif count > 0 then
					local tempname = name .. " (" .. count .. ")";
					if maxtimes[tempname] and maxtime < maxtimes[tempname] then
						maxtime = maxtimes[tempname];
					end
				end

				table.insert(debuffs, 
					{ 
						BuffIndex = buffIndex, 
						Name = name, 
						TimeLeft = timeLeft, 
						MaxTime = maxtime, 
						OwnOrder = buffSettings.DisplayOrder, 
						Settings = buffSettings,
						Texture = texture,
						Type = TYPE_DEBUFF,
						Stacks = count
					});

			end

		end

		buffIndex = buffIndex + 1;
		
	end	
		
	if RoguePowerBarsOptions.sort == MAXTIME then
		table.sort(buffs, BuffsSort_ByMaxTime);
	elseif RoguePowerBarsOptions.sort == MIN_TIMELEFT then
		table.sort(buffs, BuffsSort_ByMinTimeLeft);
	elseif RoguePowerBarsOptions.sort == MAX_TIMELEFT then
		table.sort(buffs, BuffsSort_ByMaxTimeLeft);
	elseif RoguePowerBarsOptions.sort == OWNORDER then
		table.sort(buffs, BuffsSort_ByOwnOrder);
	elseif RoguePowerBarsOptions.sort == NAME then
		table.sort(buffs, BuffsSort_ByName);
	end

	for x = 1, #buffs do
		numBuffs = numBuffs + 1
		SetStatusBarBuff(numBuffs, buffs[x]);
	end
	
	local numDebuffs = 0;
	for x = 1, #debuffs do
		numDebuffs = numDebuffs + 1;
		SetStatusBarBuff(numBuffs+numDebuffs, debuffs[x]);
	end

	CleanUp(numBuffs+numDebuffs);
	_numBuffsShown = numBuffs+numDebuffs;
	UpdateRoguePowerBarPositions();

end


function CreateStatusBar(numButtons)

	if numButtons > _numBuffButtons then

		for i = _numBuffButtons + 1, numButtons do

			local f = CreateFrame("Frame", ROGUEPOWERBAR_NAME..i, self_frame, "RoguePowerBarTemplate");

			UpdateRoguePowerBarPosition(i);

			getglobal(ROGUEPOWERBAR_NAME..i.."_DescribeText"):SetTextColor(1, 1, 1);
			getglobal(ROGUEPOWERBAR_NAME..i.."_DurationText"):SetTextColor(1, 1, 1);

		end

		_numBuffButtons = numButtons;

	end

end


function UpdateRoguePowerBarPosition(barId)

	local roguePowerBarFrame = getglobal(ROGUEPOWERBAR_NAME..barId);

	if barId > 1 then
		roguePowerBarFrame:SetPoint("TOP", getglobal(ROGUEPOWERBAR_NAME..(barId-1)), "BOTTOM", 0, -STATUSBAR_SPACE);
	else
		roguePowerBarFrame:SetPoint("TOP", self_frame, "TOP");
	end

end


function UpdateRoguePowerBarPositions()
	
	if _numBuffsShown > 0 then
	
		for i = 1, _numBuffsShown do

			local roguePowerBar = getglobal("RoguePowerBar"..i);
			UpdateRoguePowerBarPosition(i);

		end

		self_frame:SetHeight(_numBuffsShown * STATUSBAR_HEIGHT + (_numBuffsShown - 1) * STATUSBAR_SPACE);
		self_frame:Show();

	else
		
		self_frame:SetHeight(0);
		self_frame:Hide();

	end

end


function SetStatusBarBuff(buffId, buff)

	CreateStatusBar(buffId);
	
	local rogePowerBarFrame = getglobal(ROGUEPOWERBAR_NAME..buffId);
	local bar = getglobal(ROGUEPOWERBAR_NAME..buffId.."_StatusBar");
	local icon = getglobal(ROGUEPOWERBAR_NAME..buffId.."_Icon");
	local name = getglobal(ROGUEPOWERBAR_NAME..buffId.."_DescribeText");
	local duration = getglobal(ROGUEPOWERBAR_NAME..buffId.."_DurationText");

	rogePowerBarFrame.id = buff.BuffIndex;
	rogePowerBarFrame.timeleft = buff.TimeLeft;
	rogePowerBarFrame.maxtime = buff.MaxTime;
	if buff.Stacks ~= 0 then
		rogePowerBarFrame.name = buff.Name.." ("..buff.Stacks..")";
	else
		rogePowerBarFrame.name = buff.Name or "Uknown "..buff.BuffIndex;
	end
	rogePowerBarFrame.type = buff.Type;

	local backDropColor = buff.Settings.BackDropColor;
	local statusBarColor = buff.Settings.StatusBarColor;

	local backGround = getglobal(ROGUEPOWERBAR_NAME..buffId.."_BarBackGround");

	bar:SetStatusBarTexture(RoguePowerBarsOptions.barTexture);

	local backDropTable = backGround:GetBackdrop();
	backDropTable.bgFile = RoguePowerBarsOptions.barTexture;
	
	backGround:SetBackdrop(backDropTable);
	backGround:SetBackdropColor(backDropColor.r, backDropColor.g, backDropColor.b, backDropColor.a);

	bar:SetStatusBarColor(statusBarColor.r, statusBarColor.g, statusBarColor.b, statusBarColor.a);
	bar:SetMinMaxValues(0, rogePowerBarFrame.maxtime);

	icon:SetTexture(buff.Texture);
	
	if RoguePowerBarsOptions.showtext then
		name:SetText(rogePowerBarFrame.name);
	end
	
	rogePowerBarFrame:SetAlpha(RoguePowerBarsOptions.alpha);
	rogePowerBarFrame:Show();
	
	if RoguePowerBarsOptions.fade and rogePowerBarFrame.timeleft >= rogePowerBarFrame.maxtime then
		UIFrameFadeOut(rogePowerBarFrame, 0.5, 0, RoguePowerBarsOptions.alpha);
	end

end


function CleanUp(numBuffs)
	
	if numBuffs < _numBuffButtons then
	
		for i = numBuffs + 1, _numBuffButtons do

			local bar = getglobal(ROGUEPOWERBAR_NAME..i);

			bar.id = nil;
			bar.alpha = RoguePowerBarsOptions.alpha;
			bar.InvertFade = false;
			bar.FadeCounter = 0
			bar:SetAlpha(RoguePowerBarsOptions.alpha);
			bar:Hide();
	
		end

	end

end


function UpadateRoguePowerBars(mustupdate)
	
	for i = 1, _numBuffsShown do

		local roguePowerBarFrame = getglobal(ROGUEPOWERBAR_NAME..i);
		local bar = getglobal(ROGUEPOWERBAR_NAME..i.."_StatusBar");
		local duration = getglobal(ROGUEPOWERBAR_NAME..i.."_DurationText");

		local timeleft = 0;
		if roguePowerBarFrame.type == TYPE_BUFF then
			timeleft = GetPlayerBuffTimeLeftImp(roguePowerBarFrame.id);
		else
			timeleft = GetTargetDebuffTimeLeftImp(roguePowerBarFrame.id);
		end
		--timeleft = GetPlayerBuffTimeLeftImp(roguePowerBarFrame.id);

		if RoguePowerBarsOptions.durationText then
			duration:SetText(string.format("%.1f", timeleft));
			duration:Show();
		else
			duration:Hide();
		end

		if RoguePowerBarsOptions.invert then
			bar:SetValue(roguePowerBarFrame.maxtime-timeleft);
		else
			bar:SetValue(timeleft);
		end

		if roguePowerBarFrame.timeleft < timeleft then
			mustupdate = true;
			roguePowerBarFrame.maxtime = timeleft;
		end

		roguePowerBarFrame.timeleft = timeleft;
		
		if (timeleft < 10) and RoguePowerBarsOptions.fade then
			FlashBar(roguePowerBarFrame);
		end

	end

	if mustupdate then
		UpdateBuffs();
	end

end


function InitializeBars()

	for i = 1, getn(RoguePowerBar_Bars) do
		if RoguePowerBar_Bars[i].IsInTalentTree then
			local find, learned = CheckIfTalentAndIsLearned(RoguePowerBar_Bars[i].TalentTreeName);
			
			if find and not learned then
				RoguePowerBar_Bars[i].HideFromConfig = true;
				RoguePowerBar_Bars[i].Enabled = false;
			end	
			
		end
				
	end

	if not RoguePowerBarsOptions.locked then
		RoguePowerBar:EnableMouse(1);
	else
		RoguePowerBar:EnableMouse(0);
	end

	ROGUEPOWERBAR_INITIALIZED = true;

end


function RoguePowerBar_SlashCommandHandler(msg)

	if( msg ) then

		local command = string.lower(msg);

		if( command == "unlock" ) then

			Config_UnlockConfigOption();

		elseif( command == "lock" ) then

			Config_LockConfigOption();

		elseif( command == "reset" ) then

			RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE] = nil;
			ROGUEPOWERBAR_VARIABLES_LOADED = false;
			RoguePowerBar_LoadVariables(2);

		elseif( command == "config" ) then

			RoguePowerBarConfigFrame:Show();

		elseif( command == "invert" ) then

			Config_SetInvert();

		elseif( string.sub(command, 1, 5) == "scale" ) then

			local scale = tonumber(string.sub(command, 7))

			if( scale >= 0.25 and scale <= 3.0 ) then

				Config_SetScaleValue(scale);
			
				DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." scale set to "..scale);

			else

				RoguePowerBar_Help()

			end

		elseif( string.sub(command, 1, 5) == "alpha" ) then

			local alpha = tonumber(string.sub(command, 7))

			if( scale >= 0.0 and scale <= 1.0 ) then

				Config_SetAlpha(alpha);
			
				DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME.." transparent/alpha set to "..alpha);

			else

				RoguePowerBar_Help()

			end

		elseif( string.sub(command, 1, 4) == "text" ) then

			local text = string.sub(command, 6);

			if text == "on" then
				Config_SetTextOnBars(true);
			elseif text == "off" then
				Config_SetTextOnBars(false);
			else
				RoguePowerBar_Help();
			end
				
		elseif( string.sub(command, 1, 5) == "flash" ) then

			local text = string.sub(command, 7);

			if text == "on" then
				Config_SetFlashOnBars(true);
			elseif text == "off" then
				Config_SetFlashOnBars(false);
			else
				RoguePowerBar_Help();
			end

		elseif( string.sub(command, 1, 8) == "duration" ) then

			local text = string.sub(command, 10);

			if text == "on" then
				Config_SetDurationOnBars(true);
			elseif text == "off" then
				Config_SetDurationOnBars(false);
			else
				RoguePowerBar_Help();
			end
		else
			RoguePowerBar_Help();
		end
	end

end


function FlashBar(statusBar)

	if statusBar.FadeCounter == nil then
		statusBar.FadeCounter = 0;
	end
	
	if statusBar.InvertFade == nil then
		statusBar.InvertFade = false;
	end

	if statusBar.alpha == nil then
		statusBar.alpha = 1;
	end

	statusBar.FadeCounter = statusBar.FadeCounter + 1;

	if (statusBar.FadeCounter <= 60) then

		if not statusBar.InvertFade then
			statusBar.alpha = statusBar.alpha - ((RoguePowerBarsOptions.alpha*0.66)/60);
		else
			statusBar.alpha = statusBar.alpha + ((RoguePowerBarsOptions.alpha*0.66)/60);
		end
		
		statusBar:SetAlpha(statusBar.alpha);
		
	else
		statusBar.FadeCounter = 0;
		statusBar.InvertFade = not statusBar.InvertFade;
	end

end


function CheckIfTalentAndIsLearned(name)

	local numTabs = GetNumTalentTabs();

	for t=1, numTabs do
		
		local numTalents = GetNumTalents(t);
    
		for i=1, numTalents do
			
			nameTalent, icon, tier, column, currRank, maxRank= GetTalentInfo(t,i);
			
			if strupper(nameTalent) == strupper(name) then
				return true, (currRank > 0);
			end
		
		end
		
	end
	
	return false, false;
	
end


function RoguePowerBar_LoadVariables(arg1)

	if ROGUEPOWERBAR_VARIABLES_LOADED then
		return;
	end

	local playerName=UnitName("player")

	if playerName==nil or playerName==UNKNOWNBEING or playerName==UKNOWNBEING or playerName==UNKNOWNOBJECT then
		return
	end

	ROGUEPOWERBAR_PROFILE = playerName.." of "..GetCVar("RealmName");

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE] == nil then

		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE] = { };
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked = nil;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].text = true;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].scale = nil;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].invert = false;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].fade = true;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].enableDuration = true;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode = nil;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].alpha = 1;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].sort = MIN_TIMELEFT;
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].point = "CENTER";
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].x = "0";
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].y = "80";
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].barTexture = nil;

	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode == nil then

		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode = {};

		for i=1, getn(RoguePowerBar_Bars) do
			RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode[i] = true;
		end

	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked = false;
	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].scale == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].scale = 1;
	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].alpha == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].alpha = 1;
	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].point == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].point = "CENTER";
	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].x == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].x = 0;
	end

	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].y == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].y = 80;
	end
	
	if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].barTexture == nil then
		RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].barTexture = "Interface\AddOns\RoguePowerBars\BatTextureSmooth.tga";
	end

	RoguePowerBarsOptions.locked = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].locked;
	RoguePowerBarsOptions.invert = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].invert;
	RoguePowerBarsOptions.scale = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].scale;
	RoguePowerBarsOptions.showtext = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].text;
	RoguePowerBarsOptions.fade = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].fade;
	RoguePowerBarsOptions.durationText = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].enableDuration;
	RoguePowerBarsOptions.alpha = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].alpha;
	RoguePowerBarsOptions.sort = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].sort;
	RoguePowerBarsOptions.point = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].point;
	RoguePowerBarsOptions.x = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].x;
	RoguePowerBarsOptions.y = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].y;
	RoguePowerBarsOptions.barTexture = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].barTexture
	
	for i=1, getn(RoguePowerBar_Bars) do

		if RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode[i] ~= nil then
			RoguePowerBar_Bars[i].Enabled = RoguePowerBar_Save[ROGUEPOWERBAR_PROFILE].statusBarsMode[i];
		else
			RoguePowerBar_Bars[i].Enabled = false;
		end

	end

	RoguePowerBar:SetScale(RoguePowerBarsOptions.scale * UIParent:GetScale());
	RoguePowerBar:ClearAllPoints();
	RoguePowerBar:SetPoint(RoguePowerBarsOptions.point, "UIParent", RoguePowerBarsOptions.point, RoguePowerBarsOptions.x, RoguePowerBarsOptions.y);
	
	ROGUEPOWERBAR_VARIABLES_LOADED = true;

	RoguePowerBar_Variable_Frame:Hide();
	
	InitializeBars();

	ROGUEPOWERBAR_INITIALIZED = true;

	--DisplayAddonInfo();

end


function DisplayAddonInfo()

	DEFAULT_CHAT_FRAME:AddMessage(" ");
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00"..ADDON_NAME.." V "..ADDON_VERSION.."|r - Loaded - /rpb or /roguepowerbar for options...");

	DEFAULT_CHAT_FRAME:AddMessage("|cff3399ffStatus Bars activated:|r");

	for i = 1, getn(RoguePowerBar_Bars) do

		if RoguePowerBar_Bars[i].Enabled then
			DEFAULT_CHAT_FRAME:AddMessage("     |cffffff00"..RoguePowerBar_Bars[i].BasedOnAuraName.."|r");
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage(" ");

end


function RoguePowerBar_Help()

	DEFAULT_CHAT_FRAME:AddMessage(" ");
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00"..ADDON_NAME.." V "..ADDON_VERSION.."|r : Usage - /rpb or /roguepowerbar for options");
	DEFAULT_CHAT_FRAME:AddMessage(" Options:");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  on|r         : Enable");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  off|r         : Disable");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  unlock|r   : Allows you to move the bars");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  lock|r       : Hide bars when inactive");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  invert|r    : Invert progress bar direction");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  scale _|r  : Scales the bars (0.25 - 3.0)");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  text _|r    : Enbale text on the bar (on,off)");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  flash _|r  : Enbale flashfade on the bars (on,off)");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  duration _|r : Enbale duration text on the bars (on,off)");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  config|r  : Open the Configuration window");
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00  alpha _|r   : Set the transparent level on the bars (0.0 - 1.0");
	DEFAULT_CHAT_FRAME:AddMessage(" ");

end


function GetPlayerBuffTimeLeftImp(id)
		local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura("player", id, "HELPFUL");
		if expirationTime then
			return expirationTime - GetTime();
		else
			return 0;
		end

end

function GetTargetDebuffTimeLeftImp(id)
		local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura("target", id, "HARMFUL");
		if expirationTime then
			return expirationTime - GetTime();
		else
			return 0;
		end
end


function GetPlayerBuffImp(index)
	
		local name, rank, texture, count, debuffType, duration, expiryTime, isMine = UnitAura("player", index, "HELPFUL");
		local buffIndex = index;
		local untilCancelled = 0;
		
		if name == nil then
			buffIndex = 0;
		end
		
		if duration == 0 then
			untilCancelled = 1;
		end

		return buffIndex, untilCancelled, count;
end


function GetTargetDebuffImp(buffIndex)
		local name, rank, texture, count, debuffType, duration, expiryTime, isMine = UnitAura("target", buffIndex, "HARMFUL");
		local buffIndex = buffIndex;
		local untilCancelled = 0;
		if name == nil then
			buffIndex = 0;
		end
		
		if duration == 0 then
			untilCancelled = 1;
		end
		
		return buffIndex, untilCancelled, count;
end

function GetPlayerBuffNameImp(buffIndex)		
		local name, rank = UnitAura("player", buffIndex, buffType);

		return name, rank;
end

function GetTargetDebuffNameImp(buffIndex)
		local name, rank, texture, count, debuffType, duration, expiryTime, isMine = UnitAura("target", buffIndex, "HARMFUL");
		if isMine ~= 1 then
			name = name.."NotMine";
		end
		return name, rank;
end

function GetPlayerBuffTextureImp(buffIndex)
	local name, rank, texture = UnitAura("player", buffIndex, "HELPFUL");
	return texture;

end 

function GetTargetDebuffTextureImp(buffIndex)

	local name, rank, texture = UnitAura("target", buffIndex, "HARMFUL");
	return texture;

end 