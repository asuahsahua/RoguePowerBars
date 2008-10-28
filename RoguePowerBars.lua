-- All new code by Anthony Marion on 10-20-2008 (Domia/Horde on Maiev).
-- On comes the massive Ace3 revamp. BLANK SLATE!

----------------------------------------------
-- Libraries

local RoguePowerBars = LibStub("AceAddon-3.0"):NewAddon("RoguePowerBars", "AceConsole-3.0", "AceEvent-3.0")

----------------------------------------------
-- Local variables

-- todo: potentially make this save to savedvars and repopulate from there.

--------------------------------------------------------------------------------
function RoguePowerBars:OnInitialize()
	RoguePowerBars:SetupOptions()
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
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "<A description for RoguePowerBars here>",	
				},
				listing = {
					order = 2,
					type = "group",
					name = "Option1",
					args = {
						Test = {
							order = 1,
							type = "toggle",
							name = "Slice and Dice",
							desc = "Toggle Slice and Dice",
						},
					},
				},
			},
		},
		Buffs={
			type = "group",
			name = "Buff",
			desc = "Buff Settings",
			plugins = buffsPlugin,
			args = {},
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
	-- frame = ACD:AddToBlizOptions("addonname", "sublevel", "parent", "options arg");
	self:PopulateBuffs();
	self:PopulateDebuffs();
	self.optionsFrames.RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General");
	self.optionsFrames.Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs");
	self.optionsFrames.Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs");
	self:RegisterChatCommand("rpb", "ChatCommand");
end

function RoguePowerBars:ChatCommand(args)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars);
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", args);
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
		buffs[self:RemoveSpaces(buffSettings.Name)] = {
			type = "group",
			name = buffSettings.Name,
			order = i,
			args = {
				enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Toggle "..buffSettings.Name,
					value = false,
					get = function () return value; end,
					set = function(val) value = val; end,
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
		buffs[self:RemoveSpaces(buffSettings.Name)] = {
			type = "group",
			name = buffSettings.Name,
			order = i,
			args = {
				enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Toggle "..buffSettings.Name,
					value = false,
					get = function () return value; end,
					set = function(val) value = val; end,
				},
			},
		};
	end
end

function RoguePowerBars:RemoveSpaces(s)
	return (string.gsub(s, " ", ""))
end

function RoguePowerBars:GetBuffList()
	return RoguePowerBar_Buff_Default;
end

function RoguePowerBars:GetDebuffList()
	return RoguePowerBar_Debuff_Default;
end