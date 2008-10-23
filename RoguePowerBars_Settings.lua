ADDON_NAME = "Rogue Power Bars";
ADDON_VERSION = "2.00";

SLASH_ROGUEPOWERBAR1 = "/rpb";
SLASH_ROGUEPOWERBAR2 = "/roguepowerbar";

ROGUEPOWERBAR_VARIABLES_LOADED  = false;

ROGUEPOWERBAR_PROFILE = "";

STATUSBAR_SPACE = 0;
STATUSBAR_HEIGHT = 20;

ROGUEPOWERBAR_NAME = "RoguePowerBars";

MIN_TIMELEFT = 0;
MAX_TIMELEFT = 1;
MAXTIME = 2;
OWNORDER = 3;
NAME = 4;

TYPE_BUFF = 0;
TYPE_DEBUFF = 1;

BANTO_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureBanto.tga";
BLIZZARD_TEXTURE = "Interface\\TargetingFrame\\UI-StatusBar";
LITESTEP_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureLiteStep.tga";
OTRAVI_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BarTextureCanvas.tga";
SMOOTH_TEXTURE = "Interface\\AddOns\\RoguePowerBars\\BatTextureSmooth.tga";

RoguePowerBarsOptions = {};

RoguePowerBarsOptions.sort = MIN_TIMELEFT;
RoguePowerBarsOptions.invert = false;
RoguePowerBarsOptions.locked = false;
RoguePowerBarsOptions.scale = 1;
RoguePowerBarsOptions.showtext = true;
RoguePowerBarsOptions.fade = true;
RoguePowerBarsOptions.durationText = true;
RoguePowerBarsOptions.alpha = 1;
RoguePowerBarsOptions.point = "CENTER";
RoguePowerBarsOptions.x = 0;
RoguePowerBarsOptions.y = 80;
RoguePowerBarsOptions.barTexture = SMOOTH_TEXTURE;

STATUSBAR_COUNTER = 0;
function GetNext()
	STATUSBAR_COUNTER = STATUSBAR_COUNTER + 1;
	return STATUSBAR_COUNTER;
end




-- Number of Status Bars that should be displayed in the config section on each row
MAX_NO_ON_FIRST_ROW = 10;


RoguePowerBar_EventHandler = {};


RoguePowerBar_EventHandler["CHAT_MSG_SPELL_AURA_GONE_SELF"] = function()

	RoguePowerBar_OnChatMsgSpellAuraGoneSelf(arg1);

end


RoguePowerBar_EventHandler["PLAYER_AURAS_CHANGED"] = function()

	RoguePowerBar_OnAuraChanged();

end

RoguePowerBar_EventHandler["UNIT_AURA"] = function()
	
	RoguePowerBar_OnUnitAura(arg1);

end

RoguePowerBar_EventHandler["PLAYER_TARGET_CHANGED"] = function()

	RoguePowerBar_OnPlayerTargetChanged();
	
end


RoguePowerBar_EventHandler["PLAYER_ENTERING_WORLD"] = function()

	RoguePowerBar_OnPlayerEnteringWorld();

end


RoguePowerBar_EventHandler["CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"] = function()

	RoguePowerBar_OnChatMsgSpellPeriodicSelfBuffs(arg1);

end


RoguePowerBar_EventHandler["PLAYER_TARGET_CHANGED"] = function()

	RoguePowerBar_OnPlayerTargetChanged();

end


RoguePowerBar_EventHandler["CHAT_MSG_SPELL_SELF_DAMAGE"] = function()

	RoguePowerBar_OnChatMsgSpellSelfDamage(arg1);

end

RoguePowerBar_Save = {};

-------------------------- Defien the Power Bars ----------------------------------------

RoguePowerBar_Bars = {};

STATUSBAR_SLICEANDDICE = GetNext();
RoguePowerBar_Bars[STATUSBAR_SLICEANDDICE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Slice and Dice",
				DisplayOrder = 0,
				IsInTalentTree=false,
				TalentTreeName = "Slice and Dice"
			};


STATUSBAR_CRUSADER = GetNext();
RoguePowerBar_Bars[STATUSBAR_CRUSADER] = {
				Icon = nil,
				BackDropColor = { r = 0.5, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.5, b = 1; a = 0.8 },
				BasedOnAuraName = "Holy Strength",
				DisplayOrder = 2,
				IsInTalentTree=false,
				TalentTreeName = "Holy Strength"
			};

STATUSBAR_SPRINT = GetNext();
RoguePowerBar_Bars[STATUSBAR_SPRINT] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Sprint",
				DisplayOrder = 3,
				IsInTalentTree=false,
				TalentTreeName = "Sprint"
			};


