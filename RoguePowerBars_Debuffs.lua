local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

RoguePowerBar_Debuff_Default = {};

local i = 0;

local function GetNext()
	i = i + 1;
	return i;
end

local function ResetIndex()
	i = 0;
end

ResetIndex();

--===========================
-- Class Skills
--===========================

--New Unsorted 5.0
--===============

--Crimson Tempest
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 121411,
	Name = "Crimson Tempest",
};


--Nerve Strike
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 108210,
	Name = "Nerve Strike",
};





--Offensive
--============
--Rupture
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 1943,
	Name = "Rupture",
};
-- Garrote (silence portion in silence section)
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 703,
	Name = "Garrote", 
};
-- Hemorrhage
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 16511,
	Name = "Hemorrhage", 
};

-- Vendetta
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 79140,
	Name = "Vendetta",
};

-- Revealing Strike
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 84617,
	Name = "Revealing Strike",
};

--[[ Waylay
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.8, g = 0.8, b = 0.4; a = 0.8 },
	SpellID = 51693,
	Name = "Waylay", 
};
]]

--Stuns/Daze
--============
-- Cheap Shot
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 1833,
	Name = "Cheap Shot", 
};
-- Kidney Shot
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 408,
	Name = "Kidney Shot", 
};
-- Gouge
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 1776,
	Name = "Gouge", 
};
--[[ Blade Twisting proc
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
	SpellID = 51585,
	Name = "Blade Twisting",
};
]]

-- Blind
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r =.77, g=.74, b=.45; a = 0.8 },
	SpellID = 2094,
	Name = "Blind", 
};

-- Sap
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .13, g = .03, b = .48; a = 0.8 },
	SpellID = 6770,
	Name = "Sap", 
};

--Target armor/weapon mods
--============
-- Expose Armor
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 8647,
	Name = "Expose Armor", 
};
-- Dismantle
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .81, g = .83, b = 0.0, a = 0.8 },
	SpellID = 51722,
	Name = "Dismantle", 
};

--Silence
--============
--[[ Improved Kick
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .36, g = .36, b = 0.36; a = 0.8 },
	SpellID = 18425,
	Name = "Silenced - Improved Kick", 
};
]]

-- Garrote - Silence
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 1330,
	Name = "Garrote - Silence", 
};

--===========================
-- Racials
--===========================
-- Blood Elf Racial
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0, g = 0.76, b = 0.89; a = 0.8 },
	SpellID = 25046,
	Name = "Arcane Torrent", 
};
-- Tauren Racial
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.55, g = 0.3, b = 0.1; a = 0.8 },
	SpellID = 20549,
	Name = "War Stomp", 
};

--===========================
-- Poisons
--===========================
-- Wound Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 8679,
	Name = "Wound Poison",
};

-- Deadly Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 2823,
	Name = "Deadly Poison",
};

-- Mind-Numbing Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 5760,
	Name = "Mind-numbing Poison",
};

-- Crippling Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 3409,
	Name = "Crippling Poison",
};

-- Leeching Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 112961,
	Name = "Leeching Poison",
};

-- Paralytic Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 113952,
	Name = "Paralytic Poison",
};



--===================================================================
--===================================================================
--===================================================================
do
	for i = 1, #RoguePowerBar_Debuff_Default do
		local buff = RoguePowerBar_Debuff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		if(name) then
			buff.Name = name;
		else
			print(L["RoguePowerBars"]..": "..L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID,buff.Name))
		end
	end
end
