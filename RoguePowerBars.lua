-- Code by Domia (asuah @curse)

----------------------------------------------
-- Libraries
local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local debugf = tekDebug and tekDebug:GetFrame("RoguePowerBars")
local function Debug(...)
	if debugf then
		debugf:AddMessage(string.join(", ", ...))
	end
end

---------------------------------------------
-- Defined constants
local UpdateRate = 0.01
local version = "@project-version@"
local revision = "@project-date-integer@"

local BARTYPE_BUFF = 1

----------------------------------------------
-- Local variables
local BarSets = {} -- associative array
local BarsToRecycle = {} -- normal array
local BarCount = 0
local TimeSinceLastUIUpdate = 0
local inCombat = false --FIXME tag

local debug = false

-- TODO: Remove these, use a more robust defaults listing
RoguePowerBar_Buff_Default = {}
RoguePowerBar_Debuff_Default = {}
RoguePowerBar_OthersDebuffs_Default = {}

--------------------------------------------------------------
-- Event handlers
function RoguePowerBars:OnInitialize()
	self:InitializeDatabase()
	self:SetupOptions()
	self:ImportCustomTextures()
	self:UpdateBuffs()
	self:InitializeBarSets()
	self:RegisterCombatEvents()
end

function RoguePowerBars:Print(...)
	print("RoguePowerBars: " .. string.join(" ", ...))
end

function RoguePowerBars:UpdateSavedData()
	local _, _, num = string.find(self.profile.version, "%s*(%d+)")

	if (num and tonumber(num) < 103) then --change to <= on next buff revision
		self:Print(
			L[
				"Almost all of the spells have changed with patch 4.0.1+  It is highly recommended that you reset each buff type to defaults."
			]
		)
	end
	self.profile.version = revision
end

function RoguePowerBars:RegisterCombatEvents()
	self:RegisterEvent("UNIT_AURA", "OnUnitAura")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnTargetChanged")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEnteringWorld")
	--Test Combat watching
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRegenEnabled")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRegenDisabled")
end

function RoguePowerBars:OnEnable()
end

function RoguePowerBars:OnDisable()
end

function RoguePowerBars:OnUnitAura(eventName, unitID)
	if unitID == "player" or unitID == "target" or unitID == "focus" then
		self:UpdateBuffs()
	end
end

function RoguePowerBars:OnTargetChanged(eventName)
	self:UpdateBuffs()
end

--FIXME Reminder of testing for combat checks
function RoguePowerBars:OnRegenEnabled(eventName)
	inCombat = false
end

function RoguePowerBars:OnRegenDisabled(eventName)
	inCombat = true
end

-- function RoguePowerBars:OnProfileChanged(event, database, newProfileKey)
-- 	self.profile = database.profile
-- 	self:PopulateBuffs();
-- 	self:PopulateDebuffs();
-- 	self:PopuateOthersDebuffs();
-- 	self:PopulateBarsetsSettings();
-- 	LibStub("AceConfigDialog-3.0"):CloseAll();
-- 	self:SetupBarsetPositions();
-- 	self:UpdateBuffs();
-- end

function RoguePowerBars:OnEnteringWorld()
	self:SetupBarsetPositions()
end

--------------------------------------------------------------
-- Buff/debuff update handlers
function RoguePowerBars:UpdateBuffs()
	local currentTime = GetTime()
	local buffs = {}
	local buffIndex, name
	local rank, texture, count, buffType, duration, expirationTime, caster

	local buffmatrix = {
		OnPlayer = {
			source = "OnPlayer",
			target = "player",
			filter = "HELPFUL",
			searchTable = self.profile.buffs
		},
		OnTarget = {
			source = "OnTarget",
			target = "target",
			filter = "HARMFUL|PLAYER",
			searchTable = self.profile.debuffs
		}
	}
	if self.profile.settings.TrackOthersDebuffs then
		buffmatrix.OthersDebuffsOnTarget = {
			source = "OthersDebuffsOnTarget",
			target = "target",
			filter = "HARMFUL",
			searchTable = self.profile.othersDebuffs
		}
	end
	if UnitGUID("focus") and (UnitGUID("target") ~= UnitGUID("focus")) then
		buffmatrix.OnFocus = {
			source = "OnFocus",
			target = "focus",
			filter = "HARMFUL|PLAYER",
			searchTable = self.profile.debuffs
		}
	end
	for k, set in pairs(buffmatrix) do
		name = "dummy"
		buffIndex = 1
		while name do
			name, texture, count, buffType, duration, expirationTime, caster = UnitAura(set.target, buffIndex, set.filter)

			if (set.source == "OthersDebuffsOnTarget" and caster == "player") then
				--prevents a bar from showing up if you're going through the other debuffs
				--list and find one that you've cast.  This prevents two bars at once with
				--the same spell on them.
				--	print("RoguePowerBars: skipped bar (other): "..name);
			else
				if name then
					local buffSettings = set.searchTable[self:RemoveSpaces(name)]
					if buffSettings and buffSettings.IsEnabled then
						table.insert(
							buffs,
							{
								BuffIndex = buffIndex,
								Name = name,
								TimeLeft = expirationTime - currentTime,
								MaxTime = duration,
								Settings = buffSettings,
								Texture = texture,
								Stacks = count,
								ExpirationTime = expirationTime,
								IsOnFocus = UnitIsUnit(set.target, "focus"),
								Caster = caster,
								IsMine = (caster == "player" or caster == "vehicle"),
								IsOn = set.target,
								Source = set.source
							}
						)
					end
				end
			end
			buffIndex = buffIndex + 1
		end
	end
	self:SetStatusBars(buffs)
