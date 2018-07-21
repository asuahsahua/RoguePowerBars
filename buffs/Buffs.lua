local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

local function buff(spellId, red, green, blue, alpha)
    return {
        StatusBarColor = {
            r = red or .5,
            g = green or .5,
            b = blue or .5,
            a = alpha or 1
        },
        SpellID = spellId,
        Name = GetSpellInfo(spellId),
    }
end

-- TODO: Fill these out with useful defaults
RoguePowerBars.Defaults = RoguePowerBars.Defaults or {}
RoguePowerBars.Defaults.Barsets = {
    Buffs = {
        -- Feint
        buff(1966, 0.047, 0.675, 0.890),
        -- Adrenaline Rush
        buff(13750, 0.812, 0.639, 0.188)
    },
    Debuffs = {
    },
    OthersDebuffs = {
    }
}

--[[
["CrimsonVial"] = {
    ["Name"] = "Crimson Vial",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.109803921568627,
        ["g"] = 0.0549019607843137,
        ["r"] = 0.501960784313726,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["TricksoftheTrade"] = {
    ["Name"] = "Tricks of the Trade",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.443137254901961,
        ["g"] = 0.380392156862745,
        ["r"] = 0.937254901960784,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["SliceandDice"] = {
    ["Name"] = "Slice and Dice",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.231372549019608,
        ["g"] = 0.796078431372549,
        ["r"] = 0.913725490196078,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["Feint"] = {
    ["Name"] = "Feint",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.890196078431373,
        ["g"] = 0.674509803921569,
        ["r"] = 0.0470588235294118,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["MasterAssassin'sInitiative"] = {
    ["Name"] = "Master Assassin's Initiative",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.898039215686275,
        ["g"] = 0.223529411764706,
        ["r"] = 0.701960784313726,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["Sprint"] = {
    ["Name"] = "Sprint",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.196078431372549,
        ["g"] = 0.286274509803922,
        ["r"] = 0.725490196078431,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
["BladeFlurry"] = {
    ["Name"] = "Blade Flurry",
    ["Color"] = {
        ["a"] = 1,
        ["b"] = 0.313725490196078,
        ["g"] = 0.184313725490196,
        ["r"] = 0.819607843137255,
    },
    ["Priority"] = 0,
    ["Barset"] = 1,
    ["IsEnabled"] = true,
},
                ]]--