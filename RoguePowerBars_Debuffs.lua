

local i = 0;

local function GetNext()
	i = i + 1;
	return i;
end

local function ResetIndex()
	i = 0;
end

ResetIndex();

RoguePowerBar_Debuff_Default = {};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.8, g = 0.2, b = 0.2, a = 0.3 },
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Rupture",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Wound Poison V",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Deadly Poison VII",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Mind-numbing Poison",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				Name = "Crippling Poison",
};


RoguePowerBar_Debuff_Default[GetNext()] = {
				BackDropColor = { r = 0.1, g = 0.47, b = 0.6, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
				Name = "Blade Twisting",
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				Name = "Expose Armor", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.4, g = 0.5, b = 0.9, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Cheap Shot", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.4, g = 0.5, b = 0.9, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Kidney Shot", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.8, g = 0.2, b = 0.2, a = 0.3 },
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Garrote", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.8, g = 0.2, b = 0.2, a = 0.3 },
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				Name = "Garrote - Silence", 
};


RoguePowerBar_Debuff_Default[GetNext()] = { 
				BackDropColor = { r = 0.4, g = 0.5, b = 0.9, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0.5, b = 0.9; a = 0.8 },
				Name = "Gouge", 
};