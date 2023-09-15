--Update to Seth-Bling's MarI/O app

config = require "config"
game = require "game"
mathFunctions = require "mathFunctions"

Inputs = config.InputSize+1
Outputs = #config.ButtonNames

function newInnovation()
	pool.innovation = pool.innovation + 1
	return pool.innovation
end

function newPool()
	local pool = {}
	pool.species = {}
	pool.generation = 0
	pool.innovation = Outputs
	pool.currentSpecies = 1
	pool.currentGenome = 1
	pool.currentFrame = 0
	pool.maxFitness = 0
	
	return pool
end

function newSpecies()
	local species = {}
	species.topFitness = 0
	species.staleness = 0
	species.genomes = {}
	species.averageFitness = 0
	
	return species
end

function newGenome()
	local genome = {}
	genome.genes = {}
	genome.fitness = 0
	genome.adjustedFitness = 0
	genome.network = {}
	genome.maxneuron = 0
	genome.globalRank = 0
	genome.mutationRates = {}
	genome.mutationRates["connections"] = config.NeatConfig.MutateConnectionsChance
	genome.mutationRates["link"] = config.NeatConfig.LinkMutationChance
	genome.mutationRates["bias"] = config.NeatConfig.BiasMutationChance
	genome.mutationRates["node"] = config.NeatConfig.NodeMutationChance
	genome.mutationRates["enable"] = config.NeatConfig.EnableMutationChance
	genome.mutationRates["disable"] = config.NeatConfig.DisableMutationChance
	genome.mutationRates["step"] = config.NeatConfig.StepSize
	
	return genome
end

function copyGenome(genome)
	local genome2 = newGenome()
	for g=1,#genome.genes do
		table.insert(genome2.genes, copyGene(genome.genes[g]))
	end
	genome2.maxneuron = genome.maxneuron
	genome2.mutationRates["connections"] = genome.mutationRates["connections"]
	genome2.mutationRates["link"] = genome.mutationRates["link"]
	genome2.mutationRates["bias"] = genome.mutationRates["bias"]
	genome2.mutationRates["node"] = genome.mutationRates["node"]
	genome2.mutationRates["enable"] = genome.mutationRates["enable"]
	genome2.mutationRates["disable"] = genome.mutationRates["disable"]
	
	return genome2
end

function basicGenome()
	local genome = newGenome()
	local innovation = 1

	genome.maxneuron = Inputs
	mutate(genome)
	
	return genome
end

function newGene()
	local gene = {}
	gene.into = 0
	gene.out = 0
	gene.weight = 0.0
	gene.enabled = true
	gene.innovation = 0
	
	return gene
end

function copyGene(gene)
	local gene2 = newGene()
	gene2.into = gene.into
	gene2.out = gene.out
	gene2.weight = gene.weight
	gene2.enabled = gene.enabled
	gene2.innovation = gene.innovation
	
	return gene2
end

function newNeuron()
	local neuron = {}
	neuron.incoming = {}
	neuron.value = 0.0
	
	return neuron
end

function generateNetwork(genome)
	local network = {}
	network.neurons = {}
	
	for i=1,Inputs do
		network.neurons[i] = newNeuron()
	end
	
	for o=1,Outputs do
		network.neurons[config.NeatConfig.MaxNodes+o] = newNeuron()
	end
	
	table.sort(genome.genes, function (a,b)
		return (a.out < b.out)
	end)
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if gene.enabled then
			if network.neurons[gene.out] == nil then
				network.neurons[gene.out] = newNeuron()
			end
			local neuron = network.neurons[gene.out]
			table.insert(neuron.incoming, gene)
			if network.neurons[gene.into] == nil then
				network.neurons[gene.into] = newNeuron()
			end
		end
	end
	
	genome.network = network
end