STATUSBAR_COS = GetNext();
RoguePowerBar_Bars[STATUSBAR_COS] = {
				Icon = nil,
				BackDropColor = { r = 0.4, g = 0, b = 0.5, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
				BasedOnAuraName = "Cloak of Shadows",
				DisplayOrder = 4,
				IsInTalentTree=false,
				TalentTreeName = "Cloak of Shadows"
			};


STATUSBAR_BLADEFLURRY = GetNext();
RoguePowerBar_Bars[STATUSBAR_BLADEFLURRY] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Blade Flurry",
				DisplayOrder = 5,
				IsInTalentTree=true,
				TalentTreeName = "Blade Flurry"
			};


STATUSBAR_ADRENALINE = GetNext();
RoguePowerBar_Bars[STATUSBAR_ADRENALINE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.5, b = 0.8, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0.5, b = 0.8; a = 0.8 },
				BasedOnAuraName = "Adrenaline Rush",
				DisplayOrder = 6,
				IsInTalentTree=true,
				TalentTreeName = "Adrenaline Rush"
			};

STATUSBAR_EVASION = GetNext();
RoguePowerBar_Bars[STATUSBAR_EVASION] = {
				Icon = nil,
				BackDropColor = { r = 1, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.5, b = 1; a = 0.8 },
				BasedOnAuraName = "Evasion",
				DisplayOrder = 8,
				IsInTalentTree=false,
				TalentTreeName = "Evasion"
			
			};

STATUSBAR_GHOSTLYSTRIKE = GetNext();
RoguePowerBar_Bars[STATUSBAR_GHOSTLYSTRIKE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Ghostly Strike",
				DisplayOrder = 9,
				IsInTalentTree=true,
				TalentTreeName = "Ghostly Strike"
			};

STATUSBAR_HUNGER_FOR_BLOOD = GetNext();
RoguePowerBar_Bars[STATUSBAR_HUNGER_FOR_BLOOD] = {
				Icon = nil,
				BackDropColor = { r = 0.6, g = 0.1, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9; g = 0.2; b = 0; a = 0.8 },
				BasedOnAuraName = "Hunger For Blood",
				DisplayOrder = 36,
				IsInTalentTree=true,
				TalentTreeName = "Hunger For Blood"
}; 


STATUSBAR_SHADOWSTEP = GetNext();
RoguePowerBar_Bars[STATUSBAR_SHADOWSTEP] = { 
				Icon = nil, 
				BackDropColor = { r = 0.6, g = 0, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Shadowstep", 
				DisplayOrder = 12, 
				IsInTalentTree=true,
				TalentTreeName = "Shadowstep"
			};  

STATUSBAR_REMORSELESS = GetNext();
RoguePowerBar_Bars[STATUSBAR_REMORSELESS] = { 
				Icon = nil, 
				BackDropColor = { r = 0, g = 0.5, b = 0.5, a = 0.3 },
				StatusBarColor = { r = 0, g = 0.5, b = 0.5; a = 0.8 },
				BasedOnAuraName = "Remorseless", 
				DisplayOrder = 13, 
				IsInTalentTree=true,
				TalentTreeName = "Remorseless Attacks"
			};

STATUSBAR_MONGOOSE = GetNext();
RoguePowerBar_Bars[STATUSBAR_MONGOOSE] = { 
				Icon = nil, 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Lightning Speed", 
				DisplayOrder = 14, 
				IsInTalentTree=false,
				TalentTreeName = "Lightning Speed"
			};


STATUSBAR_HASTE = GetNext();
RoguePowerBar_Bars[STATUSBAR_HASTE] = { 
				Icon = nil, 
				BackDropColor = { r = 1, g = 0.9, b = 0, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.9, b = 0; a = 0.8 },
				BasedOnAuraName = "Haste", 
				DisplayOrder = 15, 
				IsInTalentTree=false,
				TalentTreeName = "Haste"
			};

STATUSBAR_DELUSIONAL = GetNext();
RoguePowerBar_Bars[STATUSBAR_DELUSIONAL] = { 
				Icon = nil, 
				BackDropColor = { r = 0.6, g = 0.6, b = 1, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0.6, b = 1; a = 0.8 },
				BasedOnAuraName = "Delusional", 
				DisplayOrder = 16, 
				IsInTalentTree=false,
				TalentTreeName = "Delusional"
			};


STATUSBAR_PARANOIA = GetNext();
RoguePowerBar_Bars[STATUSBAR_PARANOIA] = { 
				Icon = nil, 
				BackDropColor = { r = 0.0, g = 0.8, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 0.0, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "Paranoia", 
				DisplayOrder = 17, 
				IsInTalentTree=false,
				TalentTreeName = "Paranoia"
			};


STATUSBAR_MARTYR_COMPLEX = GetNext();
RoguePowerBar_Bars[STATUSBAR_MARTYR_COMPLEX] = { 
				Icon = nil, 
				BackDropColor = { r = 0.2, g = 0.1, b = 0.9, a = 0.3 },
				StatusBarColor = { r = 0.2, g = 0.1, b = 0.9; a = 0.8 },
				BasedOnAuraName = "Martyr Complex", 
				DisplayOrder = 18, 
				IsInTalentTree=false,
				TalentTreeName = "Martyr Complex"
			};


STATUSBAR_MANIC = GetNext();
RoguePowerBar_Bars[STATUSBAR_MANIC] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Manic", 
				DisplayOrder = 19, 
				IsInTalentTree=false,
				TalentTreeName = "Manic"
			};


STATUSBAR_BERSERKING = GetNext();
RoguePowerBar_Bars[STATUSBAR_BERSERKING] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Berserking", 
				DisplayOrder = 20, 
				IsInTalentTree=false,
				TalentTreeName = "Berserking"
			};


