local _M = {}

--[[
	Change BizhawkDir to your BizHawk directory.
--]]
--_M.BizhawkDir = "C:\\Users\\mmill\\Downloads\\BizHawk-2.2\\"
_M.BizhawkDir = "C:\\Users\\Ender\\Desktop\\Dolphin-x64\\VERSIONS\\RTCV_5.0.3\\Bizhawk\\"

_M.StateDir = _M.BizhawkDir .. "Lua\\SNES\\neat-mario\\state\\"
_M.PoolDir = _M.BizhawkDir .. "Lua\\SNES\\neat-mario\\pool\\"

--[[
	At the moment the first in list will get loaded.
	Rearrange for other savestates. (will be redone soon)
--]]
_M.State = {
 			"DP1.state",				-- Donut Plains 1
			"YI1.state",				-- Yoshi's Island 1
			"YI2.state",				-- Yoshi's Island 2
}

--[[
	Start game with specific powerup.
	0 = No powerup
	1 = Mushroom
	2 = Feather
	3 = Flower
	Comment out to disable.
--]]
_M.StartPowerup = 0

_M.NeatConfig = {
--Filename = "DP1.state",
Filename = _M.PoolDir .. _M.State[1],
Population = 300,
DeltaDisjoint = 2.0,
DeltaWeights = 0.4,
DeltaThreshold = 1.0,
StaleSpecies = 15,
MutateConnectionsChance = 0.25,
PerturbChance = 0.90,
CrossoverChance = 0.75,
LinkMutationChance = 2.0,
NodeMutationChance = 0.50,
BiasMutationChance = 0.40,
StepSize = 0.1,
DisableMutationChance = 0.4,
EnableMutationChance = 0.2,
TimeoutConstant = 20,
MaxNodes = 1000000,
}

_M.ButtonNames = {
		"A",
		"B",
		"X",
		"Y",
		"Up",
		"Down",
		"Left",
		"Right",
	}
	
_M.BoxRadius = 6
_M.InputSize = (_M.BoxRadius*2+1)*(_M.BoxRadius*2+1)

_M.Running = false

return _M