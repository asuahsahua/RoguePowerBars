-- All new code by Anthony Marion on 10-20-2008 (Domia/Horde on Maiev).
-- On comes the massive Ace3 revamp. BLANK SLATE!

----------------------------------------------
-- Libraries

local RoguePowerBars = LibStub("AceAddon-3.0"):NewAddon("RoguePowerBars", "AceConsole-3.0", "AceEvent-3.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

---------------------------------------------
-- Defined constants
local UpdateRate = .01;


----------------------------------------------
-- Local variables
local db;
--------------------------------------------------------------------------------

local defaults = {
	profile = {
		buffs = { },
		bars = { },
		barsets = { 
			"Buffs",
			"Debuffs",
		},
		settings = {
			Alpha = 1,
			Scale = 1,
			Width = 250,
			Height = 24,
			Locked = false,
			Inverted = false,
			Flash = false,
			TextEnabled = true,
			DurationTextEnabled = true,
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
	self:SetupOptions()
end

function RoguePowerBars:OnEnable()
	self:RegisterEvent("UNIT_AURA", "OnUnitAura")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
end

function RoguePowerBars:OnDisable()

end

function RoguePowerBars:OnUnitAura(eventName, unitID)
	if unitID == "player" or unitID == "target" then
		self:UpdateBuffs();
	end
end

function RoguePowerBars:OnTargetChanged(eventName)
	self:UpdateBuffs();
end


--------------------------------------------------------------
-- Buff/debuff update handlers
function RoguePowerBars:UpdateBuffs()
	local currentTime = GetTime();
	local buffs = { };
	local buffIndex = 1;
	local name = "dummy";
	local rank, texture, count, buffType, fullDuration, expirationTime;
	while name do
		name, rank, texture, count, buffType, fullDuration, expirationTime = UnitAura("player", buffIndex, "HELPFUL");
		if name then
			local buffSettings = db.buffs[self:RemoveSpaces(name)];
			if buffSettings and buffSettings.IsEnabled then
				table.insert(buffs,{
					BuffIndex = buffIndex,
					Name = name,
					TimeLeft = expirationTime - currentTime,
					MaxTime = fullDuration,
					Settings = buffSettings,
					Texture = texture,
					Stacks = count
				});
			end
		end
		buffIndex = buffIndex + 1;
	end
	buffIndex = 1;
	name = "dummy";
	while name do
		name, rank, texture, count, buffType, fullDuration, expirationTime = UnitAura("target", buffIndex, "HARMFUL|PLAYER");
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
					Stacks = count
				});
			end
		end
		buffIndex = buffIndex + 1;
	end
	for x = 1, #buffs do
		self:SetStatusBar(buffs[x]);
	end
end

function RoguePowerBars:SetStatusBar(buff)
	print("Setting status bar for "..buff.Name);
end

local buffsPlugin = { };
local debuffsPlugin = { };

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
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "<A description for RoguePowerBars here>",
				},
				Locked = {
					order = 2,
					type = "toggle",
					name = "Locked",
					desc = "Lock/unlock the bars",
					set = function(info, value)
						db.settings[info[#info]] = value
						if value then
							print("bars should be locked")
						else
							print("bars should be unlocked")
						end
						-- todo: lock/unlock bars
					end,
				},
				Inverted = {
					order = 3,
					type = "toggle",
					name = "Inverted bars",
					desc = "Invert the bars",
					set = function(info, value)
						db.settings[info[#info]] = value
						if value then
							print("bars should be inverted")
						else
							print("bars should not be inverted")
						end
						-- todo: invert/uninvert bars
					end,
				},
				Flash = {
					order = 4,
					type = "toggle",
					name = "Flash low bars",
					desc = "Flash bars with a few seconds left",
					set = function(info, value)
						db.settings[info[#info]] = value
						if value then
							print("bars should now flash")
						else
							print("bars should now not flash")
						end
						-- todo: toggle flash
					end,
				},
				TextEnabled = {
					order = 5,
					type = "toggle",
					name = "Text Enabled",
					desc = "Enable text on the bars",
					set = function(info, value)
						db.settings[info[#info]] = value
						if value then
							print("bar text enabled")
						else
							print("bar text disabled")
						end
						-- todo: show text
					end,
				},
				DurationTextEnabled = {
					order = 6,
					type = "toggle",
					name = "Duration Text Enabled",
					desc = "Enable duration information on the bars",
					set = function(info, value)
						db.settings[info[#info]] = value
						if value then
							print("bar duration text enabled")
						else
							print("bar duration text disabled")
						end
						-- todo: show bar duration text
					end,
				},
				Alpha = {
					order = 7,
					type = "range",
					name = "Alpha",
					min = 0, max = 1, step = .01,
					set = function(info, value)
						db.settings[info[#info]] = value
						print("bar alpha should be updated to "..value)	
						-- todo: update alpha
					end,
				},
				Scale = {
					order = 8,
					type = "range",
					name = "Scale",
					min = .25, max = 3, step = .01,
					set = function(info, value) 
						db.settings[info[#info]] = value
						print("scale should be updated to "..value)
						-- todo: update scale
					end,
				},
				Width = {
					order = 9,
					type = "range",
					name = "Width",
					min = 100, max = 700, step = 5,
					set = function(info, value)
						db.settings[info[#info]] = value
						print("width should be updated to "..value)
						-- todo: update width
					end,
				},
				Height = {
					order = 10,
					type = "range",
					name = "Height",
					min = 10, max = 50, step = 1,
					set = function(info, value)
						db.settings[info[#info]] = value
						print("height should be updated to "..value)
						-- todo: update height
					end,
				},
				Texture = {
					order = 11,
					type = "select", 
					dialogControl = 'LSM30_Statusbar',
					name = "Texture",
					desc = "The texture that will be used",
					values = AceGUIWidgetLSMlists.statusbar,
					set = function(info, value)
						db.settings[info[#info]] = value
						db.settings["TexturePath"] = SharedMedia:Fetch("statusbar", value)
						print("texture set to "..value)
						-- todo: update textures
					end,
				},
				-- todo: sort order
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
	},
}

function RoguePowerBars:SetupOptions()
	self.optionsFrames = {};
	LibStub("AceConfig-3.0"):RegisterOptionsTable("RoguePowerBars", options);
	local ACD = LibStub("AceConfigDialog-3.0");
	self:PopulateBuffs();
	self:PopulateDebuffs();
	self.optionsFrames.RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General");
	self.optionsFrames.Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs");
	self.optionsFrames.Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs");
	self:RegisterChatCommand("rpb", "ChatCommand");
end

function RoguePowerBars:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars);
	elseif input == "create" then
		self:CreateTestBarSet();
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", input);
	end
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

------------------------------------------------------------------
-- UI Functions

local BarSets = { } -- associative array
local Bars = { } -- associative array
local BarsToRecycle = { } -- normal array
local BarCount = 0;

function RoguePowerBars:InitializeBarSets()
	for i,v in pairs(db.barsets) do
		self:CreateBarSet(v);
	end
end

function RoguePowerBars:CreateBarSet(name)
	if not BarSets[name] then
		local frame = CreateFrame("Frame", "RoguePowerBars_BarSet_"..name, UIParent, "RoguePowerBarSetTemplate");
		frame.Info = {
			Name = name,
		}
		BarSets[name] = {
			Name = name;
			Frame = frame;
			bars = {
				
			}
		}
		return BarSets[name].Frame
	else
		error("BarSet "..name.." already exists.");
	end
end

function RoguePowerBars:AddBarToSet(bar, barSet)
	local barSetFrame, barFrame;
	
	if type(barSet) == "string" then
		barSetFrame = assert(BarSets[barSet].frame, "BarSetFrame "..barSet.." does not exist.");
	elseif type(barSet) == "table" then
		barSetFrame = barSet;
	end
	
	BarSets[barSetFrame.Info.Name].bars[bar.Info.Name] = bar;
	return barSetFrame;
end

function RoguePowerBars:CreateBar(name, parentBarset, expirationTime)
	local bar;
	local currentTime = GetTime();
	if #BarsToRecycle > 0 then
		bar = BarsToRecycle[#BarsToRecycle];
		BarsToRecycle[#BarsToRecycle] = nil;
		if type(parentBarset) == "string" then
			bar:SetParent(BarSets[parentBarset].Frame);
		else
			bar:SetParent(parentBarset);
		end
		bar:Show();
	else
		BarCount = BarCount + 1
		if type(parentBarset) == "string" then
			parentBarset = assert(BarSets[parentBarset].Frame, "that barset does not exist.");
		end
		bar = CreateFrame("Frame", "RoguePowerBars_Bar_"..BarCount, parentBarset, "RoguePowerBarTemplate");
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
	Bars[bar.Info.Name] = bar;
	return bar;
end

function RoguePowerBars:CreateTestBarSet()
	print("Creating a new barset");
	local barsetcount = 0;
	for k,v in pairs(BarSets) do
		barsetcount = barsetcount + 1;
	end
	local barset = self:CreateBarSet("Test"..(barsetcount + 1));
	local bar = self:CreateBar("Test"..(barsetcount + 1), barset, GetTime()+5);
	barset:SetHeight(50);
	barset:Show();
	bar:SetPoint("TOP", barset, "TOP");
end

function RoguePowerBars:UpdateBar(bar, updateTime)
	local info = bar.Info;
	info.TimeLeft = info.ExpirationTime - updateTime;
	if info.TimeLeft >= 0 then
		getglobal(bar:GetName().."_StatusBar"):SetValue(info.TimeLeft);
		getglobal(bar:GetName().."_DurationText"):SetText(string.format("%.1f", info.TimeLeft));
	else
		self:RemoveBar(bar);
	end
end

function RoguePowerBars:RemoveBar(bar)
	bar:Hide();
	self:RemoveBarFromSet(bar);
	BarsToRecycle[#BarsToRecycle+1] = bar;
	--todo: update barset.
end

function RoguePowerBars:RemoveBarFromSet(bar)
	local barSetFrame, barFrame;
	barSetFrame = bar:GetParent();
	
	BarSets[barSetFrame.Info.Name].bars[bar.Info.Name] = nil;
	
	Bars[bar.Info.Name] = nil;
end

function RoguePowerBars:OnUIUpdate(tick, frame)
	local updateTime = GetTime();
	for i,v in pairs(BarSets[frame.Info.Name].bars) do
		self:UpdateBar(v, updateTime);
	end
end
