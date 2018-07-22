local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")
local RESTORE = RoguePowerBars.Constants.RESTORE

function RoguePowerBars:SetupOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("RoguePowerBars", self:CreateOptions())
	local ACD = LibStub("AceConfigDialog-3.0")
	self:PopulateBuffs()
	self:PopulateDebuffs()
	self:PopulateOthersDebuffs()
    self:PopulateBarsetsSettings()

	self.optionsFrames = {
        RoguePowerBars = ACD:AddToBlizOptions("RoguePowerBars", nil, nil, "General"),
        Buffs = ACD:AddToBlizOptions("RoguePowerBars", "Buffs", "RoguePowerBars", "Buffs"),
        Debuffs = ACD:AddToBlizOptions("RoguePowerBars", "Debuffs", "RoguePowerBars", "Debuffs"),
        OthersDebuffs = ACD:AddToBlizOptions("RoguePowerBars", "OthersDebuffs", "RoguePowerBars", "OthersDebuffs"),
        Barsets = ACD:AddToBlizOptions("RoguePowerBars", "Barsets", "RoguePowerBars", "Barsets")
    }
	InterfaceAddOnsList_Update()

    -- self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.profile), "Profiles");

    self:RegisterChatCommand("rpb", "ChatCommand")
    -- TODO: Check if this has already been declared
	self:RegisterChatCommand("rl", ReloadUI)
end

function RoguePowerBars:ChatCommand(input)
    input = input:trim()
    -- TODO: This should really all be behind AceConfigCmd
	if not input or input == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.RoguePowerBars)
    elseif input == "reset" or input == L["reset"] then
        -- FIXME: This doesn't update the config listing when reset for some reason
        self:BuildDefaults(RESTORE.ALL, true)
        self:PopulateBuffs()
	elseif input == "buff" or input == L["buff"] or input == "buffs" or input == L["buffs"] then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Buffs)
	elseif input == "debuff" or input == L["debuff"] or input == "debuffs" or input == L["debuffs"] then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Debuffs)
	elseif input == "help" then
		self:PrintUsage()
	elseif input == "lock" or input == L["lock"] then
		self:ToggleLocked()
	elseif input == "debug" or input == L["debug"] then
		self:ToggleDebug()
		if (debug) then
			self:Print(L["Debug messages are now on"])
		else
			self:Print(L["Debug messages are now off"])
		end
	else
		AceConfigCmd.HandleCommand(RoguePowerBars, "rpb", "RoguePowerBars", input)
	end
end

function RoguePowerBars:PrintUsage()
	self:Print("TODO: Add usage statements")
end

function RoguePowerBars:ToggleLocked()
	self.profile.settings.Locked = not self.profile.settings.Locked
	self:UpdateBuffs()
end

function RoguePowerBars:ToggleDebug()
	debug = not debug
end