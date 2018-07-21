local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local version = "@project-version@"
local buffsPlugin = {}

local RESTORE = RoguePowerBars.Constants.RESTORE

function RoguePowerBars:CreateOptions()
	-- TODO: plugins isn't a great name for this, but I don't have a better one right now.
	--       its what goes into the plugins field for these config options
	self.plugins = {
		buffs = {},
		debuffs = {},
		othersDebuffs = {}
	}

	return {
		name = "RoguePowerBars",
		handler = self,
		type = "group",
		args = {
			config = {
				name = "config",
				type = "execute",
				desc = L["Opens the configuration window."],
				func = function()
					self:OpenConfig()
				end
			},
			General = {
				order = 1,
				type = "group",
				name = L["General"],
				desc = L["General Settings"],
				get = function(info)
					return self.profile.settings[info[#info]]
				end,
				set = function(info, value)
					self.profile.settings[info[#info]] = value
					self:UpdateBuffs()
				end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Version %s - Updated by Domia on Maiev-US (Curse profile: Asuah) Maintained by Verik (Garona-US)"]:format(
							version
						)
					},
					Locked = {
						order = 2,
						type = "toggle",
						name = L["Locked"],
						desc = L["Lock/unlock the bars"]
					},
					HideOOC = {
						order = 3,
						type = "toggle",
						name = L["Hide out of combat"],
						desc = L["Hide/Show the bars when not in combat"]
					},
					Inverted = {
						order = 3,
						type = "toggle",
						name = L["Inverted bars"],
						desc = L["Invert the bars"]
					},
					Flash = {
						order = 4,
						type = "toggle",
						name = L["Flash low bars"],
						desc = L["Flash bars with less than 5 seconds left"]
					},
					TextEnabled = {
						order = 5,
						type = "toggle",
						name = L["Text Enabled"],
						desc = L["Enable text on the bars"]
					},
					DurationTextEnabled = {
						order = 6,
						type = "toggle",
						name = L["Duration Text Enabled"],
						desc = L["Enable duration information on the bars"]
					},
					TrackOthersDebuffs = {
						order = 7,
						type = "toggle",
						name = L["Track Other's Debuffs"],
						desc = L["Enable tracking of other players' debuffs"]
					},
					Divider1 = {
						order = 8,
						type = "description",
						name = ""
					},
					Scale = {
						order = 9,
						type = "range",
						name = L["Scale"],
						min = .25,
						max = 3,
						step = .01
					},
					Alpha = {
						order = 10,
						type = "range",
						name = L["Alpha"],
						min = 0,
						max = 1,
						step = .01
					},
					BarBackgroundAlpha = {
						order = 11,
						type = "range",
						name = L["Bar Background Alpha"],
						min = 0,
						max = .5,
						step = .01
					},
					BackgroundAlpha = {
						order = 12,
						type = "range",
						name = L["Background Alpha"],
						min = 0,
						max = 1,
						step = .01
					},
					Divider2 = {
						order = 13,
						type = "description",
						name = ""
					},
					Texture = {
						order = 14,
						type = "select",
						dialogControl = "LSM30_Statusbar",
						name = L["Texture"],
						desc = L["The texture that will be used"],
						values = AceGUIWidgetLSMlists.statusbar,
						set = function(info, value)
							self.profile.settings[info[#info]] = value
							self.profile.settings["TexturePath"] = SharedMedia:Fetch("statusbar", value)
							self:UpdateBuffs()
						end
					}
				}
			},
			Buffs = {
				type = "group",
				name = L["Buffs"],
				desc = L["Buff Settings"],
				plugins = self.plugins.buffs,
				args = {
					AddBarInput = {
						order = 0,
						type = "input",
						name = L["Add buff:"],
						desc = L["Input a buff name here to be tracked:"],
						set = function(info, value)
							self:CreateNewBuff(value)
						end
					},
					Divider = {
						type = "description",
						name = "",
						order = 1,
						width = "half" -- hacky
					},
					RestoreDefaultBuffs = {
						order = 2,
						type = "execute",
						name = L["Reset to default buffs"],
						desc = L["Restore buff list to default values"],
						func = function()
							self:BuildDefaults(RESTORE.BUFFS, true)
							self:PopulateBuffs()
						end
					}
				}
			},
			Debuffs = {
				type = "group",
				name = L["Debuffs"],
				desc = L["Debuff Settings"],
				plugins = self.plugins.debuffs,
				args = {
					AddBarInput = {
						order = 0,
						type = "input",
						name = L["Add debuff:"],
						desc = L["Input a debuff name here to be tracked:"],
						set = function(info, value)
							self:CreateNewDebuff(value)
						end
					},
					Divider = {
						type = "description",
						name = "",
						order = 1,
						width = "half" -- hacky
					},
					RestoreDefaultDebuffs = {
						order = 2,
						type = "execute",
						name = L["Reset to default debuffs"],
						desc = L["Restore debuff list to default values"],
						func = function()
							self:BuildDefaults(RESTORE.DEBUFFS, true)
							self:PopulateDebuffs()
						end
					}
				}
			},
			OthersDebuffs = {
				type = "group",
				name = L["Others' Debuffs"],
				desc = L["Other players' debuffs"],
				plugins = self.plugins.othersDebuffs,
				args = {
					AddBarInput = {
						order = 0,
						type = "input",
						name = L["Add debuff:"],
						desc = L["Input a debuff name here to be tracked:"],
						set = function(info, value)
							self:CreateNewOthersDebuff(value)
						end
					},
					Divider = {
						type = "description",
						name = "",
						order = 1,
						width = "half" -- hacky
					},
					RestoreDefaultOthersDebuffs = {
						order = 2,
						type = "execute",
						name = L["Reset to defaults"], -- button isn't long enough for better description
						desc = L["Restore other's debuffs list to default values"],
						func = function()
							self:BuildDefaults(RESTORE.OTHERSDEBUFFS, true)
							self:PopulateOthersDebuffs()
						end
					}
				}
			},
			Barsets = {
				type = "group",
				name = L["Barsets"],
				desc = L["Barset Settings"],
				args = {
					AddBarInput = {
						order = 0,
						type = "input",
						name = L["Create barset:"],
						desc = L["Input a name here to create a new barset"],
						set = function(info, value)
							self:CreateNewBarSet(value)
						end
					}
				}
			}
		}
	}
end