STATUSBAR_FEROCITY = GetNext();
RoguePowerBar_Bars[STATUSBAR_FEROCITY] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Ferocity", 
				DisplayOrder = 21, 
				IsInTalentTree=false,
				TalentTreeName = "Ferocity"
			};

STATUSBAR_COREOFARKELOS = GetNext();
RoguePowerBar_Bars[STATUSBAR_COREOFARKELOS] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Ancient Power", 
				DisplayOrder = 22, 
				IsInTalentTree=false,
				TalentTreeName = "Ancient Power"
			};
			
STATUSBAR_EXECUTIONER = GetNext();
RoguePowerBar_Bars[STATUSBAR_EXECUTIONER] = { 
				Icon = nil, 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Executioner", 
				DisplayOrder = 23, 
				IsInTalentTree=false,
				TalentTreeName = "Executioner"
			};

STATUSBAR_BATTLESHOUT = GetNext();
RoguePowerBar_Bars[STATUSBAR_BATTLESHOUT] = { 
				Icon = nil, 
				BackDropColor = { r = 0.8, g = 0.5, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "Battle Shout", 
				DisplayOrder = 24, 
				IsInTalentTree=false,
				TalentTreeName = "Battle Shout"
			};

STATUSBAR_COUPDEGRACE = GetNext();
RoguePowerBar_Bars[STATUSBAR_COUPDEGRACE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
				BasedOnAuraName = "Coup de Grace",
				DisplayOrder = 25,
				IsInTalentTree=false,
				TalentTreeName = "Coup de Grace"
                        };


STATUSBAR_EXPLOITWEAKNESS = GetNext();
RoguePowerBar_Bars[STATUSBAR_EXPLOITWEAKNESS] = {
				Icon = nil,
				BackDropColor =  { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Exploit Weakness",
				DisplayOrder = 26,
				IsInTalentTree=false,
				TalentTreeName = "Exploit Weakness"
                        };


STATUSBAR_FURYOFTHECRASHINGWAVES = GetNext();
RoguePowerBar_Bars[STATUSBAR_FURYOFTHECRASHINGWAVES] = {
				Icon = nil,
				BackDropColor =  { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Fury of the Crashing Waves",
				DisplayOrder = 27,
				IsInTalentTree=false,
				TalentTreeName = "Fury of the Crashing Waves"
                        };


STATUSBAR_ELIXIROFDEMONSLAYING = GetNext();
RoguePowerBar_Bars[STATUSBAR_ELIXIROFDEMONSLAYING] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Elixir of Demonslaying",
				DisplayOrder = 28,
				IsInTalentTree=false,
				TalentTreeName = "Elixir of Demonslaying"
                        };


STATUSBAR_PERCEIVEDWEAKNESS = GetNext();
RoguePowerBar_Bars[STATUSBAR_PERCEIVEDWEAKNESS] = {
				Icon = nil,
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Perceived Weakness",
				DisplayOrder = 29,
				IsInTalentTree=false,
				TalentTreeName = "Perceived Weakness"
                        };


STATUSBAR_FORCEFULSTRIKE = GetNext();
RoguePowerBar_Bars[STATUSBAR_FORCEFULSTRIKE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Forceful Strike",
				DisplayOrder = 30,
				IsInTalentTree=false,
				TalentTreeName = "Forceful Strike"
                        };

STATUSBAR_DRUMSOFBATTLE = GetNext();
RoguePowerBar_Bars[STATUSBAR_DRUMSOFBATTLE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Drums of Battle",
				DisplayOrder = 31,
				IsInTalentTree=false,
				TalentTreeName = "Drums of Battle"
                        };

STATUSBAR_DRUMSOFWAR = GetNext();
RoguePowerBar_Bars[STATUSBAR_DRUMSOFWAR] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Drums of War",
				DisplayOrder = 32,
				IsInTalentTree=false,
				TalentTreeName = "Drums of War"
                        };

STATUSBAR_THETWINBLADESOFAZZINOTH = GetNext();
RoguePowerBar_Bars[STATUSBAR_THETWINBLADESOFAZZINOTH] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.5, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "The Twin Blades of Azzinoth",
				DisplayOrder = 33,
				IsInTalentTree=false,
				TalentTreeName = "The Twin Blades of Azzinoth"
                        };

