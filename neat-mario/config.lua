local _M = {}

_M.StateDir = "state/"
_M.PoolDir = "pool/"

_M.TestName = "test1"

--[[
	If LoopStates in NeatConfig is enabled it will loop through the states in order changing states with each generation.
	States currently have to be manually added to the list below as well as put in the state folder.
--]]

_M.State = {
	"DonutPlains1.state",
	-- "DonutPlains4.state",
	-- "IggyCastle.state",
	-- "YoshiIsland1.state",
	-- "YoshiIsland2.state"
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
	LoopStates = false,
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
