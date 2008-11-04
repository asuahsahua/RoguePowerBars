RoguePowerBar_Buff_Default = {};

local i = 0;

local function GetNext()
	i = i + 1;
	return i;
end

local function ResetIndex()
	i = 0;
end

ResetIndex();

-- Slice and Dice
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 6774,
	Name = "Slice and Dice",
};

-- Sprint
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 11305,
	Name = "Sprint",
};

-- Cloak of Shadows
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
	SpellID = 31224,
	Name = "Cloak of Shadows",
};

-- Blade Flurry
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
	SpellID = 13877,
	Name = "Blade Flurry",
};

-- Adrenaline Rush
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0.5, b = 0.8; a = 0.8 },
	SpellID = 13750,
	Name = "Adrenaline Rush",
};

-- Evasion
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.5, b = 1; a = 0.8 },
	SpellID = 26669,
	Name = "Evasion",
};

-- Ghostly Strike
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
	SpellID = 14278,
	Name = "Ghostly Strike",
};

-- Hunger For Blood
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9; g = 0.2; b = 0; a = 0.8 },
	SpellID = 51662,
	Name = "Hunger For Blood",
}; 

-- Shadowstep
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.6, g = 0, b = 0.7; a = 0.8 },
	SpellID = 36554,
	Name = "Shadowstep", 
};  

-- Remorseless Attacks
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0, g = 0.5, b = 0.5; a = 0.8 },
	SpellID = 14149,
	Name = "Remorseless", 
};

-- Mongoose Enchant
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 28093,
	Name = "Lightning Speed", 
};

-- Executioner enchant
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
	SpellID = 42976,
	Name = "Executioner", 
};

-- Crusader enchant
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.5, g = 0.5, b = 1; a = 0.8 },
	SpellID = 20007,
	Name = "Holy Strength",
};

-- Haste Potion
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.9, b = 0; a = 0.8 },
	SpellID = 28507,
	Name = "Haste", 
};

-------------------------------------------------------------
-- The following are all Darkmoon Card: Madness procs.
--[[
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.0, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 41002,
	Name = "Paranoia", 
};

RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.6, g = 0.6, b = 1; a = 0.8 },
	SpellID = 40997,
	Name = "Delusional", 
};

RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.2, g = 0.1, b = 0.9; a = 0.8 },
	SpellID = 41011,
	Name = "Martyr Complex", 
};

RoguePowerBar_Buff_Default[GetNext()] = { 				 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 41005,
	Name = "Manic", 
};

RoguePowerBar_Buff_Default[GetNext()] = { 				 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 40998,
	Name = "Kleptomania", 
};

]]

-- Troll racial
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 20554,
	Name = "Berserking", 
};

-- Buff for Bladefist's Breadth and Ancient Draenei War Talisman
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 33667,
	Name = "Ferocity", 
};

-- Core of Ar'kelos
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 35733,
	Name = "Ancient Power", 
};

-- Battle Shout
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 47436,
	Name = "Battle Shout", 
};

-- Rogue T5 proc
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
	SpellID = 37171,
	Name = "Coup de Grace",
};

-- Ashtongue Talisman of Lethality
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 40461,
	Name = "Exploit Weakness",
};

-- Tsunami Talisman
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 42084,
	Name = "Fury of the Crashing Waves",
};

-- Elixir of Demonslaying
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 11406,
	Name = "Elixir of Demonslaying",
};

-- Warp-Spring Coil
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
	SpellID = 37174,
	Name = "Perceived Weakness",
};

-- Madness of the Betrayer
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
	SpellID = 40477,
	Name = "Forceful Strike",
};

RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 35476,
	Name = "Drums of Battle",
};

RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 35475,
	Name = "Drums of War",
};

RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 41434,
	Name = "The Twin Blades of Azzinoth",
};

-- Buff for Battlemaster's trinkets
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.0, b = 0.0; a = 0.8 },
	SpellID = 44055,
	Name = "Tremendous Fortitude",
};    

-- Buff for Dragonspine Trophy
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.5; g = 0.5; b = 1; a = 0.8 },
	SpellID = 34775,
	Name = "Dragonspine Flurry",
};

-- Buff for Blackened Naaru Sliver
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.28, g = 0.25, b = 0.29; a = 0.8 },
	SpellID = 45040,
	Name = "Battle Trance", 
};

-- Buff for Shard of Contempt
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.48, g = 0.09, b = 0.09, a = 0.8 },
	SpellID = 45053,
	Name = "Disdain", 
};

-- Shadow dance
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
	SpellID = 51713,
	Name = "Shadow Dance", 
};

-- Light's strength (Aldor SSO pendant)
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 45480,
	Name = "Light's Strength", 
};

-- Bloodlust
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.78, g = 0.15, b = .15, a = 0.8 },
	SpellID = 2825,
	Name = "Bloodlust",
}

-- Bloodlust Brooch
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.78, g = 0.15, b = .15, a = 0.8 },
	SpellID = 35166,
	Name = "Lust for Battle",
}

do
	for i = 1, #RoguePowerBar_Buff_Default do
		local buff = RoguePowerBar_Buff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		buff.Name = name;
	end
end