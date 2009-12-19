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


--===========================
-- Class Skills
--===========================

--Offensive
--============

-- Slice and Dice
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 6774,
	Name = "Slice and Dice",
};

-- Envenom Buff
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0; g = 0.8; b = 0; a = 0.8 },
	SpellID = 57992,
	Name = "Envenom",
};

--Defensive
--============

-- Cloak of Shadows
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
	SpellID = 31224,
	Name = "Cloak of Shadows",
};

-- Sprint
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 11305,
	Name = "Sprint",
};

-- Evasion
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.5, b = 1; a = 0.8 },
	SpellID = 26669,
	Name = "Evasion",
};

-- Vanish
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = .5, g = .5, b = .5, a = .8 },
	SpellID = 26889,
	Name = "Vanish",
}

--===========================
-- Combat Talents
--===========================

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

-- Killing Spree
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 51690,
	Name = "Killing Spree",
};

--===========================
-- Assassination Talents
--===========================

-- Hunger For Blood
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9; g = 0.2; b = 0; a = 0.8 },
	SpellID = 51662,
	Name = "Hunger For Blood",
};

-- Remorseless Attacks
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0, g = 0.5, b = 0.5; a = 0.8 },
	SpellID = 14149,
	Name = "Remorseless", 
};

-- Ghostly Strike
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
	SpellID = 14278,
	Name = "Ghostly Strike",
};

-- Turn the Tables
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 52914,
	Name = "Turn the Tables",
};

-- Overkill
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 58426,
	Name = "Overkill",
};




--===========================
-- Subtlety Talents
--===========================

-- Shadow dance
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
	SpellID = 51713,
	Name = "Shadow Dance", 
};

-- Shadowstep
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.6, g = 0, b = 0.7; a = 0.8 },
	SpellID = 36554,
	Name = "Shadowstep", 
};




--===========================
-- Gear Procs
--===========================

-- T9 (2 piece bonus)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.4, b = 0.6; a = 0.8 },
	SpellID = 67210,
	Name = "Clearcasting", 
};

--===========================
-- Epic Trinkets
--===========================

--3.0
--============
-- Mirror of Truth
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 60065,
	Name = "Reflection of Torment",
}
-- Fury of the Five Flights (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.6, g = 0, b = 0.4, a = 0.8 },
	SpellID = 60314,
	Name = "Fury of the Five Flights",
}
-- Grim Toll
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.85, b = 0.15, a = 0.8 },
	SpellID = 60437,
	Name = "Grim Toll",
}
-- Darkmoon Card: Greatness (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.25, g = 0.18, b = 0.4, a = 0.8 },
	SpellID = 60233,
	Name = "Darkmoon Card: Greatness",
}

--3.1
--============
-- Wrathstone (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.75, b = 0.2, a = 0.8 },
	SpellID = 64800,
	Name = "Wrathstone",
}
-- Blood of the Old God (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.78, g = 0, b = 0, a = 0.8 },
	SpellID = 64790,
	Name = "Blood of the Old God",
}
-- Mjolnir Runestone (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0.4, b = 0.2, a = 0.8 },
	SpellID = 65019,
	Name = "Mjolnir Runestone",
}
-- Pyrite Infusion (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.6, b = 0.2, a = 0.8 },
	SpellID = 65014,
	Name = "Pyrite Infusion",
}
-- Dark Matter (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.6, g = 0.15, b = 0.05, a = 0.8 },
	SpellID = 65024,
	Name = "Implosion",
}
-- Comet's Trail (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.25, g = 0.25, b = 0.5, a = 0.8 },
	SpellID = 64772,
	Name = "Comet's Trail",
}

--3.2
--============
-- Banner of Victory (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.2, b = 0, a = 0.8 },
	SpellID = 67671,
	Name = "Fury",
}

-- Mark of Supremacy
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.2, b = 0, a = 0.8 },
	SpellID = 67695,
	Name = "Rage",
}

-- Shard of the Crystal Heart
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.2, b = 0, a = 0.8 },
	SpellID = 67683,
	Name = "Celerity",
}


-- Death's Verdict/Choice Normal Mode and probably heroic (Paragon[agi]) (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.2, g = 0.3, b = 0.45, a = 0.8 },
	SpellID = 67703,
	Name = "Paragon",
}

-- Victor's Call/Vengeance of the Forsaken Normal Mode and probably heroic (needs testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 67737,
	Name = "Risen Fury",
}


--3.3
--============
-- Needle-Encrusted Scorpion (needs testing) 
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71403,
	Name = "Fatal Flaws",
}

-- Whispering Fanged Skull (needs testing) 
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.1, g = 0.2, b = 0.9, a = 0.8 },
	SpellID = 71401,
	Name = "Icy Rage",
}


-- Deathbringer's Will (needs testing) --prob needs tracking of random buff instead as it doesn't seem to have a duration?
--[[
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71519,
	Name = "Deathbringer's Will", --temp name
}
]]
-- These are probably the different 'forms' of Deathbringer's Will's random buffs
-- Normal mode ids only.  Should work for heroic as long as ability names match
-- I may have the wrong spellIds on these
-- (all need testing)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71485,
	Name = "Agility of the Vrykul",
}
--
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71492,
	Name = "Speed of the Vrykul",
}
--
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71486,
	Name = "Power of the Taunka",
}
--
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71484,
	Name = "Strength of the Taunka",
}
--
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71491,
	Name = "Aim of the Iron Dwarves",
}
--
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71487,
	Name = "Precision of the Iron Dwarves",
}

-- Herkuml War Token
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71396,
	Name = "Rage of the Fallen",
}



--===========================
-- Weapon Effects
--===========================

--Heartpierce
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 71882,
	Name = "Invigoration",
}

--===========================
-- Weapon Enchants
--===========================

-- Berserking Enchant
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.8, g = 0.2, b = 0.2; a = 0.8 },
	SpellID = 59620,
	Name = "Berserk", 
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




--===========================
-- Potions
--===========================

-- Potion of Speed
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.6, b = 0.2; a = 0.8 },
	SpellID = 53908,
	Name = "Speed", 
};



--===========================
-- Short Term Buffs
--===========================

-- Battle Shout
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 47436,
	Name = "Battle Shout", 
};

-- Heroism
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 32182,
	Name = "Heroism", 
};

-- Bloodlust
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 2825,
	Name = "Bloodlust", 
};



--===========================
-- Racials
--===========================

-- Orc racial
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 20572,
	Name = "Blood Fury", 
};

-- Troll racial
RoguePowerBar_Buff_Default[GetNext()] = { 
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 26297,
	Name = "Berserking", 
};


--===========================
-- OLD CONTENT BUFFS - DISABLED
--===========================
-- Copy and paste here to restore any removed buffs

----------------------------------------------------------
--[[
-- Haste Potion
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.9, b = 0; a = 0.8 },
	SpellID = 28507,
	Name = "Haste", 
};

-- The following are all Darkmoon Card: Madness procs.
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.0, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 41002,
	Name = "Paranoia", 
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


]]



do
	for i = 1, #RoguePowerBar_Buff_Default do
		local buff = RoguePowerBar_Buff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		if(name) then
			buff.Name = name;
		else
			print("RoguePowerBars: Warning - SpellID: "..buff.SpellID.." for "..buff.Name.." does not exist.  Using default name instead.")
		end
	end
end
