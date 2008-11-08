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

----------------------------------------------
-- Local variables
local db;
local BarSets = { } -- associative array
local BarsToRecycle = { } -- normal array
local BarCount = 0;
local TimeSinceLastUIUpdate = 0;


----------------------------------------------
-- Defaults for options
local defaults = {
	profile = {
		buffs = { },
		bars = { },
		barsets = { 
			"Buffs",
			"Debuffs",
		},
		barsetsettings = {
			Buffs = {
				IsEnabled = true,
				Width = 250,
				Scale = 1,
				Alpha = 1,
				GrowDirection = 3, -- 1 Up, 2 Down, 3 Center
				position = {
					x = .5,
					y = .5,
					relativeto = "CENTER",
				},
			},
			Debuffs = {
				IsEnabled = true,
				Width = 250,
				Scale = 1,
				Alpha = 1,
				GrowDirection = 3, -- 1 Up, 2 Down, 3 Center
				position = {
					x = .5,
					y = .5,
					relativeto = "CENTER",
				},
			},
		},
		settings = {
			Alpha = 1,
			BarBackgroundAlpha = .3,
			BackgroundAlpha = .8,
			Scale = 1,
			Width = 250,
			Height = 24,
			Locked = true,
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
	self:BuildDefaults()
	self.db = LibStub("AceDB-3.0"):New("RoguePowerBarsDB", defaults);
	db = self.db.profile;
	self:InitializeBarSets();
	self:SetupOptions();
	self:ImportCustomTextures();
	self:UpdateBuffs();
end

function RoguePowerBars:OnEnable()
	self:RegisterEvent("UNIT_AURA", "OnUnitAura")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEnteringWorld");
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

function UpdateBuffs()
	local rpb = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
	rpb:UpdateBuffs();
end

function OnBarsetMove(barset)
	local rpb = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
	rpb:OnBarsetMove(barset)
end

function RoguePowerBars:OnEnteringWorld()
	self:SetupBarsetPositions();
end


--------------------------------------------------------------
-- Buff/debuff update handlers
function RoguePowerBars:UpdateBuffs()
	local currentTime = GetTime();
	local buffs = { };
	local buffIndex, name;
	local rank, texture, count, buffType, fullDuration, expirationTime;
	local buffmatrix = {
		OnPlayer = {
			target = "player",
			filter = "HELPFUL",
		},
		OnTarget = {
			target = "target",
			filter = "HARMFUL|PLAYER",
		},
	}
	if UnitGUID("focus") and (UnitGUID("target") ~= UnitGUID("focus")) then
		buffmatrix.OnFocus = {
			target = "focus",
			filter = "HARMFUL|PLAYER",
		}
	end
	for k,set in pairs(buffmatrix) do
		name = "dummy";
		buffIndex = 1;
		while name do
			name, rank, texture, count, buffType, fullDuration, expirationTime = UnitAura(set.target, buffIndex, set.filter);
			if name then
				local buffSettings = db.buffs[self:RemoveSpaces(name)];
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
						IsOnFocus = (set.target == "focus"),
					});
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
		local barset = BarSets[db.barsets[db.buffs[self:RemoveSpaces(buff.Name)].Barset]];
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
	local aName = self:RemoveSpaces(a.Info.Name)
	local bName = self:RemoveSpaces(b.Info.Name)
	return db.buffs[aName].Priority > db.buffs[bName].Priority;
end

function RoguePowerBars:ConfigureBar(bar, buff)
	local barname = bar:GetName();
	local statusbar = getglobal(barname.."_StatusBar")
	local c = db.buffs[self:RemoveSpaces(buff.Name)].Color -- status bar color
	statusbar:SetMinMaxValues(0, buff.MaxTime);
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
end

local buffsPlugin = { };
local debuffsPlugin = { };
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
				UpdateBuffs();
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
				Divider1 = {
					order = 7,
					type = "description",
					name = "",
				},
				Scale = {
					order = 8,
					type = "range",
					name = "Scale",
					min = .25, max = 3, step = .01,
				},
				-- Width = {
				-- 	order = 9,
				-- 	type = "range",
				-- 	name = "Width",
				-- 	min = 100, max = 700, step = 5,
				-- },
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
					order = 11,
					type = "range",
					name = "Background Alpha",
					min = 0, max = 1, step = .01,
				},
				Divider2 = {
					order = 12,
					type = "description",
					name = "",
				},
				-- GrowDirection = {
				-- 	order = 13,
				-- 	type = "select",
				-- 	name = "Grow Direction",
				-- 	desc = "The direction that the bar will grow in",
				-- 	values = {"Up", "Down", "Both"},
				-- 	set = function(info, value) 
				-- 		db.settings[info[#info]] = value
				-- 		for k,barset in pairs(BarSets) do
				-- 			OnBarsetMove(barset);
				-- 		end
				-- 		UpdateBuffs();
				-- 	end,
				-- },
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
						UpdateBuffs();
					end,
				},
			},
		},
		Buffs={
			type = "group",
			name = "Buff",
			desc = "Buff Settings",
			plugins = buffsPlugin,
			args = {
				description = {
					order = 0,
					type = "description",
					name = "Enable or disable buffs here.",
				},
			},
		},
		Debuffs={
			type = "group",
			name = "Debuff",
			desc = "Debuff Settings",
			plugins = debuffsPlugin,
			args = {
				description = {
					order = 0,
					type = "description",
					name = "Enable or disable debuffs here.",
				},
			},
		},
		Barsets={
			type = "group",
			name = "Barsets",
			desc = "Barset Settings",
			plugins = barsetsPlugin,
			args = {
				description = {
					order = 0,
					type = "description",
					name = "Create or modify barsets here.",
				},
				AddBarInput = {
					order = 1,
					type = "input",
					name = "AddBarInput",
					set = function(info, value)
						CreateNewBarSet(value);
					end
				}
			},
		},
	},
}

