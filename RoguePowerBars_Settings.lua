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


STATUSBAR_SLICEANDDICE = 1;
STATUSBAR_MOS = 2;  -- DON'T REMOVE THIS. 
STATUSBAR_CRUSADER = 3;
STATUSBAR_SPRINT = 4;
STATUSBAR_COS = 5;
STATUSBAR_BLADEFLURRY = 6;
STATUSBAR_ADRENALINE = 7;
STATUSBAR_RIPOSTE = 8;
STATUSBAR_EVASION = 9;
STATUSBAR_GHOSTLYSTRIKE = 10;
STATUSBAR_HUNGER_FOR_BLOOD = 11;
STATUSBAR_PREMED = 12;
STATUSBAR_SHADOWSTEP = 13;
STATUSBAR_REMORSELESS = 14;
STATUSBAR_MONGOOSE = 15;
STATUSBAR_HASTE = 16;
STATUSBAR_DELUSIONAL = 17;
STATUSBAR_PARANOIA = 18;
STATUSBAR_MARTYR_COMPLEX = 19;
STATUSBAR_MANIC = 20;
STATUSBAR_BERSERKING = 21;
STATUSBAR_FEROCITY = 22;
STATUSBAR_COREOFARKELOS = 23;
STATUSBAR_EXECUTIONER = 24;
STATUSBAR_BATTLESHOUT = 25;
STATUSBAR_COUPDEGRACE = 26;
STATUSBAR_EXPLOITWEAKNESS = 27;
STATUSBAR_FURYOFTHECRASHINGWAVES = 28;
STATUSBAR_ELIXIROFDEMONSLAYING = 29;
STATUSBAR_PERCEIVEDWEAKNESS = 30;
STATUSBAR_FORCEFULSTRIKE = 31;
STATUSBAR_DRUMSOFBATTLE = 32;
STATUSBAR_DRUMSOFWAR = 33;
STATUSBAR_THETWINBLADESOFAZZINOTH = 34;
STATUSBAR_TREMENDOUS_FORTITUDE = 35;
STATUSBAR_DRAGONSPINE_FLURRY = 36;

-- Number of Status Bars that should be displayed in the config section on each row
MAX_NO_ON_FIRST_ROW = 7;


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

--Rogue Power Bar for Slice And Dice
RoguePowerBar_Bars[STATUSBAR_SLICEANDDICE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Slice and Dice",
				DisplayOrder = 0,
				IsInTalentTree=false,
				TalentTreeName = "Slice and Dice"
			};

--Rogue Power Bar for Master Of Subtlety
RoguePowerBar_Bars[STATUSBAR_MOS] = {
				Icon = "Interface\\Icons\\Ability_Rogue_MasterOfSubtlety",
				BackDropColor = { r = 0.3, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 0; g = 0.5; b = 1; a = 0.8 },
				BasedOnAuraName = "Master of Subtlety",
				DisplayOrder = 1,
				IsInTalentTree=true,
				TalentTreeName = "Master of Subtlety"
			};

--Rogue Power Bar for Crusader
RoguePowerBar_Bars[STATUSBAR_CRUSADER] = {
				Icon = nil,
				BackDropColor = { r = 0.5, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.5, b = 1; a = 0.8 },
				BasedOnAuraName = "Holy Strength",
				DisplayOrder = 2,
				IsInTalentTree=false,
				TalentTreeName = "Holy Strength"
			};

RoguePowerBar_Bars[STATUSBAR_SPRINT] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Sprint",
				DisplayOrder = 3,
				IsInTalentTree=false,
				TalentTreeName = "Sprint"
			};


RoguePowerBar_Bars[STATUSBAR_COS] = {
				Icon = nil,
				BackDropColor = { r = 0.4, g = 0, b = 0.5, a = 0.3 },
				StatusBarColor = { r = 0.4, g = 0, b = 0.5; a = 0.8 },
				BasedOnAuraName = "Cloak of Shadows",
				DisplayOrder = 4,
				IsInTalentTree=false,
				TalentTreeName = "Cloak of Shadows"
			};


RoguePowerBar_Bars[STATUSBAR_BLADEFLURRY] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Blade Flurry",
				DisplayOrder = 5,
				IsInTalentTree=true,
				TalentTreeName = "Blade Flurry"
			};


RoguePowerBar_Bars[STATUSBAR_ADRENALINE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.5, b = 0.8, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0.5, b = 0.8; a = 0.8 },
				BasedOnAuraName = "Adrenaline Rush",
				DisplayOrder = 6,
				IsInTalentTree=true,
				TalentTreeName = "Adrenaline Rush"
			};

RoguePowerBar_Bars[STATUSBAR_RIPOSTE] = {
				Icon = nil,
				BackDropColor = { r = 1, g = 0.7, b = 0, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.7, b = 0; a = 0.8 },
				BasedOnAuraName = "Riposte",
				DisplayOrder = 7,
				IsInTalentTree=true,
				TalentTreeName = "Riposte"
			};

