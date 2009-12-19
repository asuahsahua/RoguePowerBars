-- All new code by Anthony Marion on 10-20-2008 (Domia/Horde on Maiev).
-- On comes the massive Ace3 revamp. BLANK SLATE!

----------------------------------------------
-- Libraries
local RoguePowerBars = LibStub("AceAddon-3.0"):NewAddon("RoguePowerBars", "AceConsole-3.0", "AceEvent-3.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

---------------------------------------------
-- Defined constants
local UpdateRate = .01;
local version = "@project-version@";
local revision = "@project-revision@";

----------------------------------------------
-- Local variables
local db;
local BarSets = { } -- associative array
local BarsToRecycle = { } -- normal array
local BarCount = 0;
local TimeSinceLastUIUpdate = 0;
local inCombat=false; --FIXME tag

local debug=false;

----------------------------------------------
-- Defaults for options
local defaults = {
	profile = {
		version=0,
		buffs = { },
		debuffs = { },
		othersDebuffs = { },
		bars = { },
		barsets = { 
			"Buffs",
			"Debuffs",
		},
		barsetsettings = {
			Buffs = {
				IsEnabled = true,
				Width = 256,
				Scale = 1,
				Alpha = 1,
				GrowDirection = 3, -- 1 Up, 2 Down, 3 Center
				position = {
					x = 0.375,
					y = 0.280,
					relativeto = "CENTER",
				},
			},
			Debuffs = {
				IsEnabled = true,
				Width = 256,
				Scale = 1,
				Alpha = 1,
				GrowDirection = 3, -- 1 Up, 2 Down, 3 Center
				position = {
					x = 0.625,
					y = 0.280,
					relativeto = "CENTER",
				},
			},
		},
		settings = {
			Alpha = 1,
			BarBackgroundAlpha = .3,
			BackgroundAlpha = .8,
			Scale = 1,
			Width = 256,
			Height = 24,
			Locked = false,
			HideOOC = false,
			TrackOthersDebuffs = true,
			Inverted = false,
			Flash = false,
			TextEnabled = true,
			DurationTextEnabled = true,
			GrowDirection = 3, -- 1 Up, 2 Down, 3 Center
			Texture = "Blizzard",
			TexturePath = SharedMedia:Fetch("statusbar", "Blizzard"),
		},
	},
}

--------------------------------------------------------------
-- Event handlers
function RoguePowerBars:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RoguePowerBarsDB", defaults);
	db = self.db.profile;

	local firstrun=true;

	if (next(db.buffs)) then
		firstrun=false;
	elseif (next(db.debuffs)) then
		firstrun=false;
	elseif (next(db.othersDebuffs)) then
		firstrun=false;
	end

	if(db.version==nil or db.version==0) then
		
		self:BuildDefaults(4,firstrun);
		db.version=revision;
		print("RoguePowerBars: First time running.  Setting up defaults.");
	else
		self:BuildDefaults(0,firstrun);
	end

	self:UpdateSavedData();

	self:InitializeBarSets();
	self:SetupOptions();
	self:ImportCustomTextures();
	self:UpdateBuffs();
end

function RoguePowerBars:UpdateSavedData()
	local _,_,num=string.find(db.version, "%s*(%d+)")

	if(tonumber(num)<=85) then
		self:BuildDefaults(4,false);
		db.version=revision;
	end
end

function RoguePowerBars:OnEnable()
	self:RegisterEvent("UNIT_AURA", "OnUnitAura")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEnteringWorld");
	--Test Combat watching
	self:RegisterEvent("PLAYER_REGEN_ENABLED","OnRegenEnabled");
	self:RegisterEvent("PLAYER_REGEN_DISABLED","OnRegenDisabled")
end

function RoguePowerBars:OnDisable()

end

function RoguePowerBars:OnUnitAura(eventName, unitID)
	if unitID == "player" or unitID == "target" or unitID == "focus" then
		self:UpdateBuffs();
	end
end

function RoguePowerBars:OnTargetChanged(eventName)
	self:UpdateBuffs();
end

--FIXME Reminder of testing for combat checks
function RoguePowerBars:OnRegenEnabled(eventName)
	inCombat=false;
end

function RoguePowerBars:OnRegenDisabled(eventName)
	inCombat=true;
end

-- function RoguePowerBars:OnProfileChanged(event, database, newProfileKey)
-- 	db = database.profile
-- 	self:PopulateBuffs();
-- 	self:PopulateDebuffs();
-- 	self:PopuateOthersDebuffs();
-- 	self:PopulateBarsetsSettings();
-- 	LibStub("AceConfigDialog-3.0"):CloseAll();
-- 	self:SetupBarsetPositions();
-- 	self:UpdateBuffs();
-- end

function RoguePowerBars:OnEnteringWorld()
	self:SetupBarsetPositions();
end


--------------------------------------------------------------
-- Buff/debuff update handlers
function RoguePowerBars:UpdateBuffs()
	local currentTime = GetTime();
	local buffs = { };
	local buffIndex, name;
	local rank, texture, count, buffType, fullDuration, expirationTime, caster;
	local buffmatrix = {
		OnPlayer = {
			source = "OnPlayer",
			target = "player",
			filter = "HELPFUL",
			searchTable = db.buffs,
		},
		OnTarget = {
			source = "OnTarget",
			target = "target",
			filter = "HARMFUL|PLAYER",
			searchTable = db.debuffs,
		},
	}
	if db.settings.TrackOthersDebuffs then
		buffmatrix.OthersDebuffsOnTarget = {
			source = "OthersDebuffsOnTarget",
			target = "target",
			filter = "HARMFUL",
			searchTable = db.othersDebuffs,
		}
	end
	if UnitGUID("focus") and (UnitGUID("target") ~= UnitGUID("focus")) then
		buffmatrix.OnFocus = {
			source = "OnFocus",
			target = "focus",
			filter = "HARMFUL|PLAYER",
			searchTable = db.debuffs,
		}
	end
	for k,set in pairs(buffmatrix) do
		name = "dummy";
		buffIndex = 1;
		while name do
			name, rank, texture, count, buffType, fullDuration, expirationTime, caster = UnitAura(set.target, buffIndex, set.filter);

			if( set.source == "OthersDebuffsOnTarget" and caster == "player" ) then
				--prevents a bar from showing up if you're going through the other debuffs
				--list and find one that you've cast.  This prevents two bars at once with
				--the same spell on them.

			--	print("RoguePowerBars: skipped bar (other): "..name);

			else

				if name then
					local buffSettings = set.searchTable[self:RemoveSpaces(name)];
					if buffSettings and buffSettings.IsEnabled then
						table.insert(buffs, {
							BuffIndex = buffIndex,
							Name = name,
							TimeLeft = expirationTime - currentTime,
							MaxTime = fullDuration,
							Settings = buffSettings,
							Texture = texture,
							Stacks = count,
							ExpirationTime = expirationTime,
							IsOnFocus = UnitIsUnit(set.target,"focus"),
							Caster = caster,
							IsMine = (caster=="player" or caster=="vehicle"),
							IsOn = set.target,
							Source = set.source,
					    	});
					end
				end
			end
			buffIndex = buffIndex + 1;
		end
	end
	self:SetStatusBars(buffs);
end


function RoguePowerBars:SetStatusBars(buffs)
	self:ClearAllBars();
	for x = 1, #buffs do
		local buff = buffs[x];
		local barset;

		if buff.IsOn == "player" then -- my buff, on myself
			barset = BarSets[db.barsets[db.buffs[self:RemoveSpaces(buff.Name)].Barset]];
		elseif buff.IsMine then -- my debuff, on target or focus
			barset = BarSets[db.barsets[db.debuffs[self:RemoveSpaces(buff.Name)].Barset]];
		else -- someone else's debuff, on our target or focus
			-- once got a random nil error here and I have no idea what caused it and have never seen it again
			if (BarSets[db.barsets[db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset]]) then --FIXME  --temp fix
				barset = BarSets[db.barsets[db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset]]
			else
				if(buff) then
					-- asks them to report it if they get the same error
					-- this might spam people's default chat box.
					if(debug) then
						print("RoguePowerBars: PM Verik on curse the following: "..tostring(buff.Name) .." " ..tostring(buff.Source).." "..tostring(buff.IsOn).." "..tostring(buff.Caster));
						print("RoguePowerBars: type '/rpb debug' to disable till next session");
					end
				else
					--print("RoguePowerBars: no buff") -- hide this
				end
			end
		end
		local bar = self:CreateBar(buff.Name, barset, buff.ExpirationTime);
		self:ConfigureBar(bar, buff);
	end
	for k,barset in pairs(BarSets) do
		local label = getglobal(barset:GetName().."_BarsetText");
		label:Hide();
		barset:SetScale(db.settings.Scale * db.barsetsettings[barset.Info.Name].Scale);
		barset:SetAlpha(db.settings.Alpha * db.barsetsettings[barset.Info.Name].Alpha);
		if db.settings.Locked then
			if #barset.Info.Bars == 0 then
				barset:SetHeight(db.settings.Height);
				barset:Hide();
			else
				barset:SetHeight(#barset.Info.Bars * db.settings.Height);
				barset:Show();
			end
			barset:SetBackdropColor(0, 0, 0, db.settings.BackgroundAlpha);
			barset:EnableMouse(false);
		else
			barset:Show();
			if #barset.Info.Bars == 0 then
				barset:SetHeight(db.settings.Height);
				-- set visible
				barset:SetBackdrop({
					bgFile = "Interface/Tooltips/UI-Tooltip-Background",
					tile = true,
				});
				barset:SetBackdropColor(0, 0, 0, .8);
				label:Show();
				label:SetText(barset.Info.Name);
			else
				barset:SetHeight(#barset.Info.Bars * db.settings.Height);
				barset:SetBackdropColor(0, 0, 0, .8);
			end
			barset:EnableMouse(true);
		end

		--FIXME tagging to remember this is here
		--combat testing reminder
		if(db.settings.HideOOC) then
			if (inCombat) then
				barset:Show();
			else
				barset:Hide();
			end
		end

		barset:SetWidth(db.barsetsettings[barset.Info.Name].Width);
		table.sort(barset.Info.Bars, 
			function (a, b) return self:Priority(a,b) end);
		-- positioning follows
		local lastbar;
		local growdirection = db.barsetsettings[barset.Info.Name].GrowDirection;
		for i,bar in ipairs(barset.Info.Bars) do
			bar:ClearAllPoints();
			if i == 1 then
				if growdirection == 1 then
					bar:SetPoint("BOTTOM", barset, "BOTTOM");
				else
					bar:SetPoint("TOP", barset, "TOP");
				end
			else
				if growdirection == 1 then
					bar:SetPoint("BOTTOM", lastbar, "TOP");
				else
					bar:SetPoint("TOP", lastbar, "BOTTOM");
				end
			end
			lastbar = bar;
			bar:SetHeight(db.settings.Height);
			bar:SetWidth(db.barsetsettings[barset.Info.Name].Width);
		end
	end
end

-- function used in sorting bars in a barset.Info.Bars according to priority
-- Since we want items with higher priority to be the more 'constant' part of
-- our bars, we sort from highest->lowest priority.
function RoguePowerBars:Priority(a, b)
	-- local aName = self:RemoveSpaces(a.Info.Name)
	-- local bName = self:RemoveSpaces(b.Info.Name)
	-- return db.buffs[aName].Priority > db.buffs[bName].Priority;
	return a.Info.Priority > b.Info.Priority;
end

function RoguePowerBars:ConfigureBar(bar, buff)
	local barname = bar:GetName();
	local statusbar = getglobal(barname.."_StatusBar")
	local settings;
	if buff.IsOn == "player" then
		settings = db.buffs[self:RemoveSpaces(buff.Name)];
	elseif buff.IsMine then
		settings = db.debuffs[self:RemoveSpaces(buff.Name)];
	else
		settings = db.othersDebuffs[self:RemoveSpaces(buff.Name)];
	end
	
	bar.Info.Priority = settings.Priority;
	
	-- local c = db.buffs[self:RemoveSpaces(buff.Name)].Color -- status bar color
	local c = settings.Color
	if buff.ExpirationTime == 0 then
		statusbar:SetMinMaxValues(0, 1);
	else
		statusbar:SetMinMaxValues(0, buff.MaxTime);
	end
	statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a)
	statusbar:SetStatusBarTexture(db.settings["TexturePath"])
	
	local bg = getglobal(barname.."_BarBackGround");
	local barbgalpha = db.settings.BarBackgroundAlpha;
	bg:GetBackdrop().bgFile = db.settings["TexturePath"];
	bg:SetBackdropColor(c.r, c.g, c.b, barbgalpha)
	
	local describetext = getglobal(barname.."_DescribeText");
	local description = buff.Name;
	if buff.Stacks > 0 then
		description = description.." ("..buff.Stacks..")"
	end
	if buff.IsOnFocus then
		description = description.." [Focus]";
	end
	if not buff.IsMine then
		description = "***"..description.."***";
	end
	if db.settings.TextEnabled then
		describetext:Show();
		describetext:SetText(description);
	else
		describetext:Hide();
	end
	
	if db.settings.DurationTextEnabled then
		getglobal(barname.."_DurationText"):Show();
	else
		getglobal(barname.."_DurationText"):Hide();
	end
	
	getglobal(barname.."_Icon"):SetTexture(buff.Texture)
	bar:GetParent():Show();
	bar:SetPoint("TOP", bar:GetParent(), "TOP");
	bar:Show();
	bar.Info.BuffInfo = buff;
end

local buffsPlugin = { };
local debuffsPlugin = { };
local othersDebuffsPlugin = { };
local barsetsPlugin = { };

local options = {
	name = "RoguePowerBars",
	handler = RoguePowerBars,
	type = "group",
	args = {
		config={
			name = "config",
			type = "execute",
			desc = "Opens the configuration window.",
			func = function () RoguePowerBars:OpenConfig() end,
		},
		General={
			order = 1,
			type = "group",
			name = "General",
			desc = "General Settings",
			get = function(info) 
				return db.settings[info[#info]] 
			end,
			set = function(info, value) 
				db.settings[info[#info]] = value
				RoguePowerBars:UpdateBuffs();
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "Version "..version.." - Updated by Domia on Maiev-US (Curse profile: Asuah)",
				},
				Locked = {
					order = 2,
					type = "toggle",
					name = "Locked",
					desc = "Lock/unlock the bars",
				},
				HideOOC = {
					order = 3,
					type = "toggle",
					name = "Hide out of combat",
					desc = "Hide/Show the bars when not in combat",
				},
				Inverted = {
					order = 3,
					type = "toggle",
					name = "Inverted bars",
					desc = "Invert the bars",
				},
				Flash = {
					order = 4,
					type = "toggle",
					name = "Flash low bars",
					desc = "Flash bars with less than 5 seconds left",
				},
				TextEnabled = {
					order = 5,
					type = "toggle",
					name = "Text Enabled",
					desc = "Enable text on the bars",
				},
				DurationTextEnabled = {
					order = 6,
					type = "toggle",
					name = "Duration Text Enabled",
					desc = "Enable duration information on the bars",
				},
				TrackOthersDebuffs = {
					order = 7,
					type = "toggle",
					name = "Track Other's Debuffs",
					desc = "Enable tracking of other players' debuffs",
				},
				Divider1 = {
					order = 8,
					type = "description",
					name = "",
				},
				Scale = {
					order = 9,
					type = "range",
					name = "Scale",
					min = .25, max = 3, step = .01,
				},
				Alpha = {
					order = 10,
					type = "range",
					name = "Alpha",
					min = 0, max = 1, step = .01,
				},
				BarBackgroundAlpha = {
					order = 11,
					type = "range",
					name = "Bar Background Alpha",
					min = 0, max = .5, step = .01,
				},
				BackgroundAlpha = {
					order = 12,
					type = "range",
					name = "Background Alpha",
					min = 0, max = 1, step = .01,
				},
				Divider2 = {
					order = 13,
					type = "description",
					name = "",
				},
				Texture = {
					order = 14,
					type = "select", 
					dialogControl = 'LSM30_Statusbar',
					name = "Texture",
					desc = "The texture that will be used",
					values = AceGUIWidgetLSMlists.statusbar,
					set = function(info, value)
						db.settings[info[#info]] = value
						db.settings["TexturePath"] = SharedMedia:Fetch("statusbar", value)
						RoguePowerBars:UpdateBuffs();
					end,
				},
			},
		},
		Buffs={
			type = "group",
			name = "Buffs",
			desc = "Buff Settings",
			plugins = buffsPlugin,
			args = {
				AddBarInput = {
					order = 0,
					type = "input",
					name = "Add buff:",
					desc = "Input a buff name here to be tracked:",
					set = function(info, value)
						RoguePowerBars:CreateNewBuff(value);
					end
				},
				Divider = {
					type = "description",
					name = "",
					order = 1,
					width = "half", -- hacky
				},
				RestoreDefaultBuffs = {
					order = 2,
					type = "execute",
					name = "Reset to default buffs",
					desc = "Restore buff lists to default values",
					func = function()
						RoguePowerBars:BuildDefaults(1,true);
						RoguePowerBars:PopulateBuffs();
					end
				},
			},
		},
		Debuffs={
			type = "group",
			name = "Debuffs",
			desc = "Debuff Settings",
			plugins = debuffsPlugin,
			args = {
				AddBarInput = {
					order = 0,
					type = "input",
					name = "Add debuff:",
					desc = "Input a debuff name here to be tracked:",
					set = function(info, value)
						RoguePowerBars:CreateNewDebuff(value);
					end
				},
				Divider = {
					type = "description",
					name = "",
					order = 1,
					width = "half", -- hacky
				},
				RestoreDefaultDebuffs = {
					order = 2,
					type = "execute",
					name = "Reset to default debuffs",
					desc = "Restore debuff lists to default values",
					func = function()
						RoguePowerBars:BuildDefaults(2,true);
						RoguePowerBars:PopulateDebuffs();
					end
				},
			},
		},
		OthersDebuffs={
			type = "group",
			name = "Others' Debuffs",
			desc = "Other players' debuffs",
			plugins = othersDebuffsPlugin,
			args = {
				AddBarInput = {
					order = 0,
					type = "input",
					name = "Add debuff:",
					desc = "Input a debuff name here to be tracked:",
					set = function(info, value)
						RoguePowerBars:CreateNewOthersDebuff(value);
					end
				},
				Divider = {
					type = "description",
					name = "",
					order = 1,
					width = "half", -- hacky
				},
				RestoreDefaultOthersDebuffs = {
					order = 2,
					type = "execute",
					name = "Reset to defaults", -- button isn't long enough for better description
					desc = "Restore other's debuffs lists to default values",
					func = function()
						RoguePowerBars:BuildDefaults(3,true);
						RoguePowerBars:PopulateOthersDebuffs();
					end
				},
			},
		},
		Barsets={
			type = "group",
			name = "Barsets",
			desc = "Barset Settings",
			plugins = barsetsPlugin,
			args = {
				AddBarInput = {
					order = 0,
					type = "input",
					name = "Create barset:",
					desc = "Input a name here to create a new barset",
					set = function(info, value)
						RoguePowerBars:CreateNewBarSet(value);
					end
				},
			},
		},
	},
}

function RoguePowerBars:CreateNewBarSet(name)
	name = self:RemoveSpaces(name);
	db.barsets[#db.barsets+1] = name;
	db.barsetsettings[name] = {
		IsEnabled = true,
		Width = 256,
		Scale = 1,
		Alpha = 1,
		GrowDirection = 3,
		position = {
			x = .5,
			y = .5,
			relativeto = "CENTER",
		},
	};
	local barset = self:CreateBarSet(name);
	barset:SetHeight(24);
	self:PopulateBarsetsSettings();
	self:UpdateBuffs();
end

function RoguePowerBars:CreateNewBuff(name)
	if not db.buffs[self:RemoveSpaces(name)] then
		db.buffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5,
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1,
		}
		self:PopulateBuffs();
	else
		self:Print("That buff is already being tracked.");
	end
end

function RoguePowerBars:CreateNewDebuff(name)
	if not db.debuffs[self:RemoveSpaces(name)] then
		db.debuffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5,
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1,
		}
		self:PopulateDebuffs();
		self:UpdateBuffs();
	else
		self:Print("That debuff is already being tracked.");
	end
end

function RoguePowerBars:CreateNewOthersDebuff(name)
	if not db.othersDebuffs[self:RemoveSpaces(name)] then
		db.othersDebuffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5,
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1,
		}
		self:PopulateOthersDebuffs();
	else
		self:Print("That debuff is already being tracked.");
	end
end

function RoguePowerBars:RemoveBarset(name)
	if self:CountInBarset(name) ~= 0 then
		self:Print("That barset is not empty. Printed above are all the buffs/debuffs that are in that barset. Please change them to another barset.");
	else
		name = self:RemoveSpaces(name);
		for i = 1,#db.barsets do
			if db.barsets[i] == name then
				db.barsets[i] = nil;
				break;
			end
		end
		db.barsetsettings[name] = nil;
		local frame = BarSets[name];
		frame:Hide();
		BarSets[name] = nil;
		self:PopulateBarsetsSettings();
		self:UpdateBuffs();
		local ACD = LibStub("AceConfigDialog-3.0");
		ACD:CloseAll();
	end
end

function RoguePowerBars:CountInBarset(name)
	local count = 0;
	local searchlist = {
		Buffs = db.buffs,
		Debuffs = db.debuffs,
	}
	for k1,v1 in pairs(searchlist) do
		for k2,v2 in pairs(v1) do
			if db.barsets[v2.Barset] == name then
				count = count + 1;
				self:Print(v2.Name);
			end
		end
	end
	return count;
end

function RoguePowerBars:SetupOptions()
	self.optionsFrames = {};
	LibStub("AceConfig-3.0"):RegisterOptionsTable("RoguePowerBars", options);
	local ACD = LibStub("AceConfigDialog-3.0");
	self:PopulateBuffs();
	self:PopulateDebuffs();
	self:PopulateOthersDebuffs();
	self:PopulateBarsetsSettings();
	self.optionsFrames.RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General");
	self.optionsFrames.Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs");
	self.optionsFrames.Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs");
	self.optionsFrames.OthersDebuffs = ACD:AddToBlizOptions("RoguePowerBars", "OthersDebuffs", "RoguePowerBars", "OthersDebuffs");
	self.optionsFrames.Barsets = ACD:AddToBlizOptions("RoguePowerBars", "Barsets", "RoguePowerBars", "Barsets");
	-- self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles");
	self:RegisterChatCommand("rpb", "ChatCommand");
end

-- copied from omen
-- function RoguePowerBars:RegisterModuleOptions(name, optionTbl, displayName)
-- 	options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
-- 	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RoguePowerBars", displayName, "RoguePowerBars", name);
-- end

function RoguePowerBars:PopulateBuffs()
	buffsPlugin.buffs = {};	
	local buffs = buffsPlugin.buffs;
	local buffList = self:GetBuffList();
	-- for i = 1, #buffList do
	for k,buffSettings in pairs(buffList) do
		-- local buffSettings = v;
		if(buffSettings.Name ~= nil) then
			local buffName = self:RemoveSpaces(buffSettings.Name);
			buffs[buffName] = {
				type = "group",
				name = buffSettings.Name,
	--			order = i,
				get = function(info)
					return db.buffs[info[#info-1]][info[#info]];
				end,
				set = function(info, value)
					db.buffs[info[#info-1]][info[#info]] = value;
					self:UpdateBuffs();
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						desc = "Enable "..buffSettings.Name,
					},
					Color = {
						type = "color",
						order = 2,
						name = "Bar Color",
						hasAlpha = true,
						get = function(info)
							local c = db.buffs[info[#info-1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = db.buffs[info[#info-1]].Color
							c.r, c.g, c.b, c.a = r, g, b, .8
							self:UpdateBuffs();
						end
					},
					Priority = {
						type = "range",
						order = 3,
						name = "Priority",
						min = -10, max = 10, step = 1,
						isPercent = false,
					},
					Barset = {
						type = "select",
						order = 4,
						name = "Barset",
						desc = "The barset this bar will be displayed in",
						values = self:GetBarSets(),
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5,
					},
					Remove = {
						order = 6,
						type = "execute",
						name = "Remove Buff",
						desc = "Removes this buff from the listing completely",
						func = function(info) 
							self:RemoveBuffOption(info[#info-1]) 
						end,
					},
				},
			};
		else
			print("RoguePowerBars: ".. tostring(k) .." possibly corrupt in buff list. Attempting to remove.")
			db.buffs[k]=nil
			self:PopulateBuffs();
		end
	end
end

function RoguePowerBars:RemoveBuffOption(name)
	db.buffs[self:RemoveSpaces(name)] = nil;
	self:PopulateBuffs();
	LibStub("AceConfigDialog-3.0"):CloseAll();
end

function RoguePowerBars:GetBarSets()
	return db.barsets;
end

function RoguePowerBars:PopulateDebuffs()
	debuffsPlugin.buffs = {};
	local buffs = debuffsPlugin.buffs;
	local buffList = self:GetDebuffList();
	-- for i = 1, #buffList do
	for k,buffSettings in pairs(buffList) do
		-- local buffSettings = buffList[i];
		if(buffSettings.Name ~= nil) then	
			local buffName = self:RemoveSpaces(buffSettings.Name);
			buffs[buffName] = {
				type = "group",
				name = buffSettings.Name,
	--			order = i,
				get = function(info)
					return db.debuffs[info[#info-1]][info[#info]];
				end,
				set = function(info, value)
					db.debuffs[info[#info-1]][info[#info]] = value;
					self:UpdateBuffs();
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						desc = "Enable "..buffSettings.Name,
					},
					Color = {
						type = "color",
						order = 2,
						name = "Bar Color",
						hasAlpha = true,
						get = function(info)
							local c = db.debuffs[info[#info-1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = db.debuffs[info[#info-1]].Color
							c.r, c.g, c.b, c.a = r, g, b, .8
							self:UpdateBuffs();
						end
					},
					Priority = {
						type = "range",
						order = 3,
						name = "Priority",
						min = -10, max = 10, step = 1,
						isPercent = false,
					},
					Barset = {
						type = "select",
						order = 4,
						name = "Barset",
						desc = "The barset this bar will be displayed in",
						values = self:GetBarSets(),
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5,
					},
					Remove = {
						order = 6,
						type = "execute",
						name = "Remove Debuff",
						desc = "Removes this debuff from the listing completely",
						func = function(info) 
							self:RemoveDebuffOption(info[#info-1]) 
						end,
					},
				},
			};
		else
			print("RoguePowerBars: ".. tostring(k) .." possibly corrupt in debuff list. Attempting to remove.")
			db.debuffs[k]=nil
			self:PopulateDebuffs();
		end
	end
end

function RoguePowerBars:RemoveDebuffOption(name)
	db.debuffs[self:RemoveSpaces(name)] = nil;
	self:PopulateDebuffs();
	LibStub("AceConfigDialog-3.0"):CloseAll();
end

function RoguePowerBars:PopulateOthersDebuffs()
	othersDebuffsPlugin.buffs = {};
	local buffs = othersDebuffsPlugin.buffs;
	local listing = self:GetOthersDebuffsList();
	-- for i = 1, #listing do
	for k,settings in pairs(listing) do
		-- local settings = listing[i];
		if(settings.Name ~= nil) then
			local name = self:RemoveSpaces(settings.Name);
			buffs[name] = {
				type = "group",
				name = settings.Name,
	--			order = i,
				get = function(info)
					return db.othersDebuffs[info[#info-1]][info[#info]];
				end,
				set = function(info, value)
					db.othersDebuffs[info[#info-1]][info[#info]] = value;
					self:UpdateBuffs();
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						desc = "Enable "..settings.Name,
					},
					Color = {
						type = "color",
						order = 2,
						name = "Bar Color",
						hasAlpha = true,
						get = function(info)
							local c = db.othersDebuffs[info[#info-1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = db.othersDebuffs[info[#info-1]].Color
							c.r, c.g, c.b, c.a = r, g, b, .8
							self:UpdateBuffs();
						end,
					},
					Priority = {
						type = "range",
						order = 3,
						name = "Priority",
						min = -10, max = 10, step = 1,
						isPercent = false,
					},
					Barset = {
						type = "select",
						order = 4,
						name = "Barset",
						desc = "The barset this bar will be displayed in",
						values = self:GetBarSets(),
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5,
					},
					Remove = {
						order = 6,
						type = "execute",
						name = "Remove Debuff",
						desc = "Removes this debuff from the listing completely",
						func = function(info) 
							self:RemoveOthersDebuffOption(info[#info-1]) 
						end,
					},
				},
			};
		else
			print("RoguePowerBars: ".. tostring(k) .." possibly corrupt in others debuff list. Attempting to remove.")
			db.othersDebuffs[k]=nil
			self:PopulateOthersDebuffs();
		end
	end
end

function RoguePowerBars:RemoveOthersDebuffOption(name)
	db.othersDebuffs[self:RemoveSpaces(name)] = nil;
	self:PopulateOthersDebuffs();
	LibStub("AceConfigDialog-3.0"):CloseAll();
end

function RoguePowerBars:PopulateBarsetsSettings()
	barsetsPlugin.barsets = {};
	
	local barsets = db.barsets;
	local bs = barsetsPlugin.barsets;
	for i,v in ipairs(barsets) do
		local barsetSettings = db.barsetsettings[v];
		bs[v] = {
			type = "group",
			name = v,
			order = i,
			get = function(info) 
				return db.barsetsettings[info[#info-1]][info[#info]]
			end,
			set = function(info, value)
				self:UpdateBuffs();
				db.barsetsettings[info[#info-1]][info[#info]] = value
			end,
			args = {
				Width = {
					type = "range",
					order = 2,
					name = "Width",
					min = 100, max = 700, step = 5,
				},
				Scale = {
					type = "range",
					order = 3,
					name = "Scale",
					min = .25, max = 3, step = .01,
				},
				Alpha = {
					order = 4,
					type = "range",
					name = "Alpha",
					min = 0, max = 1, step = .01,
				},
				GrowDirection = {
					order = 5,
					type = "select",
					name = "Grow Direction",
					values = {"Up", "Down", "Both"},
					set = function(info, value)
						db.barsetsettings[info[#info-1]][info[#info]] = value
						self:OnBarsetMove(BarSets[info[#info-1]]);
					end,
				},
				Divider1 = {
					type = "description",
					name = "",
					order = 6,
				},
				Remove = {
					order = 7,
					type = "execute",
					name = "Remove Barset",
					func = function(info) self:RemoveBarset(info[#info-1]) end,
				},
			},
		}
	end
end

function RoguePowerBars:RemoveSpaces(s)
	return (string.gsub(s, " ", ""))
end

function RoguePowerBars:BuildDefaults(restore,clear)

	-- This basically stops it from adding the default buffs if buffs
	-- already exist.  Assumes you want at least one item tracked in each list type
	-- even if it's disabled.  Removing full list resets to default on next load.
	

	-- restore 	1=buffs
	-- 		2=debuffs
	-- 		3=otherdebuffs
	-- 		4=all


	local defaultmatrix = {};

	if (restore==1 or restore==4) then
		if(clear) then
			db.buffs={};
		end
		defaultmatrix.buffDefault = {
			defaults = RoguePowerBar_Buff_Default,
			destTable = db.buffs,
			defaultBarset = 1,
		}
	end
	if (restore==2 or restore==4) then
		if(clear) then
			db.debuffs={};
		end
		defaultmatrix.debuffDefault = {
			defaults = RoguePowerBar_Debuff_Default,
			destTable = db.debuffs,
			defaultBarset = 2,
		}
	end
	if (restore==3 or restore==4) then
		if(clear) then
			db.othersDebuffs={};
		end
		defaultmatrix.othersDebuffsDefault = {
			defaults = RoguePowerBar_OthersDebuffs_Default,
			destTable = db.othersDebuffs,
			defaultBarset = 2,
		}
	end


	for k,set in pairs(defaultmatrix) do
		for i = 1, #set.defaults do
			local buff = set.defaults[i];
			local nameSansSpaces = self:RemoveSpaces(buff.Name);
			set.destTable[nameSansSpaces] = {
				Name = buff.Name,
				Color = {
					r = buff.StatusBarColor.r,
					g = buff.StatusBarColor.g,
					b = buff.StatusBarColor.b,
					a = buff.StatusBarColor.a,
				},
				IsEnabled = true,
				Priority = 0,
				Barset = set.defaultBarset,
			}
		end
	end
end

function RoguePowerBars:GetBuffList()
	return db.buffs;
end

function RoguePowerBars:GetDebuffList()
	return db.debuffs;
end

function RoguePowerBars:GetOthersDebuffsList()
	return db.othersDebuffs;
end
-----------------------------------------------------------------
-- Slash command handler
function RoguePowerBars:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars);
	elseif input == "lock" then
		self:ToggleLocked();
	elseif input == "debug" then
		self:ToggleDebug();
		if(debug) then
			print("RoguePowerBars: Debug messages are now on");
		else
			print("RoguePowerBars: Debug messages are now off");
		end
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", input);
	end
end

function RoguePowerBars:ToggleLocked()
	db.settings.Locked = not db.settings.Locked;
	self:UpdateBuffs();
end

function RoguePowerBars:ToggleDebug()
	debug = not debug;
end

------------------------------------------------------------------
-- UI Functions

function RoguePowerBars:InitializeBarSets()
	for i,v in pairs(db.barsets) do
		local barset = self:CreateBarSet(v);
		barset:SetHeight("24"); -- FIXME
	end
end

function RoguePowerBars:SetupBarsetPositions()
	for k,barset in pairs(BarSets) do
		local settings = db.barsetsettings[barset.Info.Name].position;
		local x = settings.x * UIParent:GetWidth();
		local y = settings.y * UIParent:GetHeight();
		barset:SetPoint(settings.relativeto, nil, "bottomleft", x, y);
	end
end

function RoguePowerBars:CreateBarSet(name)
	if not BarSets[name] then
		local frame = CreateFrame("Frame", "RoguePowerBars_BarSet_"..name, UIParent, "RoguePowerBarSetTemplate");
		frame.Info = {
			Name = name,
			Bars = { },
		}
		BarSets[name] = frame;
		frame:SetPoint("CENTER", nil, "CENTER");
		return BarSets[name];
	else
		error("BarSet "..name.." already exists.");
	end
end

function RoguePowerBars:GetBuffBarset() -- debug function
	return BarSets["Buffs"];
end

function RoguePowerBars:AddBarToSet(barFrame, barSet)
	local barSetFrame;
	if type(barSet) == "string" then
		barSetFrame = BarSets[barSet];
	elseif type(barSet) == "table" then
		barSetFrame = barSet;
	end
	barFrame:SetParent(barSetFrame);
	barSetFrame.Info.Bars[#barSetFrame.Info.Bars+1] = barFrame;
end

function RoguePowerBars:CreateBar(name, parentBarset, expirationTime)
	-- assumes parentBarset is the parent frame.
	local bar;
	local currentTime = GetTime();
	local timeleft;
	
	if #BarsToRecycle > 0 then
		bar = BarsToRecycle[#BarsToRecycle];
		BarsToRecycle[#BarsToRecycle] = nil;
	else
		BarCount = BarCount + 1;
		bar = CreateFrame("Frame", "RoguePowerBars_Bar_"..BarCount, parentBarset, "RoguePowerBarTemplate");
	end
	
	if db.settings.Inverted then
		timeleft = expirationTime - currentTime;
	else
	
	end
	
	bar.Info = {
		Name = name,
		Duration = expirationTime - currentTime,
		TimeLeft = expirationTime - currentTime,
		ExpirationTime = expirationTime,
		StartTime = currentTime,
	}
	getglobal(bar:GetName().."_DescribeText"):SetText(name);
	getglobal(bar:GetName().."_StatusBar"):SetMinMaxValues(0, bar.Info.Duration);
	self:AddBarToSet(bar, parentBarset);
	return bar;
end

function RoguePowerBars:UpdateBar(bar, updateTime)
	local info = bar.Info;
	local statusbar = getglobal(bar:GetName().."_StatusBar");
	info.TimeLeft = info.ExpirationTime - updateTime;
	bar:SetAlpha(self:GetFadeAlpha(bar));
	if info.BuffInfo.ExpirationTime == 0 then
		statusbar:SetValue(1);
		getglobal(bar:GetName().."_DurationText"):SetText("");
	elseif info.TimeLeft >= 0 then
		if db.settings.Inverted then
			local min, max = statusbar:GetMinMaxValues()
			statusbar:SetValue(max - info.TimeLeft);
		else
			statusbar:SetValue(info.TimeLeft);
		end
		getglobal(bar:GetName().."_DurationText"):SetText(string.format("%.1f", info.TimeLeft));
	else
		self:RemoveBar(bar);
	end
end

function RoguePowerBars:GetFadeAlpha(bar)
	local timeleft = bar.Info.TimeLeft;
	local value;
	if timeleft > 5 or not db.settings.Flash then
		value =  1;
	else
		local fadeinterval = 1;
		if (timeleft % fadeinterval) > (fadeinterval / 2) then
			value = .2 + (.8 * (2 * (timeleft % (fadeinterval / 2))));
		else
			value = .2 + (.8 * (1 - (2 * (timeleft % (fadeinterval / 2)))));
		end
	end
	return value;
end

function RoguePowerBars:RemoveBar(bar)
	bar:Hide();
	self:RemoveBarFromSet(bar);
	BarsToRecycle[#BarsToRecycle+1] = bar;
	--todo: update barset.
end

function RoguePowerBars:RemoveBarFromSet(bar)
	local barSetFrame;
	barSetFrame = bar:GetParent();
	
	self:tremovebyval(barSetFrame.Info.Bars, bar);
end

function RoguePowerBars:tremovebyval(t, value)
	for k,v in ipairs(t) do
		if v == value then
			table.remove(t, k)
			return;
		end
	end
	-- if reached here, throw error
	error("Value "..tostring(value).." not found in table "..tostring(t));
end

function RoguePowerBars:ClearAllBars()
	local notClearedYet;
	for i,t in pairs(BarSets) do
		notClearedYet = true;
		while notClearedYet do
			for k,v in ipairs(t.Info.Bars) do
				self:RemoveBar(v);
			end
			notClearedYet = false;
			for k,v in ipairs(t.Info.Bars) do
				notClearedYet = true;
				break;
			end
		end
	end
end

function RoguePowerBars:OnUIUpdate(tick, frame)
	TimeSinceLastUIUpdate = TimeSinceLastUIUpdate + tick;
	if TimeSinceLastUIUpdate > UpdateRate then
		local updateTime = GetTime();
		for i,v in pairs(frame.Info.Bars) do
			self:UpdateBar(v, updateTime);
			
		end	
		if #frame.Info.Bars == 0 and db.settings.Locked then
			frame:Hide();
		end

		--I Don't really like putting this in an OnUpdate --tagged FIXME
		--Really needed here?
		if(db.settings.HideOOC) then
			if (inCombat) then
				frame:Show();
			else
				frame:Hide();
			end
		end

		TimeSinceLastUIUpdate = 0;
	end
end

function RoguePowerBars:OnBarsetMove(barset)
	local relativeto, x, y;
	x = barset:GetLeft();
	barset:ClearAllPoints();
	local growdirection = db.barsetsettings[barset.Info.Name].GrowDirection
	if growdirection == 1 then 
		-- grow direction: up, anchor: bottom
		relativeto = "bottomleft";
		y = barset:GetBottom();
	elseif growdirection == 2 then 
		-- grow direction: down
		relativeto = "topleft";
		y = barset:GetTop();
	elseif growdirection == 3 then
		-- grow direction: both ways
		relativeto = "left";
		y = barset:GetBottom() + barset:GetHeight() / 2;
	else
		error("That growdirection should not exist.");
	end
	barset:SetPoint(relativeto, nil, "bottomleft", x, y);
	db.barsetsettings[barset.Info.Name].position = {
		x = (x / UIParent:GetWidth()),
		y = (y / UIParent:GetHeight()),
		relativeto = relativeto,
	}
end

----------------------------------------------------------------------
-- Imports custom textures into SharedMedia
local BANTO_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureBanto.tga";
local LITESTEP_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureLiteStep.tga";
local OTRAVI_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureCanvas.tga";
local SMOOTH_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BatTextureSmooth.tga";

function RoguePowerBars:ImportCustomTextures()
	SharedMedia:Register("statusbar", "BantoBar", BANTO_TEXTURE);
	SharedMedia:Register("statusbar", "LiteStep", LITESTEP_TEXTURE);
	SharedMedia:Register("statusbar", "Otravi", OTRAVI_TEXTURE);
	SharedMedia:Register("statusbar", "Smooth", SMOOTH_TEXTURE);
end

