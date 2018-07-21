local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local GROW = RoguePowerBars.Constants.GROW

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
    local db = LibStub("AceDB-3.0"):New("RoguePowerBarsDB", defaults)
	self.db = db
	local profile = self.db.profile
    self.profile = profile

	local firstrun = true

	--checks if spell data is already saved in the database to prevent
	--clearing data from dbs created before the database had version information
	if (profile.buffs and next(profile.buffs)) then
		firstrun = false
	elseif (profile.debuffs and next(profile.debuffs)) then
		firstrun = false
	elseif (profile.othersDebuffs and next(profile.othersDebuffs)) then
		firstrun = false
    end

	--automatically push known spells to database if the current database doesn't
	--have proper version information.
	-- First run people will get a clean database while old dbs will get missing spells added
	if (self.profile.version == nil or self.profile.version == 0 or firstrun) then
		self:BuildDefaults(4, firstrun)
		self.profile.version = revision --update db version
		self:Print(L["This appears to be the first time you have run the addon. Setting up default values."])
	else
		self:UpdateSavedData()
	end
end

function RoguePowerBars:BuildDefaults(restore, clear)
	-- This basically stops it from adding the default buffs if buffs
	-- already exist.  Assumes you want at least one item tracked in each list type
	-- even if it's disabled.  Removing full list resets to default on next load.

	-- restore 	1=buffs
	-- 		2=debuffs
	-- 		3=otherdebuffs
	-- 		4=all

	local defaultmatrix = {}

	local buffs = {}
	local debuffs = {}

	local _, _, classIndex = UnitClass("Player")
	local profile = self.profile

	if (restore == 1 or restore == 4) then
		if (clear) then
			profile.buffs = {}
		end
		defaultmatrix.buffDefault = {
			defaults = buffs,
			destTable = profile.buffs,
			defaultBarset = 1
		}
	end
	if (restore == 2 or restore == 4) then
		if (clear) then
			profile.debuffs = {}
		end
		defaultmatrix.debuffDefault = {
			defaults = debuffs,
			destTable = profile.debuffs,
			defaultBarset = 2
		}
	end
	if (restore == 3 or restore == 4) then
		if (clear) then
			profile.othersDebuffs = {}
		end
		defaultmatrix.othersDebuffsDefault = {
			defaults = RoguePowerBar_OthersDebuffs_Default,
			destTable = profile.othersDebuffs,
			defaultBarset = 2
		}
	end

	for k, set in pairs(defaultmatrix) do
		for i = 1, #set.defaults do
			local buff = set.defaults[i]
			local nameSansSpaces = self:RemoveSpaces(buff.Name)
			if (not set.destTable[nameSansSpaces]) then
				Debug(tostring(buff.Name) .. " added")
				set.destTable[nameSansSpaces] = {
					Name = buff.Name,
					Color = {
						r = buff.StatusBarColor.r,
						g = buff.StatusBarColor.g,
						b = buff.StatusBarColor.b,
						a = buff.StatusBarColor.a
					},
					IsEnabled = true,
					Priority = 0,
					Barset = set.defaultBarset
				}
			end
		end
	end
end
