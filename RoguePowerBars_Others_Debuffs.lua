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

-- Mangle - Bear
RoguePowerBar_OthersDebuffs_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 33987,
	Name = "Mangle - Bear",
};

-- Mangle - Cat
RoguePowerBar_OthersDebuffs_Default[GetNext()] = {
	StatusBarColor = { r = 0.9, g = 0.8, b = 0; a = 0.8 },
	SpellID = 33983,
	Name = "Mangle - Cat",
};

do
	for i = 1, #RoguePowerBar_OthersDebuffs_Default do
		local buff = RoguePowerBar_Buff_Default[i];
		local name = GetSpellInfo(buff.SpellID);
		buff.Name = name;
	end
end