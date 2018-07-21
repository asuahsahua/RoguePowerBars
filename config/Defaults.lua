local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local GROW = RoguePowerBars.Constants.GROW
local band = _G.bit.band

----------------------------------------------
-- Defaults for options
local defaults = {
	profile = {
		version = 0,
		buffs = {},
		debuffs = {},
		othersDebuffs = {},
		bars = {},
		barsets = {
			L["Buffs"],
			L["Debuffs"]
		},
		barsetsettings = {
			[L["Buffs"]] = {
				IsEnabled = true,
				Width = 256,
				Scale = 1,
				Alpha = 1,
				GrowDirection = GROW.UP,
				position = {
					x = 0.375,
					y = 0.280,
					relativeto = "CENTER"
				}
			},
			[L["Debuffs"]] = {
				IsEnabled = true,
				Width = 256,
				Scale = 1,
				Alpha = 1,
				GrowDirection = GROW.UP, -- 1 Up, 2 Down, 3 Center
				position = {
					x = 0.625,
					y = 0.280,
					relativeto = "CENTER"
				}
			}
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
			GrowDirection = GROW.CENTER, -- 1 Up, 2 Down, 3 Center
			Texture = "Blizzard",
			TexturePath = SharedMedia:Fetch("statusbar", "Blizzard")
		}
	}
}

function RoguePowerBars:InitializeDatabase()
	self.db = LibStub("AceDB-3.0"):New("RoguePowerBarsDB", defaults, true)
	self.profile = self.db.profile
	local profile = self.profile
	local RESTORE = self.Constants.RESTORE
	
	local alreadyRun = (profile.buffs and #profile.buffs > 0)
				  or (profile.debuffs and #profile.debuffs > 0)
				  or (profile.othersDebuffs and #profile.othersDebuffs > 0)

	--automatically push known spells to database if the current database doesn't
	--have proper version information.
	-- First run people will get a clean database while old dbs will get missing spells added
	if (self.profile.version == nil or self.profile.version == 0) then
		self:Print(L["This appears to be the first time you have run the addon. Setting up default values."])
		self:BuildDefaults(RESTORE.ALL, not alreadyRun)
		self.profile.version = self:GetVersion() --update db version
	else
		self:UpdateSavedData()
	end
end

function RoguePowerBars:BuildDefaults(restore, clear)
	-- This basically stops it from adding the default buffs if buffs
	-- already exist.  Assumes you want at least one item tracked in each list type
	-- even if it's disabled.  Removing full list resets to default on next load.

	local defaultmatrix = {}
	local RESTORE = self.Constants.RESTORE
	local defaults = RoguePowerBars:GetBarsetDefaults()

	local buffs = {}
	local debuffs = {}

	local _, _, classIndex = UnitClass("Player")
	local profile = self.profile

	if clear then
		profile.buffs = {}
		profile.debuffs = {}
		profile.othersDebuffs = {}
	end

	if band(restore, RESTORE.BUFFS) then
		defaultmatrix.buffDefault = {
			defaults = defaults.Buffs,
			destTable = profile.buffs,
			defaultBarset = 1
		}
	end
	if band(restore, RESTORE.DEBUFFS) then
		defaultmatrix.debuffDefault = {
			defaults = defaults.Debuffs,
			destTable = profile.debuffs,
			defaultBarset = 2
		}
	end
	if band(restore, RESTORE.OTHERSDEBUFFS) then
		defaultmatrix.othersDebuffsDefault = {
			defaults = defaults.OthersDebuffs,
			destTable = profile.othersDebuffs,
			defaultBarset = 2
		}
	end

	for k, set in pairs(defaultmatrix) do
		for i = 1, #set.defaults do
			local buff = set.defaults[i]
			local tableKey = self:RemoveSpaces(buff.Name)
			if (not set.destTable[tableKey]) then
				set.destTable[tableKey] = {
					Name = buff.Name,
					Color = {
						r = buff.StatusBarColor.r,
						g = buff.StatusBarColor.g,
						b = buff.StatusBarColor.b,
						a = buff.StatusBarColor.a
					},
					IsEnabled = false,
					Priority = 0,
					Barset = set.defaultBarset
				}
			end
		end
	end
end