RoguePowerBar_Bars[STATUSBAR_EVASION] = {
				Icon = nil,
				BackDropColor = { r = 1, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.5, b = 1; a = 0.8 },
				BasedOnAuraName = "Evasion",
				DisplayOrder = 8,
				IsInTalentTree=false,
				TalentTreeName = "Evasion"
			
			};

RoguePowerBar_Bars[STATUSBAR_GHOSTLYSTRIKE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Ghostly Strike",
				DisplayOrder = 9,
				IsInTalentTree=true,
				TalentTreeName = "Ghostly Strike"
			};

RoguePowerBar_Bars[STATUSBAR_HUNGER_FOR_BLOOD] = {
				Icon = nil,
				BackDropColor = { r = 0.6, g = 0.1, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9; g = 0.2; b = 0; a = 0.8 },
				BasedOnAuraName = "Hunger For Blood",
				DisplayOrder = 36,
				IsInTalentTree=true,
				TalentTreeName = "Hunger For Blood"
}; 

RoguePowerBar_Bars[STATUSBAR_PREMED] = {
				Icon = nil,
				BackDropColor = { r = 0.6, g = 0.6, b = 0.6, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
				BasedOnAuraName = "Premeditation",
				DisplayOrder = 11,
				IsInTalentTree=true,
				TalentTreeName = "Premeditation"
			};

RoguePowerBar_Bars[STATUSBAR_SHADOWSTEP] = { 
				Icon = nil, 
				BackDropColor = { r = 0.6, g = 0, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Shadowstep", 
				DisplayOrder = 12, 
				IsInTalentTree=true,
				TalentTreeName = "Shadowstep"
			};  

RoguePowerBar_Bars[STATUSBAR_REMORSELESS] = { 
				Icon = nil, 
				BackDropColor = { r = 0, g = 0.5, b = 0.5, a = 0.3 },
				StatusBarColor = { r = 0, g = 0.5, b = 0.5; a = 0.8 },
				BasedOnAuraName = "Remorseless", 
				DisplayOrder = 13, 
				IsInTalentTree=true,
				TalentTreeName = "Remorseless Attacks"
			};

RoguePowerBar_Bars[STATUSBAR_MONGOOSE] = { 
				Icon = nil, 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Lightning Speed", 
				DisplayOrder = 14, 
				IsInTalentTree=false,
				TalentTreeName = "Lightning Speed"
			};


RoguePowerBar_Bars[STATUSBAR_HASTE] = { 
				Icon = nil, 
				BackDropColor = { r = 1, g = 0.9, b = 0, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.9, b = 0; a = 0.8 },
				BasedOnAuraName = "Haste", 
				DisplayOrder = 15, 
				IsInTalentTree=false,
				TalentTreeName = "Haste"
			};

RoguePowerBar_Bars[STATUSBAR_DELUSIONAL] = { 
				Icon = nil, 
				BackDropColor = { r = 0.6, g = 0.6, b = 1, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0.6, b = 1; a = 0.8 },
				BasedOnAuraName = "Delusional", 
				DisplayOrder = 16, 
				IsInTalentTree=false,
				TalentTreeName = "Delusional"
			};


RoguePowerBar_Bars[STATUSBAR_PARANOIA] = { 
				Icon = nil, 
				BackDropColor = { r = 0.0, g = 0.8, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 0.0, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "Paranoia", 
				DisplayOrder = 17, 
				IsInTalentTree=false,
				TalentTreeName = "Paranoia"
			};


RoguePowerBar_Bars[STATUSBAR_MARTYR_COMPLEX] = { 
				Icon = nil, 
				BackDropColor = { r = 0.2, g = 0.1, b = 0.9, a = 0.3 },
				StatusBarColor = { r = 0.2, g = 0.1, b = 0.9; a = 0.8 },
				BasedOnAuraName = "Martyr Complex", 
				DisplayOrder = 18, 
				IsInTalentTree=false,
				TalentTreeName = "Martyr Complex"
			};


RoguePowerBar_Bars[STATUSBAR_MANIC] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Manic", 
				DisplayOrder = 19, 
				IsInTalentTree=false,
				TalentTreeName = "Manic"
			};


RoguePowerBar_Bars[STATUSBAR_BERSERKING] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Berserking", 
				DisplayOrder = 20, 
				IsInTalentTree=false,
				TalentTreeName = "Berserking"
			};


RoguePowerBar_Bars[STATUSBAR_FEROCITY] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Ferocity", 
				DisplayOrder = 21, 
				IsInTalentTree=false,
				TalentTreeName = "Ferocity"
			};

RoguePowerBar_Bars[STATUSBAR_COREOFARKELOS] = { 
				Icon = nil, 
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
				BasedOnAuraName = "Ancient Power", 
				DisplayOrder = 22, 
				IsInTalentTree=false,
				TalentTreeName = "Ancient Power"
			};
