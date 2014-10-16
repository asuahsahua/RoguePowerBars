--[[
LibPlayerSpells-1.0 - Additional information about player spells.
(c) 2013 Adirelle (adirelle@gmail.com)

This file is part of LibPlayerSpells-1.0.

LibPlayerSpells-1.0 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LibPlayerSpells-1.0 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LibPlayerSpells-1.0.  If not, see <http://www.gnu.org/licenses/>.
--]]

local lib = LibStub("LibPlayerSpells-1.0")
if not lib then return end
lib:__RegisterSpells("DEATHKNIGHT", "50400", 1, {
	['PERSONAL SURVIVAL COOLDOWN AURA']= {
		48707, -- Anti-Magic Shell
		48792, -- Icebound Fortitude
		49028, -- Dancing Rune Weapon
		49222, -- Bone Shield
		55233, -- Vampiric Blood
	},
	['INTERRUPT COOLDOWN'] = {
		 47528, -- Mind Freeze
		 91802, -- Shambling Rush (Ghoul)
		["HARMFUL AURA"] = {
			47476, -- Strangulate
		},
	},
}, {
	-- Map aura to provider
}, {
	-- Map aura to modified spell(s)
})