end

function RoguePowerBars:SetStatusBars(buffs)
	self:ClearAllBars()
	local barset
	local db = self.profile
	for x = 1, #buffs do
		local buff = buffs[x]

		--FIXME TODO
		--This entire section is a bit FUBAR with the nil checking that probably doesn't work.
		--I really need to take care of this.

		if buff.IsOn == "player" then -- my buff, on myself
			barset = BarSets[db.barsets[db.buffs[self:RemoveSpaces(buff.Name)].Barset]]
		elseif buff.IsMine then -- my debuff, on target or focus
			if
				(buff and buff.Name and self:RemoveSpaces(buff.Name) and db.debuffs[self:RemoveSpaces(buff.Name)] and
					db.debuffs[self:RemoveSpaces(buff.Name)].Barset and
					db.barsets[db.debuffs[self:RemoveSpaces(buff.Name)].Barset] and
					BarSets[db.barsets[db.debuffs[self:RemoveSpaces(buff.Name)].Barset]])
			 then --FIXME  --temp fix
				barset = BarSets[db.barsets[db.debuffs[self:RemoveSpaces(buff.Name)].Barset]]
			end
		else -- someone else's debuff, on our target or focus
			-- once got a random nil error here and I have no idea what caused it and have never seen it again
			if
				(buff and buff.Name and self:RemoveSpaces(buff.Name) and db.othersDebuffs[self:RemoveSpaces(buff.Name)] and
					db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset and
					db.barsets[db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset] and
					BarSets[db.barsets[db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset]])
			 then --FIXME  --temp fix
				barset = BarSets[db.barsets[db.othersDebuffs[self:RemoveSpaces(buff.Name)].Barset]]
			else
				--self:RemoveSpaces(nil) --trigger error so i know it occured
				if (buff) then
					-- asks them to report it if they get the same error
					-- this might spam people's default chat box.
					Debug(
						"RoguePowerBars: PM Verik on curse the following: " ..
							tostring(buff.Name) .. " " .. tostring(buff.Source) .. " " .. tostring(buff.IsOn) .. " " .. tostring(buff.Caster)
					)
				else
					Debug("RoguePowerBars: no buff") -- hide this
				end
			end
		end

		if (db.barsetsettings[barset.Info.Name].IsEnabled) then
			local bar = self:CreateBar(buff.Name, barset, buff.ExpirationTime, BARTYPE_BUFF)
			self:ConfigureBar(bar, buff)
			self:UpdateBar(bar, GetTime())
		end
	end

	--[[ old profiling info
12.8 -status
-1.7 create
-4 -config
-6.3 profileC
]]
	for k, barset in pairs(BarSets) do
		local label = _G[barset:GetName() .. "_BarsetText"]
		label:Hide()
		barset:SetScale(db.settings.Scale * db.barsetsettings[barset.Info.Name].Scale)
		barset:SetAlpha(db.settings.Alpha * db.barsetsettings[barset.Info.Name].Alpha)
		if db.settings.Locked then
			if #barset.Info.Bars == 0 then
				barset:SetHeight(db.settings.Height)
				barset:Hide()
			else
				if (db.barsetsettings[barset.Info.Name].IsEnabled) then
					barset:SetHeight(#barset.Info.Bars * db.settings.Height)
					barset:Show()
				end
			end
			barset:SetBackdropColor(0, 0, 0, db.settings.BackgroundAlpha)
			barset:EnableMouse(false)
		else
			if (db.barsetsettings[barset.Info.Name].IsEnabled) then
				barset:Show()
			end
			if #barset.Info.Bars == 0 then
				barset:SetHeight(db.settings.Height)
				-- set visible
				barset:SetBackdrop(
					{
						bgFile = "Interface/Tooltips/UI-Tooltip-Background",
						tile = true
					}
				)
				barset:SetBackdropColor(0, 0, 0, .8)
				label:Show()
				label:SetText(barset.Info.Name)
			else
				barset:SetHeight(#barset.Info.Bars * db.settings.Height)
				barset:SetBackdropColor(0, 0, 0, .8)
			end
			barset:EnableMouse(true)
		end

		--FIXME tagging to remember this is here
		--combat testing reminder
		if (db.settings.HideOOC) then
			if (inCombat and db.barsetsettings[barset.Info.Name].IsEnabled) then
				barset:Show()
			else
				barset:Hide()
			end
		end

		barset:SetWidth(db.barsetsettings[barset.Info.Name].Width)
		table.sort(
			barset.Info.Bars,
			function(a, b)
				return self:Priority(a, b)
			end
		)
		-- positioning follows
		local lastbar
		local growdirection = db.barsetsettings[barset.Info.Name].GrowDirection
		for i, bar in ipairs(barset.Info.Bars) do
			bar:ClearAllPoints()
			if i == 1 then
				if growdirection == 1 then
					bar:SetPoint("BOTTOM", barset, "BOTTOM")
				else
					bar:SetPoint("TOP", barset, "TOP")
				end
			else
				if growdirection == 1 then
					bar:SetPoint("BOTTOM", lastbar, "TOP")
				else
					bar:SetPoint("TOP", lastbar, "BOTTOM")
				end
			end
			lastbar = bar
			bar:SetHeight(db.settings.Height)
			bar:SetWidth(db.barsetsettings[barset.Info.Name].Width)
		end
	end
end

-- function used in sorting bars in a barset.Info.Bars according to priority
-- Since we want items with higher priority to be the more 'constant' part of
-- our bars, we sort from highest->lowest priority.
function RoguePowerBars:Priority(a, b)
	-- local aName = self:RemoveSpaces(a.Info.Name)
	-- local bName = self:RemoveSpaces(b.Info.Name)
	-- return self.profile.buffs[aName].Priority > self.profile.buffs[bName].Priority;
	return a.Info.Priority > b.Info.Priority
end

function RoguePowerBars:ConfigureBar(bar, buff)
	local barname = bar:GetName()
	local statusbar = _G[barname .. "_StatusBar"]
	local db = self.profile
	local settings
	if buff.IsOn == "player" then
		settings = db.buffs[self:RemoveSpaces(buff.Name)]
	elseif buff.IsMine then
		settings = db.debuffs[self:RemoveSpaces(buff.Name)]
	else
		settings = db.othersDebuffs[self:RemoveSpaces(buff.Name)]
	end

	bar.Info.Priority = settings.Priority

	-- local c = db.buffs[self:RemoveSpaces(buff.Name)].Color -- status bar color
	local c = settings.Color
	if buff.ExpirationTime == 0 then
		statusbar:SetMinMaxValues(0, 1)
	else
		statusbar:SetMinMaxValues(0, buff.MaxTime)
	end
	statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a)
	statusbar:SetStatusBarTexture(db.settings["TexturePath"])
	statusbar:GetStatusBarTexture():SetHorizTile(false)
	statusbar:GetStatusBarTexture():SetVertTile(false)

	local bg = _G[barname .. "_BarBackGround"]
	local barbgalpha = db.settings.BarBackgroundAlpha
	bgtable = bg:GetBackdrop()
	bgtable.bgFile = db.settings["TexturePath"]
	bg:SetBackdrop(bgtable)
	bg:SetBackdropColor(c.r, c.g, c.b, barbgalpha)

	local describetext = _G[barname .. "_DescribeText"]
	local description = buff.Name
	if buff.Stacks > 0 then
		description = description .. " (" .. buff.Stacks .. ")"
	end
	if buff.IsOnFocus then
		description = description .. " [" .. L["Focus"] .. "]"
	end
	if not buff.IsMine then
		description = "***" .. description .. "***"
	end
	if db.settings.TextEnabled then
		describetext:Show()
		describetext:SetText(description)
	else
		describetext:Hide()
	end

	if db.settings.DurationTextEnabled then
		_G[barname .. "_DurationText"]:Show()
	else
		_G[barname .. "_DurationText"]:Hide()
	end

	_G[barname .. "_Icon"]:SetTexture(buff.Texture)
	bar:GetParent():Show()
	bar:SetPoint("TOP", bar:GetParent(), "TOP")
	bar:Show()
	bar.Info.BuffInfo = buff
end

local buffsPlugin = {}
local debuffsPlugin = {}
local othersDebuffsPlugin = {}
local barsetsPlugin = {}

function RoguePowerBars:CreateNewBarSet(name)
	local db = self.profile
	name = self:RemoveSpaces(name)
	db.barsets[#db.barsets + 1] = name
	db.barsetsettings[name] = {
		IsEnabled = true,
		Width = 256,
		Scale = 1,
		Alpha = 1,
		GrowDirection = 1,
		position = {
			x = .5,
			y = .5,
			relativeto = "CENTER"
		}
	}
	local barset = self:CreateBarSet(name)
	barset:SetHeight(24)
	self:PopulateBarsetsSettings()
	self:UpdateBuffs()
end

function RoguePowerBars:CreateNewBuff(name)
	local db = self.profile
	if not db.buffs[self:RemoveSpaces(name)] then
		db.buffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1
		}
		self:PopulateBuffs()
	else
		self:Print(L["That buff is already being tracked."])
	end
end

function RoguePowerBars:CreateNewDebuff(name)
	local db = self.profile
	if not db.debuffs[self:RemoveSpaces(name)] then
		db.debuffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1
		}
		self:PopulateDebuffs()
		self:UpdateBuffs()
	else
		self:Print(L["That debuff is already being tracked."])
	end