STATUSBAR_TREMENDOUS_FORTITUDE = GetNext();
RoguePowerBar_Bars[STATUSBAR_TREMENDOUS_FORTITUDE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.0, b = 0.0, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.0, b = 0.0; a = 0.8 },
				BasedOnAuraName = "Tremendous Fortitude",
				DisplayOrder = 34,
				IsInTalentTree=false,
				TalentTreeName = "Tremendous Fortitude"
                        };
                        

STATUSBAR_DRAGONSPINE_FLURRY = GetNext();
RoguePowerBar_Bars[STATUSBAR_DRAGONSPINE_FLURRY] = {
				Icon = nil,
				BackDropColor = { r = 0.3, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 0.5; g = 0.5; b = 1; a = 0.8 },
				BasedOnAuraName = "Dragonspine Flurry",
				DisplayOrder = 35,
				IsInTalentTree=false,
				TalentTreeName = "Dragonspine Flurry"
			};
			

STATUSBAR_RUPTURE = GetNext();
RoguePowerBar_Bars[STATUSBAR_RUPTURE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.2, b = 0.2, a = 0.3 },
				StatusBarColor = {r = 1, g = 0.2, b = 0.2, a = 0.8 },
				BasedOnAuraName = "Rupture",
				DisplayOrder = 36,
				IsInTalentTree = false,
				TalentTreeName = "Rupture"
};

STATUSBAR_WOUND = GetNext();
RoguePowerBar_Bars[STATUSBAR_WOUND] = {
				Icon = nil,
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				BasedOnAuraName = "Wound Poison V",
				DisplayOrder = 37,
				IsInTalentTree = false,
				TalentTreeName = "Wound Poison V"
};

STATUSBAR_DEADLY = GetNext();
RoguePowerBar_Bars[STATUSBAR_DEADLY] = {
				Icon = nil,
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				BasedOnAuraName = "Deadly Poison VII",
				DisplayOrder = 37,
				IsInTalentTree = false,
				TalentTreeName = "Deadly Poison VII"
};

STATUSBAR_MINDNUMBING = GetNext();
RoguePowerBar_Bars[STATUSBAR_MINDNUMBING] = {
				Icon = nil,
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				BasedOnAuraName = "Mind-numbing Poison",
				DisplayOrder = 37,
				IsInTalentTree = false,
				TalentTreeName = "Mind-numbing Poison"
};

STATUSBAR_CRIPPLING = GetNext();
RoguePowerBar_Bars[STATUSBAR_CRIPPLING] = {
				Icon = nil,
				BackDropColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.3 },
				StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
				BasedOnAuraName = "Crippling Poison",
				DisplayOrder = 38,
				IsInTalentTree = false,
				TalentTreeName = "Crippling Poison"
};

STATUSBAR_BLADETWISTING = GetNext();
RoguePowerBar_Bars[STATUSBAR_BLADETWISTING] = {
				Icon = nil,
				BackDropColor = { r = 0.1, g = 0.47, b = 0.6, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0.47, b = 0.6, a = 0.8 },
				BasedOnAuraName = "Blade Twisting",
				DisplayOrder = 39,
				IsInTalentTree = false,
				TalentTreeName = "Blade Twisting"
};

STATUSBAR_EXPOSEARMOR = GetNext();
RoguePowerBar_Bars[STATUSBAR_EXPOSEARMOR] = { 
				Icon = nil, 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Expose Armor", 
				DisplayOrder = 40, 
				IsInTalentTree=false,
				TalentTreeName = "Expose Armor"
};