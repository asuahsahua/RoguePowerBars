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

--Offensive
--============
--Rupture
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 48672,
	Name = "Rupture",
};
-- Garrote (silence portion in silence section)
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 48676,
	Name = "Garrote", 
};
-- Hemorrhage (Rank 5) -- Should work for all ranks
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
	SpellID = 48660,
	Name = "Hemorrhage", 
};


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
	SpellID = 8643,
	Name = "Kidney Shot", 
};
-- Gouge
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
	SpellID = 1776,
	Name = "Gouge", 
};
-- Blade Twisting proc
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
	SpellID = 51585,
	Name = "Blade Twisting",
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

--Target armor/weapon mods
--============
-- Expose Armor
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
	SpellID = 26866,
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
-- Improved Kick
RoguePowerBar_Debuff_Default[GetNext()] = { 
	StatusBarColor = { r = .36, g = .36, b = 0.36; a = 0.8 },
	SpellID = 18425,
	Name = "Silenced - Improved Kick", 
};
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
	SpellID = 27188,
	Name = "Wound Poison V",
};
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 57977,
	Name = "Wound Poison VI",
};
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 57975,
	Name = "Wound Poison VII",
};

-- Deadly Poison
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 27187,
	Name = "Deadly Poison VII",
};
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 57969,
	Name = "Deadly Poison VIII",
};
RoguePowerBar_Debuff_Default[GetNext()] = {
	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
	SpellID = 57970,
	Name = "Deadly Poison IX",
}

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
			print("RoguePowerBars: Warning - SpellID: "..buff.SpellID.." for "..buff.Name.." does not exist.  Using default name instead")
		end
	end
end
