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

-- Rupture
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 48672,
	Name = "Rupture",
};

-- Wound Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 27188,
	Name = "Wound Poison V",
};

-- Deadly Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 27186,
	Name = "Deadly Poison VII",
};

-- Mind-Numbing Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 5761,
	Name = "Mind-numbing Poison",
};

-- Crippling Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 3408,
	Name = "Crippling Poison",
};

-- Blade Twisting proc
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
	SpellID = 51585,
	Name = "Blade Twisting",
};

-- Expose Armor
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 26866,
	Name = "Expose Armor", 
};

-- Cheap Shot
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 1833,
	Name = "Cheap Shot", 
};

-- Kidney Shot
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 8643,
	Name = "Kidney Shot", 
};

-- Garrote
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 26884,
	Name = "Garrote", 
};

-- Garrote - Silence
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 1330,
	Name = "Garrote - Silence", 
};

-- Gouge
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 1776,
	Name = "Gouge", 
};

-- Blood Elf Racial
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0, g = 0.76, b = 0.89; a = 0.8 },
	SpellID = 25046,
	Name = "Arcane Torrent", 
};

-- Dismantle
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .81, g = .83, b = 0.0, a = 0.8 },
	SpellID = 51722,
	Name = "Dismantle", 
};

-- Blind
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r =.77, g=.74, b=.45; a = 0.8 },
	SpellID = 2094,
	Name = "Blind", 
};

-- Sap
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .13, g = .03, b = .48; a = 0.8 },
	SpellID = 11297,
	Name = "Sap", 
};

-- Improved Kick
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .36, g = .36, b = 0.36; a = 0.8 },
	SpellID = 18425,
	Name = "Silenced - Improved Kick", 
};

do
	for i = 1, #RoguePowerBar_Debuff_Default do
		local buff = RoguePowerBar_Debuff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		buff.Name = name;
	end
end