function evaluateNetwork(network, inputs)
	table.insert(inputs, 1)
	if #inputs ~= Inputs then
		console.writeline("Incorrect number of neural network inputs.")
		return {}
	end
	
	for i=1,Inputs do
		network.neurons[i].value = inputs[i]
	end
	
	for _,neuron in pairs(network.neurons) do
		local sum = 0
		for j = 1,#neuron.incoming do
			local incoming = neuron.incoming[j]
			local other = network.neurons[incoming.into]
			sum = sum + incoming.weight * other.value
		end
		
		if #neuron.incoming > 0 then
			neuron.value = mathFunctions.sigmoid(sum)
		end
	end
	
	local outputs = {}
	for o=1,Outputs do
		local button = "P1 " .. config.ButtonNames[o]
		if network.neurons[config.NeatConfig.MaxNodes+o].value > 0 then
			outputs[button] = true
		else
			outputs[button] = false
		end
	end
	
	return outputs
end

function crossover(g1, g2)
	-- Make sure g1 is the higher fitness genome
	if g2.fitness > g1.fitness then
		tempg = g1
		g1 = g2
		g2 = tempg
	end

	local child = newGenome()
	
	local innovations2 = {}
	for i=1,#g2.genes do
		local gene = g2.genes[i]
		innovations2[gene.innovation] = gene
	end
	
	for i=1,#g1.genes do
		local gene1 = g1.genes[i]
		local gene2 = innovations2[gene1.innovation]
		if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
			table.insert(child.genes, copyGene(gene2))
		else
			table.insert(child.genes, copyGene(gene1))
		end
	end
	
	child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
	
	for mutation,rate in pairs(g1.mutationRates) do
		child.mutationRates[mutation] = rate
	end
	
	return child
end

function randomNeuron(genes, nonInput)
	local neurons = {}
	if not nonInput then
		for i=1,Inputs do
			neurons[i] = true
		end
	end
	for o=1,Outputs do
		neurons[config.NeatConfig.MaxNodes+o] = true
	end
	for i=1,#genes do
		if (not nonInput) or genes[i].into > Inputs then
			neurons[genes[i].into] = true
		end
		if (not nonInput) or genes[i].out > Inputs then
			neurons[genes[i].out] = true
		end
	end

	local count = 0
	for _,_ in pairs(neurons) do
		count = count + 1
	end
	local n = math.random(1, count)
	
	for k,v in pairs(neurons) do
		n = n-1
		if n == 0 then
			return k
		end
	end
	
	return 0
end

function containsLink(genes, link)
	for i=1,#genes do
		local gene = genes[i]
		if gene.into == link.into and gene.out == link.out then
			return true
		end
	end
end

function pointMutate(genome)
	local step = genome.mutationRates["step"]
	
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if math.random() < config.NeatConfig.PerturbChance then
			gene.weight = gene.weight + math.random() * step*2 - step
		else
			gene.weight = math.random()*4-2
		end
	end
end

function linkMutate(genome, forceBias)
	local neuron1 = randomNeuron(genome.genes, false)
	local neuron2 = randomNeuron(genome.genes, true)
	 
	local newLink = newGene()
	if neuron1 <= Inputs and neuron2 <= Inputs then
		--Both input nodes
		return
	end
	if neuron2 <= Inputs then
		-- Swap output and input
		local temp = neuron1
		neuron1 = neuron2
		neuron2 = temp
	end

	newLink.into = neuron1
	newLink.out = neuron2
	if forceBias then
		newLink.into = Inputs
	end
	
	if containsLink(genome.genes, newLink) then
		return
	end
	newLink.innovation = newInnovation()
	newLink.weight = math.random()*4-2
	
	table.insert(genome.genes, newLink)
end