end

function RoguePowerBars:CreateNewOthersDebuff(name)
	local db = self.profile
	if not db.othersDebuffs[self:RemoveSpaces(name)] then
		db.othersDebuffs[self:RemoveSpaces(name)] = {
			Name = name,
			Color = {
				r = .5,
				g = .5,
				b = .5,
				a = .5
			},
			IsEnabled = true,
			Priority = 0,
			Barset = 1
		}
		self:PopulateOthersDebuffs()
	else
		self:Print(L["That debuff is already being tracked."])
	end
end

function RoguePowerBars:RemoveBarset(name)
	local db = self.profile
	if self:CountInBarset(name) ~= 0 then
		self:Print(
			L[
				"That barset is not empty. Printed above are all the buffs/debuffs that are in that barset. Please change them to another barset."
			]
		)
	else
		local removeIndex = -1
		name = self:RemoveSpaces(name)
		for i = 1, #db.barsets do
			if db.barsets[i] == name then
				--db.barsets[i] = nil;
				table.remove(db.barsets, i) -- stop gaps from forming and causing nil errors with certain usage patterns
				removeIndex = i
				break
			end
		end

		-- shifts spells down an index for bars so they stay associated with the correct bar
		if (removeIndex > -1) then
			for k, v in pairs(db.buffs) do
				if (db.buffs[k].Barset > removeIndex) then
					db.buffs[k].Barset = db.buffs[k].Barset - 1
				end
			end
			for k, v in pairs(db.debuffs) do
				if (db.debuffs[k].Barset > removeIndex) then
					db.debuffs[k].Barset = db.debuffs[k].Barset - 1
				end
			end
			for k, v in pairs(db.othersDebuffs) do
				if (db.othersDebuffs[k].Barset > removeIndex) then
					db.othersDebuffs[k].Barset = db.othersDebuffs[k].Barset - 1
				end
			end
		end

		db.barsetsettings[name] = nil

		local frame = BarSets[name]
		frame:Hide()
		BarSets[name] = nil

		self:PopulateBarsetsSettings()
		self:UpdateBuffs()
		local ACD = LibStub("AceConfigDialog-3.0")
		LibStub("AceConfigRegistry-3.0"):NotifyChange("RoguePowerBars") -- Tell options something changed (hopefully this does what I think it does)
		ACD:CloseAll()
	end
