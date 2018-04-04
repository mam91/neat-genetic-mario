local _M = {}

--
-- Change BizhawkDir to your BizHawk directory.
--
--_M.BizhawkDir = "C:/Users/mmill/Downloads/BizHawk-2.2/"
_M.BizhawkDir = "X:/BizHawkLab/BizHawk-2.2.2/"

_M.StateDir = _M.BizhawkDir .. "Lua/SNES/neat-mario/state/"
_M.PoolDir = _M.BizhawkDir .. "Lua/SNES/neat-mario/pool/"

_M.NeatConfig = {
--Filename = "DP1.state",
Filename = _M.PoolDir .. "DP1.state",
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