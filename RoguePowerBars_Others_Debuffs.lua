RoguePowerBar_OthersDebuffs_Default = {};

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
-- Rogues
--===========================
-- Expose Armor
RoguePowerBar_OthersDebuffs_Default[GetNext()] = { 
	StatusBarColor = { r = 0.3, g = 0.5, b = 0.7; a = 0.5 },
	SpellID = 26866,
	Name = "Expose Armor", 
};

--===========================
-- Other
--===========================
-- Sunder Armor
RoguePowerBar_OthersDebuffs_Default[GetNext()] = { 
	StatusBarColor = { r = 0.55, g = 0.3, b = 0.1; a = 0.8 },
	SpellID = 58567,
	Name = "Sunder Armor", 
};

-- Mangle - Bear
RoguePowerBar_OthersDebuffs_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 48564,
	Name = "Mangle - Bear",
};

-- Mangle - Cat
RoguePowerBar_OthersDebuffs_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 48566,
	Name = "Mangle - Cat",
};

do
	for i = 1, #RoguePowerBar_OthersDebuffs_Default do
		local buff = RoguePowerBar_OthersDebuffs_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		if(name) then
			buff.Name = name;
		else
			print("RoguePowerBars: Warning - SpellID: "..buff.SpellID.." for "..buff.Name.." does not exist.  Using default name instead")
		end
	end
end
