

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


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Rupture",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Wound Poison V",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Deadly Poison VII",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Mind-numbing Poison",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Crippling Poison",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
				Name = "Blade Twisting",
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				Name = "Expose Armor", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Cheap Shot", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Kidney Shot", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Garrote", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Garrote - Silence", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Gouge", 
};

-- TODO: Fix all colors below this line

RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = 0, g = 0.76, b = 0.89; a = 0.8 },
				Name = "Arcane Torrent", 
};

RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = .81, g = .83, b = 0.0, a = 0.8 },
				Name = "Dismantle", 
};

RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r=.77, g=.74, b=.45; a = 0.8 },
				Name = "Blind", 
};

RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = .13, g = .03, b = .48; a = 0.8 },
				Name = "Sap", 
};

RoguePowerBar_Debuff_Default[GetNext()] = { 
				StatusBarColor = { r = .36, g = .36, b = 0.36; a = 0.8 },
				Name = "Silenced - Improved Kick", 
};