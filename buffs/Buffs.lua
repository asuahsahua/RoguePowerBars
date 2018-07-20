local L = LibStub("AceLocale-3.0"):GetLocale("RoguePowerBars")

RoguePowerBar_Buff_Default = {}

local i = 0

local function GetNext()
	i = i + 1
	return i
end

local function ResetIndex()
	i = 0
end

ResetIndex()

--===========================
-- Class Skills
--===========================

-- Example template
-- RoguePowerBar_Buff_Default[GetNext()] = {
-- 	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
-- 	SpellID = 26297,
-- 	Name = "Berserking",
-- };

do
	for i = 1, #RoguePowerBar_Buff_Default do
		local buff = RoguePowerBar_Buff_Default[i]
		local name = GetSpellInfo(buff.SpellID)
		if (name) then
			buff.Name = name
		else
			print(
				L["RoguePowerBars"] ..
					": " ..
						L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID, buff.Name)
			)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
RoguePowerBar_Debuff_Default = {}

ResetIndex()

--===========================
-- Class Skills
--===========================

-- Example template
-- RoguePowerBar_Debuff_Default[GetNext()] = {
-- 	StatusBarColor = { r = 0.02, g = 0.75, b = 0.02, a = 0.8 },
-- 	SpellID = 113952,
-- 	Name = "Paralytic Poison",
-- };

--===================================================================
--===================================================================
--===================================================================
do
	for i = 1, #RoguePowerBar_Debuff_Default do
		local buff = RoguePowerBar_Debuff_Default[i]
		local name = GetSpellInfo(buff.SpellID)
		if (name) then
			buff.Name = name
		else
			print(
				L["RoguePowerBars"] ..
					": " ..
						L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID, buff.Name)
			)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

RoguePowerBar_OthersDebuffs_Default = {}

ResetIndex()

-- Example template
-- RoguePowerBar_OthersDebuffs_Default[GetNext()] = {
-- 	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
-- 	SpellID = 33876,
-- 	Name = "Mangle (Cat)",
-- };

do
	for i = 1, #RoguePowerBar_OthersDebuffs_Default do
		local buff = RoguePowerBar_OthersDebuffs_Default[i]
		local name = GetSpellInfo(buff.SpellID)
		if (name) then
			buff.Name = name
		else
			print(
				L["RoguePowerBars"] ..
					": " ..
						L["Warning - SpellID: %s for %s does not exist.  Using default name instead."]:format(buff.SpellID, buff.Name)
			)
		end
	end
end
