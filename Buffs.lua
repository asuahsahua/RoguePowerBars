local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

local function BuffCollection(init)
	local self = {
		Defaults = {}
	}

	--[[
		Format for spell is:
		{
			-- Berserking
			StatusBarColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
			SpellID = 26297,
		}
	]]--
	function self.AddDefault(spellID, red, green, blue, alpha)
		local spell = {
			Name = GetSpellInfo(spellID),
			SpellID = spellID,
			StatusBarColor = { r = red, g = green, b = blue, a = alpha }
		};

		if spell.Name == nil then
			print(L["RoguePowerBars"]..": "..L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID,buff.Name))
		end

		table.insert(self.Defaults, spell)
	end

	return self
end

RoguePowerBars.Collections = {
	Buffs = BuffCollection(),
	Debuffs = BuffCollection(),
	OthersDebuffs = BuffCollection()
}