end

function RoguePowerBars:CountInBarset(name)
	local count = 0
	local searchlist = {
		Buffs = self.profile.buffs,
		Debuffs = self.profile.debuffs
	}
	for k1, v1 in pairs(searchlist) do
		for k2, v2 in pairs(v1) do
			if self.profile.barsets[v2.Barset] == name then
				count = count + 1
				self:Print(v2.Name)
			end
		end
	end
	return count
end

function RoguePowerBars:SetupOptions()
	self.optionsFrames = {}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("RoguePowerBars", self:CreateOptions())
	local ACD = LibStub("AceConfigDialog-3.0")
	self:PopulateBuffs()
	self:PopulateDebuffs()
	self:PopulateOthersDebuffs()
	self:PopulateBarsetsSettings()
	self.optionsFrames.RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General")
	self.optionsFrames.Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs")
	self.optionsFrames.Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs")
	self.optionsFrames.OthersDebuffs =
		ACD:AddToBlizOptions("RoguePowerBars", "OthersDebuffs", "RoguePowerBars", "OthersDebuffs")
	self.optionsFrames.Barsets = ACD:AddToBlizOptions("RoguePowerBars", "Barsets", "RoguePowerBars", "Barsets")
	-- self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.profile), "Profiles");
	self:RegisterChatCommand("rpb", "ChatCommand")