function CreateNewBarSet(name)
	local rpb = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars");
	rpb:CreateNewBarSet(name);
end

function RoguePowerBars:CreateNewBarSet(name)
	name = self:RemoveSpaces(name);
	db.barsets[#db.barsets+1] = name;
	db.barsetsettings[name] = {
		IsEnabled = true,
		Width = 250,
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
	for k,v in pairs(db.buffs) do
		if db.barsets[v.Barset] == name then
			count = count + 1;
			self:Print(k);
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
	self:PopulateBarsetsSettings();
	self.optionsFrames.RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General");
	self.optionsFrames.Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs");
	self.optionsFrames.Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs");
	self.optionsFrames.Barsets = ACD:AddToBlizOptions("RoguePowerBars", "Barsets", "RoguePowerBars", "Barsets");
	self:RegisterChatCommand("rpb", "ChatCommand");
end

function RoguePowerBars:PopulateBuffs()
	if not buffsPlugin.buffs then
		buffsPlugin.buffs = {};
	end
		
	local buffs = buffsPlugin.buffs;
	local buffList = self:GetBuffList();
	for i = 1, #buffList do
		local buffSettings = buffList[i];
		local buffName = self:RemoveSpaces(buffSettings.Name);
		buffs[buffName] = {
			type = "group",
			name = buffSettings.Name,
			order = i,
			args = {
				IsEnabled = {
					type = "toggle",
					order = 1,
					name = "Enabled",
					desc = "Enable "..buffSettings.Name,
					get = function(info) 
						return db.buffs[info[#info-1]].IsEnabled 
					end,
					set = function(info, value) 
						db.buffs[info[#info-1]].IsEnabled = value 
					end,
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
					end
				},
				Priority = {
					type = "range",
					order = 3,
					name = "Priority",
					min = -10, max = 10, step = 1,
					isPercent = false,
					get = function(info)
						return db.buffs[info[#info-1]].Priority
					end,
					set = function(info, value)
						db.buffs[info[#info-1]].Priority = value
					end,
				},
				Barset = {
					type = "select",
					order = 4,
					name = "Barset",
					desc = "The barset this bar will be displayed in",
					values = self:GetBarSets(),
					get = function(info, value)
						return db.buffs[info[#info-1]].Barset;
					end,
					set = function(info, value)
						db.buffs[info[#info-1]].Barset = value
					end,
				}
			},
		};
	end
end

function RoguePowerBars:GetBarSets()
	return db.barsets;
end

function RoguePowerBars:PopulateDebuffs()
	if not debuffsPlugin.buffs then
		debuffsPlugin.buffs = {};
	end
		
	local buffs = debuffsPlugin.buffs;
	local buffList = self:GetDebuffList();
	for i = 1, #buffList do
		local buffSettings = buffList[i];
		local buffName = self:RemoveSpaces(buffSettings.Name);
		buffs[buffName] = {
			type = "group",
			name = buffSettings.Name,
			order = i,
			args = {
				IsEnabled = {
					type = "toggle",
					order = 1,
					name = "Enabled",
					desc = "Enable "..buffSettings.Name,
					get = function(info) 
						return db.buffs[info[#info-1]].IsEnabled 
					end,
					set = function(info, value) 
						db.buffs[info[#info-1]].IsEnabled = value 
					end,
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
					end
				},
				Priority = {
					type = "range",
					order = 3,
					name = "Priority",
					min = -10, max = 10, step = 1,
					isPercent = false,
					get = function(info)
						return db.buffs[info[#info-1]].Priority
					end,
					set = function(info, value)
						db.buffs[info[#info-1]].Priority = value
					end,
				},
				Barset = {
					type = "select",
					order = 4,
					name = "Barset",
					desc = "The barset this bar will be displayed in",
					values = self:GetBarSets(),
					get = function(info, value)
						return db.buffs[info[#info-1]].Barset;
					end,
					set = function(info, value)
						db.buffs[info[#info-1]].Barset = value
					end,
				},
			},
		};
	end
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
				UpdateBuffs();
				db.barsetsettings[info[#info-1]][info[#info]] = value
			end,
			args = {
				-- IsEnabled = {
				-- 	type = "toggle",
				-- 	order = 1,
				-- 	name = "Enabled",
				-- 	desc = "Enable "..v,
				-- },
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
						OnBarsetMove(BarSets[info[#info-1]]);
					end,
				},
				Remove = {
					order = 6,
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

function RoguePowerBars:BuildDefaults()
	buffDefault = RoguePowerBar_Buff_Default
	debuffDefault = RoguePowerBar_Debuff_Default
	for i = 1, #buffDefault do
		local buff = buffDefault[i]
		local nameSansSpaces = self:RemoveSpaces(buff.Name);
		defaults.profile.buffs[nameSansSpaces] = {
			Name = buff.Name,
			Color = {
				r = buff.StatusBarColor.r,
				g = buff.StatusBarColor.g,
				b = buff.StatusBarColor.b,
				a = buff.StatusBarColor.a,
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1,
		}
	end
	for i = 1, #debuffDefault do
		local debuff = debuffDefault[i]
		local nameSansSpaces = self:RemoveSpaces(debuff.Name);
		defaults.profile.buffs[nameSansSpaces] = {
			Name = debuff.Name,
			Color = {
				r = debuff.StatusBarColor.r,
				g = debuff.StatusBarColor.g,
				b = debuff.StatusBarColor.b,
				a = debuff.StatusBarColor.a,
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 2,
		}
	end
end

function RoguePowerBars:GetBuffList()
	return RoguePowerBar_Buff_Default;
end

function RoguePowerBars:GetDebuffList()
	return RoguePowerBar_Debuff_Default;
end
-----------------------------------------------------------------
-- Slash command handler
function RoguePowerBars:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars);
	elseif input == "create" then
		self:CreateTestBarSet();
	elseif input == "lock" then
		self:ToggleLocked();
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", input);
	end
end

function RoguePowerBars:ToggleLocked()
	db.settings.Locked = not db.settings.Locked;
	self:UpdateBuffs();
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
	-- FIXME: Need to have a custom function here that loads the position
	-- from the database, and not piggyback on the OnBarsetMove function.
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
	if info.TimeLeft >= 0 then
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

-----------------------------------------------------------------------
-- Debug functions
function RoguePowerBars:CreateTestBarSet()
	print("Creating a new barset");
	local barsetcount = 0;
	for k,v in pairs(BarSets) do
		barsetcount = barsetcount + 1;
	end
	local barset = self:CreateBarSet("Test"..(barsetcount + 1));
	local bar = self:CreateBar("Test"..(barsetcount + 1), barset, GetTime()+5);
	barset:SetHeight(24);
	barset:Show();
	bar:SetPoint("TOP", barset, "TOP");
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