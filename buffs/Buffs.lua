local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local GetSpellInfo = _G.GetSpellInfo

local function buff(spellId, red, green, blue, alpha)
    if spellId == nil then
        return nil
    end

    local name = GetSpellInfo(spellId)
    if name == nil then
        return nil
    end

    return {
        StatusBarColor = {
            r = red or .5,
            g = green or .5,
            b = blue or .5,
            a = alpha or 1
        },
        SpellID = spellId,
        Name = name,
    }
end

function RoguePowerBars:GetBarsetDefaults()
    return {
        -- TODO: Fill these out with useful defaults
        Buffs = {
            -- Feint
            buff(1966, 0.047, 0.675, 0.890),
            -- Adrenaline Rush
            buff(13750, 0.812, 0.639, 0.188),
        },
        Debuffs = {
            -- Rupture
            buff(1943)
        },
        OthersDebuffs = {
            -- DH Chaos Brand
            buff(255260)
        }
    }
end

local POPULATE = {
    BUFFS = 1,
    DEBUFFS = 2,
    OTHERSDEBUFFS = 4
}

--[[
    @param type         The POPULATE constant corresponding to what is being populated
    @param profileBuffs The buffs on the profile for the given constant
    @param plugin       The plugin value to record this information (FIXME useful for ace config? everything about that is confusing)
]]--
function RoguePowerBars:_populateBuffData(type, profileBuffs, plugin)
    plugin.buffs = {}
    local buffs = plugin.buffs
    for k, buffSettings in pairs(profileBuffs) do
        if buffSettings.Name == nil then
			self:Print(L["%s possibly corrupt in buff list. Attempting to remove."]:format(tostring(k)))
			profileBuffs[k] = nil
            self:_populateBuffData(type, profileBuffs, plugin)
            return
        end

        -- TODO: Better keying, normalizing the name is hardly unique
        local buffName = self:RemoveSpaces(buffSettings.Name)
        buffs[buffName] = {
            type = "group",
            name = buffSettings.Name,
            get = function(info)
                return profileBuffs[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                profileBuffs[info[#info - 1]][info[#info]] = value
                self:UpdateBuffs()
            end,
            args = {
                IsEnabled = {
                    type = "toggle",
                    order = 1,
                    name = L["Enabled"],
                    desc = L["Enable %s"]:format(tostring(buffSettings.Name))
                },
                Color = {
                    type = "color",
                    order = 2,
                    name = L["Bar Color"],
                    hasAlpha = false,
                    get = function(info)
                        local c = profileBuffs[info[#info - 1]].Color
                        return c.r, c.g, c.b, 1
                    end,
                    set = function(info, r, g, b, a)
                        local c = profileBuffs[info[#info - 1]].Color
                        c.r, c.g, c.b, c.a = r, g, b, a
                        self:UpdateBuffs()
                    end
                },
                Priority = {
                    type = "range",
                    order = 3,
                    name = L["Priority"],
                    min = -10,
                    max = 10,
                    step = 1,
                    isPercent = false
                },
                Barset = {
                    type = "select",
                    order = 4,
                    name = L["Barset"],
                    desc = L["The barset this bar will be displayed in"],
                    values = self:GetBarSets()
                },
                Divider1 = {
                    type = "description",
                    name = "",
                    order = 5
                },
                Remove = {
                    order = 6,
                    type = "execute",
                    name = L["Remove Buff"],
                    desc = L["Removes this buff from the listing completely"],
                    func = function(info)
                        self:RemoveBuffOption(info[#info - 1])
                    end
                }
            }
        }
	end
end

function RoguePowerBars:PopulateBuffs()
    self:_populateBuffData(POPULATE.BUFFS, self.profile.buffs, self.plugins.buffs)
end

function RoguePowerBars:PopulateDebuffs()
    self:_populateBuffData(POPULATE.DEBUFFS, self.profile.debuffs, self.plugins.debuffs)
end

function RoguePowerBars:PopulateOthersDebuffs()
    self:_populateBuffData(POPULATE.OTHERSDEBUFFS, self.profile.othersDebuffs, self.plugins.othersDebuffs)
end

-- TODO: Parse the following and 
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