end

function RoguePowerBars:PopulateBuffs()
	buffsPlugin.buffs = {}
	local buffs = buffsPlugin.buffs
	local buffList = self:GetBuffList()
	-- for i = 1, #buffList do
	for k, buffSettings in pairs(buffList) do
		-- local buffSettings = v;
		if (buffSettings.Name ~= nil) then
			local buffName = self:RemoveSpaces(buffSettings.Name)
			buffs[buffName] = {
				type = "group",
				name = buffSettings.Name,
				--			order = i,
				get = function(info)
					return self.profile.buffs[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					self.profile.buffs[info[#info - 1]][info[#info]] = value
					self:UpdateBuffs()
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = L["Enabled"],
						desc = L["Enable %s"]:format(tostring(buffSettings.Name))
					},
					Color = {
						type = "color",
						order = 2,
						name = L["Bar Color"],
						hasAlpha = false,
						get = function(info)
							local c = self.profile.buffs[info[#info - 1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = self.profile.buffs[info[#info - 1]].Color
							c.r, c.g, c.b, c.a = r, g, b, a
							self:UpdateBuffs()
						end
					},
					Priority = {
						type = "range",
						order = 3,
						name = L["Priority"],
						min = -10,
						max = 10,
						step = 1,
						isPercent = false
					},
					Barset = {
						type = "select",
						order = 4,
						name = L["Barset"],
						desc = L["The barset this bar will be displayed in"],
						values = self:GetBarSets()
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5
					},
					Remove = {
						order = 6,
						type = "execute",
						name = L["Remove Buff"],
						desc = L["Removes this buff from the listing completely"],
						func = function(info)
							self:RemoveBuffOption(info[#info - 1])
						end
					}
				}
			}
		else
			self:Print(L["%s possibly corrupt in buff list. Attempting to remove."]:format(tostring(k)))
			self.profile.buffs[k] = nil
			self:PopulateBuffs()
		end
	end
end

function RoguePowerBars:RemoveBuffOption(name)
	self.profile.buffs[self:RemoveSpaces(name)] = nil
	self:PopulateBuffs()
	LibStub("AceConfigDialog-3.0"):CloseAll()
end

function RoguePowerBars:GetBarSets()
	return self.profile.barsets
end

function RoguePowerBars:PopulateDebuffs()
	debuffsPlugin.buffs = {}
	local buffs = debuffsPlugin.buffs
	local buffList = self:GetDebuffList()
	-- for i = 1, #buffList do
	for k, buffSettings in pairs(buffList) do
		-- local buffSettings = buffList[i];
		if (buffSettings.Name ~= nil) then
			local buffName = self:RemoveSpaces(buffSettings.Name)
			buffs[buffName] = {
				type = "group",
				name = buffSettings.Name,
				--			order = i,
				get = function(info)
					return self.profile.debuffs[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					self.profile.debuffs[info[#info - 1]][info[#info]] = value
					self:UpdateBuffs()
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = L["Enabled"],
						desc = L["Enable %s"]:format(tostring(buffSettings.Name))
					},
					Color = {
						type = "color",
						order = 2,
						name = L["Bar Color"],
						hasAlpha = false,
						get = function(info)
							local c = self.profile.debuffs[info[#info - 1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = self.profile.debuffs[info[#info - 1]].Color
							c.r, c.g, c.b, c.a = r, g, b, a
							self:UpdateBuffs()
						end
					},
					Priority = {
						type = "range",
						order = 3,
						name = L["Priority"],
						min = -10,
						max = 10,
						step = 1,
						isPercent = false
					},
					Barset = {
						type = "select",
						order = 4,
						name = L["Barset"],
						desc = L["The barset this bar will be displayed in"],
						values = self:GetBarSets()
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5
					},
					Remove = {
						order = 6,
						type = "execute",
						name = L["Remove Debuff"],
						desc = L["Removes this debuff from the listing completely"],
						func = function(info)
							self:RemoveDebuffOption(info[#info - 1])
						end
					}
				}
			}
		else
			self:Print(L["%s possibly corrupt in debuff list. Attempting to remove."]:format(tostring(k)))
			self.profile.debuffs[k] = nil
			self:PopulateDebuffs()
		end
	end
end

function RoguePowerBars:RemoveDebuffOption(name)
	self.profile.debuffs[self:RemoveSpaces(name)] = nil
	self:PopulateDebuffs()
	LibStub("AceConfigDialog-3.0"):CloseAll()
end

function RoguePowerBars:PopulateOthersDebuffs()
	othersDebuffsPlugin.buffs = {}
	local buffs = othersDebuffsPlugin.buffs
	local listing = self:GetOthersDebuffsList()
	-- for i = 1, #listing do
	for k, settings in pairs(listing) do
		-- local settings = listing[i];
		if (settings.Name ~= nil) then
			local name = self:RemoveSpaces(settings.Name)
			buffs[name] = {
				type = "group",
				name = settings.Name,
				--			order = i,
				get = function(info)
					return self.profile.othersDebuffs[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					self.profile.othersDebuffs[info[#info - 1]][info[#info]] = value
					self:UpdateBuffs()
				end,
				args = {
					IsEnabled = {
						type = "toggle",
						order = 1,
						name = L["Enabled"],
						desc = L["Enable %s"]:format(tostring(settings.Name))
					},
					Color = {
						type = "color",
						order = 2,
						name = L["Bar Color"],
						hasAlpha = false,
						get = function(info)
							local c = self.profile.othersDebuffs[info[#info - 1]].Color
							return c.r, c.g, c.b, 1
						end,
						set = function(info, r, g, b, a)
							local c = self.profile.othersDebuffs[info[#info - 1]].Color
							c.r, c.g, c.b, c.a = r, g, b, a
							self:UpdateBuffs()
						end
					},
					Priority = {
						type = "range",
						order = 3,
						name = L["Priority"],
						min = -10,
						max = 10,
						step = 1,
						isPercent = false
					},
					Barset = {
						type = "select",
						order = 4,
						name = L["Barset"],
						desc = L["The barset this bar will be displayed in"],
						values = self:GetBarSets()
					},
					Divider1 = {
						type = "description",
						name = "",
						order = 5
					},
					Remove = {
						order = 6,
						type = "execute",
						name = L["Remove Debuff"],
						desc = L["Removes this debuff from the listing completely"],
						func = function(info)
							self:RemoveOthersDebuffOption(info[#info - 1])
						end
					}
				}
			}
		else
			self:Print(L["%s possibly corrupt in others debuff list. Attempting to remove."]:format(tostring(k)))
			self.profile.othersDebuffs[k] = nil
			self:PopulateOthersDebuffs()
		end
	end
end

function RoguePowerBars:RemoveOthersDebuffOption(name)
	self.profile.othersDebuffs[self:RemoveSpaces(name)] = nil
	self:PopulateOthersDebuffs()
	LibStub("AceConfigDialog-3.0"):CloseAll()
end

function RoguePowerBars:PopulateBarsetsSettings()
	barsetsPlugin.barsets = {}

	local db = self.profile
	local barsets = db.barsets
	local bs = barsetsPlugin.barsets
	for i, v in pairs(barsets) do -- was ipairs
		local barsetSettings = db.barsetsettings[v]
		bs[v] = {
			type = "group",
			name = v,
			order = i,
			get = function(info)
				return db.barsetsettings[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				self:UpdateBuffs()
				db.barsetsettings[info[#info - 1]][info[#info]] = value
			end,
			args = {
				IsEnabled = {
					type = "toggle",
					order = 1,
					name = L["Enabled"],
					desc = L["Enable %s"]:format(tostring(v)),
					set = function(info, value)
						db.barsetsettings[info[#info - 1]][info[#info]] = value
						--self:Print("The " .. info[#info-1].." + ".. info[#info] .. " was set to: " .. tostring(value) )
						--self:Print(L["The %s + %s was set to: %s"]:format(tostring(info[#info-1]),tostring(info[#info]),tostring(value)));
						self:UpdateBuffs()
						if (value) then
							BarSets[info[#info - 1]]:Show()
						else
							BarSets[info[#info - 1]]:Hide()
						end
					end
				},
				Width = {
					type = "range",
					order = 2,
					name = L["Width"],
					min = 100,
					max = 700,
					step = 5
				},
				Scale = {
					type = "range",
					order = 3,
					name = L["Scale"],
					min = .25,
					max = 3,
					step = .01
				},
				Alpha = {
					order = 4,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = .01
				},
				GrowDirection = {
					order = 5,
					type = "select",
					name = L["Grow Direction"],
					values = {L["Up"], L["Down"], L["Both"]},
					set = function(info, value)
						db.barsetsettings[info[#info - 1]][info[#info]] = value
						self:OnBarsetMove(BarSets[info[#info - 1]])
					end
				},
				Divider1 = {
					type = "description",
					name = "",
					order = 6
				},
				Remove = {
					order = 7,
					type = "execute",
					name = L["Remove Barset"],
					func = function(info)
						self:RemoveBarset(info[#info - 1])
					end
				}
			}
		}
		if (v and (v == L["Buffs"] or v == L["Debuffs"])) then
			bs[v]["args"]["Remove"] = nil
		--self:Print("removed");
		end
	end
end

function RoguePowerBars:RemoveSpaces(s)
	return (string.gsub(s, " ", ""))
end

function RoguePowerBars:GetBuffList()
	return self.profile.buffs
end

function RoguePowerBars:GetDebuffList()
	return self.profile.debuffs
end

function RoguePowerBars:GetOthersDebuffsList()
	return self.profile.othersDebuffs
end
-----------------------------------------------------------------
-- Slash command handler
function RoguePowerBars:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars)
	elseif input == L["lock"] then
		self:ToggleLocked()
	elseif input == L["debug"] then
		self:ToggleDebug()
		if (debug) then
			self:Print(L["Debug messages are now on"])
		else
			self:Print(L["Debug messages are now off"])
		end
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", input)
	end
end

function RoguePowerBars:ToggleLocked()
	self.profile.settings.Locked = not self.profile.settings.Locked
	self:UpdateBuffs()
end

function RoguePowerBars:ToggleDebug()
	debug = not debug
end

------------------------------------------------------------------
-- UI Functions

function RoguePowerBars:InitializeBarSets()
	for k, v in pairs(self.profile.barsets) do
		local barset = self:CreateBarSet(v)
		barset:SetHeight("24") -- FIXME
	end
end

function RoguePowerBars:SetupBarsetPositions()
	for k, barset in pairs(BarSets) do
		local settings = self.profile.barsetsettings[barset.Info.Name].position
		local x = settings.x * UIParent:GetWidth()
		local y = settings.y * UIParent:GetHeight()
		barset:SetPoint(settings.relativeto, nil, "bottomleft", x, y)
	end
end

function RoguePowerBars:CreateBarSet(name)
	if not BarSets[name] then
		local frame = CreateFrame("Frame", "RoguePowerBars_BarSet_" .. name, UIParent, "RoguePowerBarSetTemplate")
		frame.Info = {
			Name = name,
			Bars = {}
		}
		BarSets[name] = frame
		frame:SetPoint("CENTER", nil, "CENTER")
		return BarSets[name]
	else
		error(L["Barset %s already exists."]:format(name))
	end
end

function RoguePowerBars:GetBuffBarset() -- debug function
	return BarSets[L["Buffs"]]
end

function RoguePowerBars:AddBarToSet(barFrame, barSet)
	local barSetFrame
	if type(barSet) == "string" then
		barSetFrame = BarSets[barSet]
	elseif type(barSet) == "table" then
		barSetFrame = barSet
	end
	barFrame:SetParent(barSetFrame)
	barSetFrame.Info.Bars[#barSetFrame.Info.Bars + 1] = barFrame
end

function RoguePowerBars:CreateBar(name, parentBarset, expirationTime, bartype)
	-- assumes parentBarset is the parent frame.
	local bar
	local currentTime = GetTime()
	local timeleft

	if #BarsToRecycle > 0 then
		bar = BarsToRecycle[#BarsToRecycle]
		BarsToRecycle[#BarsToRecycle] = nil
	else
		BarCount = BarCount + 1
		bar = CreateFrame("Frame", "RoguePowerBars_Bar_" .. BarCount, parentBarset, "RoguePowerBarTemplate")
	end

	if self.profile.settings.Inverted then
		timeleft = expirationTime - currentTime
	else
	end

	bar.Info = {
		Name = name,
		BarType = bartype
	}
	_G[bar:GetName() .. "_DescribeText"]:SetText(name)
	if bartype == BARTYPE_BUFF then
		bar.Info.Duration = expirationTime - currentTime
		bar.Info.TimeLeft = expirationTime - currentTime
		bar.Info.ExpirationTime = expirationTime
		bar.Info.StartTime = currentTime
		_G[bar:GetName() .. "_StatusBar"]:SetMinMaxValues(0, bar.Info.Duration)
	end
	self:AddBarToSet(bar, parentBarset)
	return bar
end

function RoguePowerBars:UpdateBar(bar, updateTime)
	local info = bar.Info
	local statusbar = _G[bar:GetName() .. "_StatusBar"]
	local durationtext = _G[bar:GetName() .. "_DurationText"]
	if info.BarType == BARTYPE_BUFF then
		info.TimeLeft = info.ExpirationTime - updateTime
		bar:SetAlpha(self:GetFadeAlpha(bar))
		if info.BuffInfo.ExpirationTime == 0 then
			-- no duration buffs, like stealth
			statusbar:SetValue(1)
			durationtext:SetText("")
		elseif info.TimeLeft >= 0 then
			-- duration buffs, but with time left
			if self.profile.settings.Inverted then
				local min, max = statusbar:GetMinMaxValues()
				statusbar:SetValue(max - info.TimeLeft)
			else
				statusbar:SetValue(info.TimeLeft)
			end
			durationtext:SetText(string.format("%.1f", info.TimeLeft))
		else
			-- no time left!
			self:RemoveBar(bar)
		end
	end
end

function RoguePowerBars:GetFadeAlpha(bar)
	local timeleft = bar.Info.TimeLeft
	local value
	if timeleft > 5 or not self.profile.settings.Flash then
		value = 1
	else
		local fadeinterval = 1
		if (timeleft % fadeinterval) > (fadeinterval / 2) then
			value = .2 + (.8 * (2 * (timeleft % (fadeinterval / 2))))
		else
			value = .2 + (.8 * (1 - (2 * (timeleft % (fadeinterval / 2)))))
		end
	end
	return value
end

function RoguePowerBars:RemoveBar(bar)
	bar:Hide()
	self:RemoveBarFromSet(bar)
	BarsToRecycle[#BarsToRecycle + 1] = bar
	--todo: update barset.
end

function RoguePowerBars:RemoveBarFromSet(bar)
	local barSetFrame
	barSetFrame = bar:GetParent()

	self:tremovebyval(barSetFrame.Info.Bars, bar)
end

function RoguePowerBars:tremovebyval(t, value)
	for k, v in ipairs(t) do
		if v == value then
			table.remove(t, k)
			return
		end
	end
	-- if reached here, throw error
	error(L["Value %s not found in table %s"]:format(tostring(value), tostring(t)))
end

function RoguePowerBars:ClearAllBars()
	local notClearedYet
	for i, t in pairs(BarSets) do
		notClearedYet = true
		while notClearedYet do
			for k, v in ipairs(t.Info.Bars) do
				self:RemoveBar(v)
			end
			notClearedYet = false
			for k, v in ipairs(t.Info.Bars) do
				notClearedYet = true
				break
			end
		end
	end
end

--New style accurate timer
--May cause performance issues
function RoguePowerBars:OnUIUpdate(frame, tick)
	-- self,elapsed

	TimeSinceLastUIUpdate = TimeSinceLastUIUpdate + tick

	while (TimeSinceLastUIUpdate > UpdateRate) do
		local updateTime = GetTime()

		for i, v in pairs(frame.Info.Bars) do
			self:UpdateBar(v, updateTime)
		end

		if #frame.Info.Bars == 0 and self.profile.settings.Locked then
			frame:Hide()
		end

		--I Don't really like putting this in an OnUpdate --tagged FIXME
		--Really needed here?
		if (self.profile.settings.HideOOC) then
			if (inCombat and self.profile.barsetsettings[frame.Info.Name].IsEnabled) then
				frame:Show()
			else
				frame:Hide()
			end
		end

		TimeSinceLastUIUpdate = TimeSinceLastUIUpdate - UpdateRate
	end
end

--Old style simiaccurate timer
function RoguePowerBars:OnUIUpdate2(frame, tick)
	TimeSinceLastUIUpdate = TimeSinceLastUIUpdate + tick
	if TimeSinceLastUIUpdate > UpdateRate then
		local updateTime = GetTime()
		for i, v in pairs(frame.Info.Bars) do
			self:UpdateBar(v, updateTime)
		end
		if #frame.Info.Bars == 0 and self.profile.settings.Locked then
			frame:Hide()
		end

		--I Don't really like putting this in an OnUpdate --tagged FIXME
		--Really needed here?
		if (self.profile.settings.HideOOC) then
			if (inCombat and self.profile.barsetsettings[frame.Info.Name].IsEnabled) then
				frame:Show()
			else
				frame:Hide()
			end
		end

		TimeSinceLastUIUpdate = 0
	end
end

function RoguePowerBars:OnBarsetMove(barset)
	local relativeto, x, y
	x = barset:GetLeft()
	barset:ClearAllPoints()
	local growdirection = self.profile.barsetsettings[barset.Info.Name].GrowDirection
	if growdirection == 1 then
		-- grow direction: up, anchor: bottom
		relativeto = "bottomleft"
		y = barset:GetBottom()
	elseif growdirection == 2 then
		-- grow direction: down
		relativeto = "topleft"
		y = barset:GetTop()
	elseif growdirection == 3 then
		-- grow direction: both ways
		relativeto = "left"
		y = barset:GetBottom() + barset:GetHeight() / 2
	else
		error(L["That grow direction should not exist."])
	end
	barset:SetPoint(relativeto, nil, "bottomleft", x, y)
	self.profile.barsetsettings[barset.Info.Name].position = {
		x = (x / UIParent:GetWidth()),
		y = (y / UIParent:GetHeight()),
		relativeto = relativeto
	}
end