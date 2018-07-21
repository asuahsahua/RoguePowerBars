local RoguePowerBars = LibStub("AceAddon-3.0"):GetAddon("RoguePowerBars")
local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")
local LibPlayerSpells = LibStub('LibPlayerSpells-1.0')
local band = _G.bit.band
local bnot = _G.bit.bnot

function RoguePowerBars:GetBarsetDefaults(useLibPlayerSpells)
    local buff = self.CreateBuffObject
    local defaults = {
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

    -- TODO: Make this an option
    useLibPlayerSpells = true
    if useLibPlayerSpells then
        defaults =self:_AddLibPlayerSpells(defaults)
    end

    return defaults
end

function RoguePowerBars:_AddLibPlayerSpells(defaults)
    if not LibPlayerSpells then
        return defaults
    end

    self:Print("Loading defaults from LibPlayerSpells")

    local lps = LibPlayerSpells
    local c = LibPlayerSpells.constants
    local buff = self.CreateBuffObject

    -- Search LPS for our class' buffs and debuffs
    local fmt = "Aura: %s %x"
    -- TODO: Search based on what class we are, not just rogue
    for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells("ROGUE") do
        if band(flags, c.AURA) ~= 0 then
            if band(flags, c.PERSONAL) ~= 0 then
                -- TODO: Check what happens when there are duplicate names
                table.insert(defaults.Buffs, buff(spellId))
            elseif band(flags, c.HARMFUL) ~= 0 then
                table.insert(defaults.Debuffs, buff(spellId))
            end
        end
    end

    return defaults
end