function nodeMutate(genome)
	if #genome.genes == 0 then
		return
	end

	genome.maxneuron = genome.maxneuron + 1

	local gene = genome.genes[math.random(1,#genome.genes)]
	if not gene.enabled then
		return
	end
	gene.enabled = false
	
	local gene1 = copyGene(gene)
	gene1.out = genome.maxneuron
	gene1.weight = 1.0
	gene1.innovation = newInnovation()
	gene1.enabled = true
	table.insert(genome.genes, gene1)
	
	local gene2 = copyGene(gene)
	gene2.into = genome.maxneuron
	gene2.innovation = newInnovation()
	gene2.enabled = true
	table.insert(genome.genes, gene2)
end

function enableDisableMutate(genome, enable)
	local candidates = {}
	for _,gene in pairs(genome.genes) do
		if gene.enabled == not enable then
			table.insert(candidates, gene)
		end
	end
	
	if #candidates == 0 then
		return
	end
	
	local gene = candidates[math.random(1,#candidates)]
	gene.enabled = not gene.enabled
end

function mutate(genome)
	for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
			genome.mutationRates[mutation] = 0.95*rate
		else
			genome.mutationRates[mutation] = 1.05263*rate
		end
	end

	if math.random() < genome.mutationRates["connections"] then
		pointMutate(genome)
	end
	
	local p = genome.mutationRates["link"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, false)
		end
		p = p - 1
	end

	p = genome.mutationRates["bias"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, true)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["node"]
	while p > 0 do
		if math.random() < p then
			nodeMutate(genome)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["enable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, true)
		end
		p = p - 1
	end

	p = genome.mutationRates["disable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, false)
		end
		p = p - 1
	end
end

function disjoint(genes1, genes2)
	local i1 = {}
	for i = 1,#genes1 do
		local gene = genes1[i]
		i1[gene.innovation] = true
	end

	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = true
	end
	
	local disjointGenes = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if not i2[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	for i = 1,#genes2 do
		local gene = genes2[i]
		if not i1[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	local n = math.max(#genes1, #genes2)
	
	return disjointGenes / n
end

function weights(genes1, genes2)
	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = gene
	end

	local sum = 0
	local coincident = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if i2[gene.innovation] ~= nil then
			local gene2 = i2[gene.innovation]
			sum = sum + math.abs(gene.weight - gene2.weight)
			coincident = coincident + 1
		end
	end
	
	return sum / coincident
end
	
function sameSpecies(genome1, genome2)
	local dd = config.NeatConfig.DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
	local dw = config.NeatConfig.DeltaWeights*weights(genome1.genes, genome2.genes) 
	return dd + dw < config.NeatConfig.DeltaThreshold
end

function rankGlobally()
	local global = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		for g = 1,#species.genomes do
			table.insert(global, species.genomes[g])
		end
	end
	table.sort(global, function (a,b)
		return (a.fitness < b.fitness)
	end)
	
	for g=1,#global do
		global[g].globalRank = g
	end
end

function calculateAverageFitness(species)
	local total = 0
	
	for g=1,#species.genomes do
		local genome = species.genomes[g]
		total = total + genome.globalRank
	end
	
	species.averageFitness = total / #species.genomes
end

function totalAverageFitness()
	local total = 0
	for s = 1,#pool.species do
		local species = pool.species[s]
		total = total + species.averageFitness
	end

	return total
end

function cullSpecies(cutToOne)
	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		local remaining = math.ceil(#species.genomes/2)
		if cutToOne then
			remaining = 1
		end
		while #species.genomes > remaining do
			table.remove(species.genomes)
		end
	end
end

function breedChild(species)
	local child = {}
	if math.random() < config.NeatConfig.CrossoverChance then
		g1 = species.genomes[math.random(1, #species.genomes)]
		g2 = species.genomes[math.random(1, #species.genomes)]
		child = crossover(g1, g2)
	else
		g = species.genomes[math.random(1, #species.genomes)]
		child = copyGenome(g)
	end
	
	mutate(child)
	
	return child
end

function removeStaleSpecies()
	local survived = {}

	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		if species.genomes[1].fitness > species.topFitness then
			species.topFitness = species.genomes[1].fitness
			species.staleness = 0
		else
			species.staleness = species.staleness + 1
		end
		if species.staleness < config.NeatConfig.StaleSpecies or species.topFitness >= pool.maxFitness then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end

function removeWeakSpecies()
	local survived = {}

	local sum = totalAverageFitness()
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * config.NeatConfig.Population)
		if breed >= 1 then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end


function addToSpecies(child)
	local foundSpecies = false
	for s=1,#pool.species do
		local species = pool.species[s]
		if not foundSpecies and sameSpecies(child, species.genomes[1]) then
			table.insert(species.genomes, child)
			foundSpecies = true
		end
	end
	
	if not foundSpecies then
		local childSpecies = newSpecies()
		table.insert(childSpecies.genomes, child)
		table.insert(pool.species, childSpecies)
	end
end

function newGeneration()
	cullSpecies(false) -- Cull the bottom half of each species
	rankGlobally()
	removeStaleSpecies()
	rankGlobally()
	for s = 1,#pool.species do
		local species = pool.species[s]
		calculateAverageFitness(species)
	end
	removeWeakSpecies()
	local sum = totalAverageFitness()
	local children = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * config.NeatConfig.Population) - 1
		for i=1,breed do
			table.insert(children, breedChild(species))
		end
	end
	cullSpecies(true) -- Cull all but the top member of each species
	while #children + #pool.species < config.NeatConfig.Population do
		local species = pool.species[math.random(1, #pool.species)]
		table.insert(children, breedChild(species))
	end
	for c=1,#children do
		local child = children[c]
		addToSpecies(child)
	end
	
	pool.generation = pool.generation + 1
	
	--writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
	writeFile(forms.gettext(saveLoadFile) .. ".gen" .. pool.generation .. ".pool")
end
	
function initializePool()
	pool = newPool()

	for i=1,config.NeatConfig.Population do
		basic = basicGenome()
		addToSpecies(basic)
	end

	initializeRun()
end

function initializeRun()
	savestate.load(config.NeatConfig.Filename);
	rightmost = 0
	pool.currentFrame = 0
	timeout = config.NeatConfig.TimeoutConstant
	game.clearJoypad()
	startCoins = game.getCoins()
	startScore = game.getScore()
	checkMarioCollision = true
	marioHitCounter = 0
	
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	generateNetwork(genome)
	evaluateCurrent()
end

function evaluateCurrent()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]

	inputs = game.getInputs()
	controller = evaluateNetwork(genome.network, inputs)
	
	if controller["P1 Left"] and controller["P1 Right"] then
		controller["P1 Left"] = false
		controller["P1 Right"] = false
	end
	if controller["P1 Up"] and controller["P1 Down"] then
		controller["P1 Up"] = false
		controller["P1 Down"] = false
	end

	joypad.set(controller)
end

if pool == nil then
	initializePool()
end


function nextGenome()
	pool.currentGenome = pool.currentGenome + 1
	if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
		pool.currentGenome = 1
		pool.currentSpecies = pool.currentSpecies+1
		if pool.currentSpecies > #pool.species then
			newGeneration()
			pool.currentSpecies = 1
		end
	end
end

function fitnessAlreadyMeasured()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	return genome.fitness ~= 0
end

form = forms.newform(500, 500, "Mario-Neat")
netPicture = forms.pictureBox(form, 5, 250,470, 200)


--int forms.pictureBox(int formhandle, [int? x = null], [int? y = null], [int? width = null], [int? height = null]) 

function displayGenome(genome)
	forms.clear(netPicture,0x80808080)
	local network = genome.network
	local cells = {}
	local i = 1
	local cell = {}
	for dy=-config.BoxRadius,config.BoxRadius do
		for dx=-config.BoxRadius,config.BoxRadius do
			cell = {}
			cell.x = 50+5*dx
			cell.y = 70+5*dy
			cell.value = network.neurons[i].value
			cells[i] = cell
			i = i + 1
		end
	end
	local biasCell = {}
	biasCell.x = 80
	biasCell.y = 110
	biasCell.value = network.neurons[Inputs].value
	cells[Inputs] = biasCell
	
	for o = 1,Outputs do
		cell = {}
		cell.x = 220
		cell.y = 30 + 8 * o
		cell.value = network.neurons[config.NeatConfig.MaxNodes + o].value
		cells[config.NeatConfig.MaxNodes+o] = cell
		local color
		if cell.value > 0 then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		--gui.drawText(223, 24+8*o, config.ButtonNames[o], color, 9)
		forms.drawText(netPicture,223, 24+8*o, config.ButtonNames[o], color, 9)
	end
	
	for n,neuron in pairs(network.neurons) do
		cell = {}
		if n > Inputs and n <= config.NeatConfig.MaxNodes then
			cell.x = 140
			cell.y = 40
			cell.value = neuron.value
			cells[n] = cell
		end
	end
	
	for n=1,4 do
		for _,gene in pairs(genome.genes) do
			if gene.enabled then
				local c1 = cells[gene.into]
				local c2 = cells[gene.out]
				if gene.into > Inputs and gene.into <= config.NeatConfig.MaxNodes then
					c1.x = 0.75*c1.x + 0.25*c2.x
					if c1.x >= c2.x then
						c1.x = c1.x - 40
					end
					if c1.x < 90 then
						c1.x = 90
					end
					
					if c1.x > 220 then
						c1.x = 220
					end
					c1.y = 0.75*c1.y + 0.25*c2.y
					
				end
				if gene.out > Inputs and gene.out <= config.NeatConfig.MaxNodes then
					c2.x = 0.25*c1.x + 0.75*c2.x
					if c1.x >= c2.x then
						c2.x = c2.x + 40
					end
					if c2.x < 90 then
						c2.x = 90
					end
					if c2.x > 220 then
						c2.x = 220
					end
					c2.y = 0.25*c1.y + 0.75*c2.y
				end
			end
		end
	end
	
	--gui.drawBox(50-config.BoxRadius*5-3,70-config.BoxRadius*5-3,50+config.BoxRadius*5+2,70+config.BoxRadius*5+2,0xFF000000, 0x80808080)
	forms.drawBox(netPicture, 50-config.BoxRadius*5-3,70-config.BoxRadius*5-3,50+config.BoxRadius*5+2,70+config.BoxRadius*5+2,0xFF000000, 0x80808080)
	--oid forms.drawBox(int componenthandle, int x, int y, int x2, int y2, [color? line = null], [color? background = null]) 
	for n,cell in pairs(cells) do
		if n > Inputs or cell.value ~= 0 then
			local color = math.floor((cell.value+1)/2*256)
			if color > 255 then color = 255 end
			if color < 0 then color = 0 end
			local opacity = 0xFF000000
			if cell.value == 0 then
				opacity = 0x50000000
			end
			color = opacity + color*0x10000 + color*0x100 + color
			forms.drawBox(netPicture,cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
			--gui.drawBox(cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
		end
	end
	for _,gene in pairs(genome.genes) do
		if gene.enabled then
			local c1 = cells[gene.into]
			local c2 = cells[gene.out]
			local opacity = 0xA0000000
			if c1.value == 0 then
				opacity = 0x20000000
			end
			
			local color = 0x80-math.floor(math.abs(mathFunctions.sigmoid(gene.weight))*0x80)
			if gene.weight > 0 then 
				color = opacity + 0x8000 + 0x10000*color
			else
				color = opacity + 0x800000 + 0x100*color
			end
			--gui.drawLine(c1.x+1, c1.y, c2.x-3, c2.y, color)
			forms.drawLine(netPicture,c1.x+1, c1.y, c2.x-3, c2.y, color)
		end
	end
	
	--gui.drawBox(49,71,51,78,0x00000000,0x80FF0000)
	forms.drawBox(netPicture, 49,71,51,78,0x00000000,0x80FF0000)
	--if forms.ischecked(showMutationRates) then
		local pos = 100
		for mutation,rate in pairs(genome.mutationRates) do
			--gui.drawText(100, pos, mutation .. ": " .. rate, 0xFF000000, 10)
			forms.drawText(netPicture,100, pos, mutation .. ": " .. rate, 0xFF000000, 10)
			--forms.drawText(pictureBox,400,pos, mutation .. ": " .. rate)
			
			--void forms.drawText(int componenthandle, int x, int y, string message, [color? forecolor = null], [color? backcolor = null], [int? fontsize = null], [string fontfamily = null], [string fontstyle = null], [string horizalign = null], [string vertalign = null]) 

			pos = pos + 8
		end
	--end
	forms.refresh(netPicture)
end

function writeFile(filename)
        local file = io.open(filename, "w")
        file:write(pool.generation .. "\n")
        file:write(pool.maxFitness .. "\n")
        file:write(#pool.species .. "\n")
        for n,species in pairs(pool.species) do
                file:write(species.topFitness .. "\n")
                file:write(species.staleness .. "\n")
                file:write(#species.genomes .. "\n")
                for m,genome in pairs(species.genomes) do
                        file:write(genome.fitness .. "\n")
                        file:write(genome.maxneuron .. "\n")
                        for mutation,rate in pairs(genome.mutationRates) do
                                file:write(mutation .. "\n")
                                file:write(rate .. "\n")
                        end
                        file:write("done\n")
                        
                        file:write(#genome.genes .. "\n")
                        for l,gene in pairs(genome.genes) do
                                file:write(gene.into .. " ")
                                file:write(gene.out .. " ")
                                file:write(gene.weight .. " ")
                                file:write(gene.innovation .. " ")
                                if(gene.enabled) then
                                        file:write("1\n")
                                else
                                        file:write("0\n")
                                end
                        end
                end
        end
        file:close()
end

function savePool()
	local filename = forms.gettext(saveLoadFile)
	print(filename)
	writeFile(filename)
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function loadFile(filename)
		print("Loading pool from " .. filename)
        local file = io.open(filename, "r")
        pool = newPool()
        pool.generation = file:read("*number")
        pool.maxFitness = file:read("*number")
        forms.settext(MaxLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
        local numSpecies = file:read("*number")
        for s=1,numSpecies do
                local species = newSpecies()
                table.insert(pool.species, species)
                species.topFitness = file:read("*number")
                species.staleness = file:read("*number")
                local numGenomes = file:read("*number")
                for g=1,numGenomes do
                        local genome = newGenome()
                        table.insert(species.genomes, genome)
                        genome.fitness = file:read("*number")
                        genome.maxneuron = file:read("*number")
                        local line = file:read("*line")
                        while line ~= "done" do

                                genome.mutationRates[line] = file:read("*number")
                                line = file:read("*line")
                        end
                        local numGenes = file:read("*number")
                        for n=1,numGenes do

                                local gene = newGene()
                                local enabled
								
								local geneStr = file:read("*line")
								local geneArr = mysplit(geneStr)
								gene.into = tonumber(geneArr[1])
								gene.out = tonumber(geneArr[2])
								gene.weight = tonumber(geneArr[3])
								gene.innovation = tonumber(geneArr[4])
								enabled = tonumber(geneArr[5])


                                if enabled == 0 then
                                        gene.enabled = false
                                else
                                        gene.enabled = true
                                end
                                
								table.insert(genome.genes, gene)
                        end
                end
        end
        file:close()
        
        while fitnessAlreadyMeasured() do
                nextGenome()
        end
        initializeRun()
        pool.currentFrame = pool.currentFrame + 1
		print("Pool loaded.")
end

function flipState()
	if config.Running == true then
		config.Running = false
		forms.settext(startButton, "Start")
	else
		config.Running = true
		forms.settext(startButton, "Stop")
	end
end
 
function loadPool()
	filename = forms.openfile("DonutPlains1.state.pool","C:\Users\mmill\Downloads\BizHawk-2.2\Lua\SNES\neat-mario\pool") 
	--local filename = forms.gettext(saveLoadFile)
	forms.settext(saveLoadFile, filename)
	loadFile(filename)
end

function playTop()
	local maxfitness = 0
	local maxs, maxg
	for s,species in pairs(pool.species) do
		for g,genome in pairs(species.genomes) do
			if genome.fitness > maxfitness then
				maxfitness = genome.fitness
				maxs = s
				maxg = g
			end
		end
	end
	
	pool.currentSpecies = maxs
	pool.currentGenome = maxg
	pool.maxFitness = maxfitness
	forms.settext(MaxLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	initializeRun()
	pool.currentFrame = pool.currentFrame + 1
	return
end

function onExit()
	forms.destroy(form)
end

writeFile("C:/Users/mmill/Downloads/BizHawk-2.2/Lua/SNES/neat-mario/pool/temp.pool")

event.onexit(onExit)

GenerationLabel = forms.label(form, "Generation: " .. pool.generation, 5, 5)
SpeciesLabel = forms.label(form, "Species: " .. pool.currentSpecies, 130, 5)
GenomeLabel = forms.label(form, "Genome: " .. pool.currentGenome, 230, 5)
MeasuredLabel = forms.label(form, "Measured: " .. "", 330, 5)

FitnessLabel = forms.label(form, "Fitness: " .. "", 5, 30)
MaxLabel = forms.label(form, "Maximum: " .. "", 130, 30)

CoinsLabel = forms.label(form, "Coins: " .. "", 5, 65)
ScoreLabel = forms.label(form, "Score: " .. "", 130, 65)
DmgLabel = forms.label(form, "Damage: " .. "", 230, 65)

startButton = forms.button(form, "Start", flipState, 155, 102)

restartButton = forms.button(form, "Restart", initializePool, 155, 102)
saveButton = forms.button(form, "Save", savePool, 5, 102)
loadButton = forms.button(form, "Load", loadPool, 80, 102)
playTopButton = forms.button(form, "Play Top", playTop, 230, 102)

saveLoadFile = forms.textbox(form, config.NeatConfig.Filename .. ".pool", 170, 25, nil, 5, 148)
saveLoadLabel = forms.label(form, "Save/Load:", 5, 129)

while true do
	
	if config.Running == true then

	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	displayGenome(genome)
	
	if pool.currentFrame%5 == 0 then
		evaluateCurrent()
	end

	joypad.set(controller)

	game.getPositions()
	if marioX > rightmost then
		rightmost = marioX
		timeout = config.NeatConfig.TimeoutConstant
	end
	
	local hitTimer = game.getMarioHitTimer()
	
	if checkMarioCollision == true then
		if hitTimer > 0 then
			marioHitCounter = marioHitCounter + 1
			console.writeline("Mario took damage, hit counter: " .. marioHitCounter)
			checkMarioCollision = false
		end
	end
	
	if hitTimer == 0 then
		checkMarioCollision = true
	end
	
	timeout = timeout - 1
	
	local timeoutBonus = pool.currentFrame / 4
	if timeout + timeoutBonus <= 0 then
	
		local coins = game.getCoins() - startCoins
		local score = game.getScore() - startScore
		
		console.writeline("Coins: " .. coins .. " score: " .. score)

		local coinScoreFitness = (coins * 50) + (score * 0.2)
		if (coins + score) > 0 then 
			console.writeline("Coins and Score added " .. coinScoreFitness .. " fitness")
		end
		
		local hitPenalty = marioHitCounter * 200
		
		local fitness = coinScoreFitness - hitPenalty + rightmost - pool.currentFrame / 2
		if rightmost > 4816 then
			fitness = fitness + 1000
			console.writeline("!!!!!!Beat level!!!!!!!")
		end
		if fitness == 0 then
			fitness = -1
		end
		genome.fitness = fitness
		
		if fitness > pool.maxFitness then
			pool.maxFitness = fitness
			--writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
			writeFile(forms.gettext(saveLoadFile) .. ".gen" .. pool.generation .. ".pool")
		end
		
		console.writeline("Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness)
		pool.currentSpecies = 1
		pool.currentGenome = 1
		while fitnessAlreadyMeasured() do
			nextGenome()
		end
		initializeRun()
	end

	local measured = 0
	local total = 0
	for _,species in pairs(pool.species) do
		for _,genome in pairs(species.genomes) do
			total = total + 1
			if genome.fitness ~= 0 then
				measured = measured + 1
			end
		end
	end
	
	forms.settext(FitnessLabel, "Fitness: " .. math.floor(rightmost - (pool.currentFrame) / 2 - (timeout + timeoutBonus)*2/3))
	forms.settext(GenerationLabel, "Generation: " .. pool.generation)
	forms.settext(SpeciesLabel, "Species: " .. pool.currentSpecies)
	forms.settext(GenomeLabel, "Genome: " .. pool.currentGenome)
	forms.settext(MaxLabel, "Maximum: " .. math.floor(pool.maxFitness))
	forms.settext(MeasuredLabel, "Measured: " .. math.floor(measured/total*100) .. "%")
	forms.settext(CoinsLabel, "Coins: " .. (game.getCoins() - startCoins))
	forms.settext(ScoreLabel, "Score: " .. (game.getScore() - startScore))
	forms.settext(DmgLabel, "Damage: " .. marioHitCounter)

	pool.currentFrame = pool.currentFrame + 1
	
	end
	emu.frameadvance();
	
end