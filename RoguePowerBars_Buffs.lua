local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

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
	SpellID = 5171,
	Name = "Slice and Dice",
};

-- Envenom Buff
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0; g = 0.8; b = 0; a = 0.8 },
	SpellID = 32645,
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

-- Recuperate
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
	SpellID = 73651,
	Name = "Recuperate",
};

-- Sprint
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
	SpellID = 2983,
	Name = "Sprint",
};

-- Evasion
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.5, b = 1; a = 0.8 },
	SpellID = 5277,
	Name = "Evasion",
};

-- Vanish
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = .5, g = .5, b = .5, a = .8 },
	SpellID = 1856,
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


-- Bandit's Guile spells
-- Shallow Insight
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0, g = 0.9, b = 0; a = 0.8 },
	SpellID = 84745,
	Name = "Shallow Insight",
};
-- Moderate Insight
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.9, b = 0.3; a = 0.8 },
	SpellID = 84746,
	Name = "Moderate Insight",
};
-- Deep Insight
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.1, b = 0.1; a = 0.8 },
	SpellID = 84747,
	Name = "Deep Insight",
};



--===========================
-- Assassination Talents
--===========================

-- Deadly Momentum
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
	SpellID = 84590,
	Name = "Deadly Momentum",
};

-- Overkill
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 58426,
	Name = "Overkill",
};


-- Combat Readiness
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 74001,
	Name = "Combat Readiness",
};

-- Combat Insight ( from Combat Readiness)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1.0, g = 1.0, b = 0.4; a = 0.8 },
	SpellID = 74002,
	Name = "Combat Insight",
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
	SpellID = 36563,
	Name = "Shadowstep", 
};

--===========================
-- Gear Procs
--===========================

--4.0 Cataclysm
--============
-- T11 (4 piece bonus)
--Deadly Scheme (4T11)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 90472,
	Name = "Deadly Scheme",
}
--4.2
--
-- T12 (4 piece bonus)
--Master of Flames [Mastery] (4T12)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 99188,
	Name = "Master of Flames",
}
--Future on Fire [Haste] (4T12)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 99186,
	Name = "Future on Fire",
}
--Fiery Devastation [Crit] (4T12)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 99187,
	Name = "Fiery Devastation",
}
--4.3
--Legendary Questline Daggers
--Suffering
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 109959,
	Name = "Suffering",
}
--Nightmare (5 AGI)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 109955,
	Name = "Nightmare",
}
--Shadows of the Destroyer (17 AGI+Fury proc)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 109941,
	Name = "Shadows of the Destroyer",
}
--Fury of the Destroyer
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 109949,
	Name = "Fury of the Destroyer",
}

--[[
--3.0 WOTLK
-- T9 (2 piece bonus)
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.4, b = 0.6; a = 0.8 },
	SpellID = 67210,
	Name = "Clearcasting", 
};

--Ashen Band of X Vengeance
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.85, g = 0.35, b = 0.2; a = 0.8 },
	SpellID = 72412,
	Name = "Frostforged Champion",
}

--Swordguard Embroidery
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.85, g = 0.35, b = 0.2; a = 0.8 },
	SpellID = 55775,
	Name = "Swordguard Embroidery",
}
]]
--===========================
-- Epic Trinkets
--===========================



--4.0 Cataclysm
--============

--Unsolvable Riddle
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 92123,
	Name = "Enigma",
}
--Essence of the Cyclone
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 92126,
	Name = "Twisted",
}
--Unheeded Warning
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 92108,
	Name = "Heedless Carnage",
}
--Prestor's Talisman of Machination
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 92349,
	Name = "Nefarious Plot",
}
--Fluid Death
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.1, g = 0.1, b = 0.6, a = 0.8 },
	SpellID = 92104,
	Name = "River of Death",
}

--4.2
--===========
--Ancient Petrified Seed
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 97177,
	Name = "Ancient Petrified Seed",
}
--Hungerer
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 97125,
	Name = "Devour",
}
--Matrix Restabilizer ??? Don't know if this will catch all types.
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 96976,
	Name = "Matrix Restabilizer",
}

--Call of Conquest
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.4, g = 0.2, b = 0.4, a = 0.8 },
	SpellID = 99739,
	Name = "Call of Conquest",
}

--Aella's Bottle
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 101515,
	Name = "Charged Blows",
}
--4.3
--===========
--Starcatcher Compass
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 107982,
	Name = "Velocity",
}
--Wrath of Unchaining
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 107960,
	Name = "Combat Trance",
}
--Arrow of Time
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.87, g = 0.5, b = 0.13, a = 0.8 },
	SpellID = 102659,
	Name = "Arrow of Time",
}
--Kiroptyric Sigil
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.1, g = 0.8, b = 0.1, a = 0.8 },
	SpellID = 107947,
	Name = "Agile",
}


--3.0 WOTLK

--3.0
--============
--[[
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

-- Whispering Fanged Skull
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.1, g = 0.2, b = 0.9, a = 0.8 },
	SpellID = 71401,
	Name = "Icy Rage",
}


-- These are probably the different 'forms' of Deathbringer's Will's random buffs
-- Normal mode ids only.  Should work for heroic as long as ability names match
-- I may have the wrong spellIds on these
-- (all need testing)
-- Agi
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71485,
	Name = "Agility of the Vrykul",
}
-- Haste
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71492,
	Name = "Speed of the Vrykul",
}
--Ap
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71486,
	Name = "Power of the Taunka",
}
-- Herkuml War Token
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.35, b = 0.1, a = 0.8 },
	SpellID = 71396,
	Name = "Rage of the Fallen",
}

--3.3.5
--============
-- Piercing Twilight (needs testing) 
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.3, g = 0.1, b = 0.6; a = 0.8 },
	SpellID = 75458,
	Name = "Piercing Twilight",
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

--Black Bruise
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.25, g = 0.25, b = 0.5, a = 0.8 },
	SpellID = 71875,
	Name = "Necrotic Touch",
}
]]

--===========================
-- Weapon Enchants
--===========================

-- Landslide Enchant
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 74245,
	Name = "Landslide", 
};

-- Hurricane Enchant
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.35, g = 0.6, b = 0.85; a = 0.8 },
	SpellID = 74221,
	Name = "Hurricane", 
};

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

-- Potion of Speed
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0.1, g = 1, b = 0.1; a = 0.8 },
	SpellID = 79633,
	Name = "Tol'vir Agility", 
};



--===========================
-- Short Term Buffs
--===========================

-- Battle Shout
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
	SpellID = 6673,
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

-- Time Warp
RoguePowerBar_Buff_Default[GetNext()] = {
	StatusBarColor = { r = 0, g = 0, b = 0.8; a = 0.8 },
	SpellID = 80353,
	Name = "Time Warp", 
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

--PASTE GROUPS TO DISABLE HERE

]]



do
	for i = 1, #RoguePowerBar_Buff_Default do
		local buff = RoguePowerBar_Buff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		if(name) then
			buff.Name = name;
		else
			print(L["RoguePowerBars"]..": "..L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID,buff.Name))
		end
	end
end
