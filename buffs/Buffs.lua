local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local GetSpellInfo = _G.GetSpellInfo

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

function RoguePowerBars.CreateBuffObject(spellId, red, green, blue, alpha)
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