local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

RoguePowerBar_OthersDebuffs_Default = {};

local i = 0;

local function GetNext()
	i = i + 1;
	return i;
end

local function ResetIndex()
	i = 0;
end

ResetIndex();

--[[
--===========================
-- Rogues
--===========================
-- Expose Armor
RoguePowerBar_OthersDebuffs_Default[GetNext()] = { 
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.5 },
	SpellID = 26866,
	Name = "Expose Armor", 
};
]]

do
	for i = 1, #RoguePowerBar_OthersDebuffs_Default do
		local buff = RoguePowerBar_OthersDebuffs_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		if(name) then
			buff.Name = name;
		else
			print(L["RoguePowerBars: Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID,buff.Name))
		end
	end
end