RoguePowerBar_Bars[STATUSBAR_EXECUTIONER] = { 
				Icon = nil, 
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Executioner", 
				DisplayOrder = 23, 
				IsInTalentTree=false,
				TalentTreeName = "Executioner"
			};


RoguePowerBar_Bars[STATUSBAR_BATTLESHOUT] = { 
				Icon = nil, 
				BackDropColor = { r = 0.8, g = 0.5, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "Battle Shout", 
				DisplayOrder = 24, 
				IsInTalentTree=false,
				TalentTreeName = "Battle Shout"
			};

RoguePowerBar_Bars[STATUSBAR_COUPDEGRACE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.8, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.6, g = 0.6, b = 0.6; a = 0.8 },
				BasedOnAuraName = "Coup de Grace",
				DisplayOrder = 25,
				IsInTalentTree=false,
				TalentTreeName = "Coup de Grace"
                        };


RoguePowerBar_Bars[STATUSBAR_EXPLOITWEAKNESS] = {
				Icon = nil,
				BackDropColor =  { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Exploit Weakness",
				DisplayOrder = 26,
				IsInTalentTree=false,
				TalentTreeName = "Exploit Weakness"
                        };


RoguePowerBar_Bars[STATUSBAR_FURYOFTHECRASHINGWAVES] = {
				Icon = nil,
				BackDropColor =  { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Fury of the Crashing Waves",
				DisplayOrder = 27,
				IsInTalentTree=false,
				TalentTreeName = "Fury of the Crashing Waves"
                        };


RoguePowerBar_Bars[STATUSBAR_ELIXIROFDEMONSLAYING] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Elixir of Demonslaying",
				DisplayOrder = 28,
				IsInTalentTree=false,
				TalentTreeName = "Elixir of Demonslaying"
                        };


RoguePowerBar_Bars[STATUSBAR_PERCEIVEDWEAKNESS] = {
				Icon = nil,
				BackDropColor = { r = 0.3, g = 0.5, b = 0.7, a = 0.3 },
				StatusBarColor = { r = 0.5, g = 0.8, b = 0.7; a = 0.8 },
				BasedOnAuraName = "Perceived Weakness",
				DisplayOrder = 29,
				IsInTalentTree=false,
				TalentTreeName = "Perceived Weakness"
                        };


RoguePowerBar_Bars[STATUSBAR_FORCEFULSTRIKE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.8, g = 0, b = 0; a = 0.8 },
				BasedOnAuraName = "Forceful Strike",
				DisplayOrder = 30,
				IsInTalentTree=false,
				TalentTreeName = "Forceful Strike"
                        };

RoguePowerBar_Bars[STATUSBAR_DRUMSOFBATTLE] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Drums of Battle",
				DisplayOrder = 31,
				IsInTalentTree=false,
				TalentTreeName = "Drums of Battle"
                        };

RoguePowerBar_Bars[STATUSBAR_DRUMSOFWAR] = {
				Icon = nil,
				BackDropColor = { r = 0.9, g = 0.5, b = 0, a = 0.3 },
				StatusBarColor = { r = 0.9, g = 0.5, b = 0; a = 0.8 },
				BasedOnAuraName = "Drums of War",
				DisplayOrder = 32,
				IsInTalentTree=false,
				TalentTreeName = "Drums of War"
                        };

RoguePowerBar_Bars[STATUSBAR_THETWINBLADESOFAZZINOTH] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.5, b = 0.3, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.8, b = 0.3; a = 0.8 },
				BasedOnAuraName = "The Twin Blades of Azzinoth",
				DisplayOrder = 33,
				IsInTalentTree=false,
				TalentTreeName = "The Twin Blades of Azzinoth"
                        };

RoguePowerBar_Bars[STATUSBAR_TREMENDOUS_FORTITUDE] = {
				Icon = nil,
				BackDropColor = { r = 0.8, g = 0.0, b = 0.0, a = 0.3 },
				StatusBarColor = { r = 1, g = 0.0, b = 0.0; a = 0.8 },
				BasedOnAuraName = "Tremendous Fortitude",
				DisplayOrder = 34,
				IsInTalentTree=false,
				TalentTreeName = "Tremendous Fortitude"
                        };
                        
--Rogue Power Bar for Dragonspine Flurry
RoguePowerBar_Bars[STATUSBAR_DRAGONSPINE_FLURRY] = {
				Icon = nil,
				BackDropColor = { r = 0.3, g = 0.5, b = 1, a = 0.3 },
				StatusBarColor = { r = 0; g = 0.5; b = 1; a = 0.8 },
				BasedOnAuraName = "Dragonspine Flurry",
				DisplayOrder = 35,
				IsInTalentTree=false,
				TalentTreeName = "Dragonspine Flurry"
			};