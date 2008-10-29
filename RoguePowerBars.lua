-- All new code by Anthony Marion on 10-20-2008 (Domia/Horde on Maiev).
-- On comes the massive Ace3 revamp. BLANK SLATE!

----------------------------------------------
-- Libraries

local RoguePowerBars = LibStub("AceAddon-3.0"):NewAddon("RoguePowerBars", "AceConsole-3.0", "AceEvent-3.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

----------------------------------------------
-- Local variables
local db;
--------------------------------------------------------------------------------

local defaults = {
	profile = {
		buffs = { },
		debuffs = { },
		settings = {
			Scale = 1,
			Width = 250,
			Height = 24,
			Texture = "Blizzard",
			TexturePath = SharedMedia:Fetch("statusbar", "Blizzard"),
		},
	},
}



function RoguePowerBars:OnInitialize()
	-- TODO: Defaults table
	self:BuildDefaults()
	self.db = LibStub("AceDB-3.0"):New("RoguePowerBarsDB", defaults);
	db = self.db.profile;
	self:SetupOptions()
end

function RoguePowerBars:OnEnable()

end

function RoguePowerBars:OnDisable()

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
				Scale = {
					order = 2,
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
					order = 3,
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
					order = 4,
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
					type = "select", 
					dialogControl = 'LSM30_Statusbar',
					order = 5,
					name = "Texture",
					desc = "The texture that will be used",
					values = AceGUIWidgetLSMlists.statusbar,
					set = function(info, value)
						db.settings[info[#info]] = value
						db.settings["TexturePath"] = SharedMedia:Fetch("statusbar", value)
						--for i = 0, #bars do
						--	bars[i].texture:SetTexture(texturepath)
						--end
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
			args = {},
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
			},
		};
	end
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
						return db.debuffs[info[#info-1]].IsEnabled 
					end,
					set = function(info, value) 
						db.debuffs[info[#info-1]].IsEnabled = value 
					end,
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
					end
				},
				Priority = {
					type = "range",
					order = 3,
					name = "Priority",
					min = -10, max = 10, step = 1,
					isPercent = false,
					get = function(info)
						return db.debuffs[info[#info-1]].Priority
					end,
					set = function(info, value)
						db.debuffs[info[#info-1]].Priority = value
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
		}
	end
	for i = 1, #debuffDefault do
		local debuff = debuffDefault[i]
		local nameSansSpaces = self:RemoveSpaces(debuff.Name);
		defaults.profile.debuffs[nameSansSpaces] = {
			Name = debuff.Name,
			Color = {
				r = debuff.StatusBarColor.r,
				g = debuff.StatusBarColor.g,
				b = debuff.StatusBarColor.b,
				a = debuff.StatusBarColor.a,
			},
			IsEnabled = true,
			Priority = 0,
		}
	end
end

function RoguePowerBars:GetBuffList()
	return RoguePowerBar_Buff_Default;
end

function RoguePowerBars:GetDebuffList()
	return RoguePowerBar_Debuff_Default;
end