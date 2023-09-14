--Notes here
config = require "config"
spritelist = require "spritelist"

local _M = {}
memory.usememorydomain("WRAM")

function _M.getPositions()
	marioX = memory.read_s16_le(0x94)
	marioY = memory.read_s16_le(0x96)
		
	local layer1x = memory.read_s16_le(0x1A);
	local layer1y = memory.read_s16_le(0x1C);
		
	_M.screenX = marioX-layer1x
	_M.screenY = marioY-layer1y
end

function _M.getCoins()
	local coins = memory.readbyte(0x0DBF)
	return coins
end

function _M.getScore()
	local scoreLeft = memory.read_s16_le(0x0F34)
	local scoreRight = memory.read_s16_le(0x0F36)
	local score = ( scoreLeft * 10 ) + scoreRight
	return score
end

function _M.getLives()
	local lives = memory.readbyte(0x0DBE) + 1
	return lives
end

function _M.writeLives(lives)
	memory.writebyte(0x0DBE, lives - 1)
end

function _M.getPowerup()
	local powerup = memory.readbyte(0x0019)
	return powerup
end

function _M.writePowerup(powerup)
	memory.writebyte(0x0019, powerup)
end


function _M.getMarioHit(alreadyHit)
	local timer = memory.readbyte(0x1497)
	if timer > 0 then
		if alreadyHit == false then
			return true
		else
			return false
		end
	else
		return false
	end
end

function _M.getMarioHitTimer()
	local timer = memory.readbyte(0x1497)
	return timer
end

function _M.getTile(dx, dy)
	x = math.floor((marioX+dx+8)/16)
	y = math.floor((marioY+dy)/16)
	
	tile = memory.readbyte(0x1C800 + math.floor(x/0x10)*0x1B0 + y*0x10 + x%0x10)
	return tile
end


function _M.getSprites()
	local sprites = {}
	for slot=0,11 do
		local status = memory.readbyte(0x14C8+slot)
		if status ~= 0 then
			spritex = memory.readbyte(0xE4+slot) + memory.readbyte(0x14E0+slot)*256
			spritey = memory.readbyte(0xD8+slot) + memory.readbyte(0x14D4+slot)*256
			sprites[#sprites+1] = {["x"]=spritex, ["y"]=spritey, ["good"] = spritelist.Sprites[memory.readbyte(0x009e + slot) + 1]}
		end
	end		
		
	return sprites
end

function _M.getExtendedSprites()
	local extended = {}
	for slot=0,11 do
		local number = memory.readbyte(0x170B+slot)
		if number ~= 0 then
			spritex = memory.readbyte(0x171F+slot) + memory.readbyte(0x1733+slot)*256
			spritey = memory.readbyte(0x1715+slot) + memory.readbyte(0x1729+slot)*256
			extended[#extended+1] = {["x"]=spritex, ["y"]=spritey, ["good"]  =  spritelist.extSprites[memory.readbyte(0x170B + slot) + 1]}
		end
	end		
		
	return extended
end

--[[
function _M.getSprites()
        if gameinfo.getromname() == "Super Mario World (USA)" then
                local sprites = {}
                for slot=0,11 do
                        local status = memory.readbyte(0x14C8+slot)
                        if status ~= 0 then
                                spritex = memory.readbyte(0xE4+slot) + memory.readbyte(0x14E0+slot)*256
                                spritey = memory.readbyte(0xD8+slot) + memory.readbyte(0x14D4+slot)*256
                                sprites[#sprites+1] = {["x"]=spritex, ["y"]=spritey}
                        end
                end            
               
                return sprites
        elseif gameinfo.getromname() == "Super Mario Bros." then
                local sprites = {}
                for slot=0,4 do
                        local enemy = memory.readbyte(0xF+slot)
                        if enemy ~= 0 then
                                local ex = memory.readbyte(0x6E + slot)*0x100 + memory.readbyte(0x87+slot)
                                local ey = memory.readbyte(0xCF + slot)+24
                                sprites[#sprites+1] = {["x"]=ex,["y"]=ey}
                        end
                end
               
                return sprites
        end
end
 
function _M.getExtendedSprites()
        if gameinfo.getromname() == "Super Mario World (USA)" then
                local extended = {}
                for slot=0,11 do
                        local number = memory.readbyte(0x170B+slot)
                        if number ~= 0 then
                                spritex = memory.readbyte(0x171F+slot) + memory.readbyte(0x1733+slot)*256
                                spritey = memory.readbyte(0x1715+slot) + memory.readbyte(0x1729+slot)*256
                                extended[#extended+1] = {["x"]=spritex, ["y"]=spritey}
                        end
                end            
               
                return extended
        elseif gameinfo.getromname() == "Super Mario Bros." then
                return {}
        end
end
--]]
function _M.getInputs()
	_M.getPositions()
	
	sprites = _M.getSprites()
	extended = _M.getExtendedSprites()
	
	local inputs = {}
	local inputDeltaDistance = {}
	
	local layer1x = memory.read_s16_le(0x1A);
	local layer1y = memory.read_s16_le(0x1C);
	
	for dy=-config.BoxRadius*16,config.BoxRadius*16,16 do
		for dx=-config.BoxRadius*16,config.BoxRadius*16,16 do
			inputs[#inputs+1] = 0
			inputDeltaDistance[#inputDeltaDistance+1] = 1
			
			tile = _M.getTile(dx, dy)
			if tile == 0x1 and marioY+dy < 0x1B0 then
				inputs[#inputs] = 1
			end
			
			
			for i = 1,#sprites do
				distx = math.abs(sprites[i]["x"] - (marioX+dx))
				disty = math.abs(sprites[i]["y"] - (marioY+dy))
				if distx <= 8 and disty <= 8 then
					inputs[#inputs] = sprites[i]["good"]
					
					local dist = math.sqrt((distx * distx) + (disty * disty))
					if dist > 8 then
						inputDeltaDistance[#inputDeltaDistance] = mathFunctions.squashDistance(dist)
						--gui.drawLine(screenX, screenY, sprites[i]["x"] - layer1x, sprites[i]["y"] - layer1y, 0x50000000)
					end
				end
			end

			for i = 1,#extended do
				distx = math.abs(extended[i]["x"] - (marioX+dx))
				disty = math.abs(extended[i]["y"] - (marioY+dy))
				if distx < 8 and disty < 8 then
					
					--console.writeline(screenX .. "," .. screenY .. " to " .. extended[i]["x"]-layer1x .. "," .. extended[i]["y"]-layer1y) 
					inputs[#inputs] = extended[i]["good"]
					local dist = math.sqrt((distx * distx) + (disty * disty))
					if dist > 8 then
						inputDeltaDistance[#inputDeltaDistance] = mathFunctions.squashDistance(dist)
						--gui.drawLine(screenX, screenY, extended[i]["x"] - layer1x, extended[i]["y"] - layer1y, 0x50000000)
					end
					--if dist > 100 then
						--dw = mathFunctions.squashDistance(dist)
						--console.writeline(dist .. " to " .. dw)
						--gui.drawLine(screenX, screenY, extended[i]["x"] - layer1x, extended[i]["y"] - layer1y, 0x50000000)
					--end
					--inputs[#inputs] = {["value"]=-1, ["dw"]=dw}
				end
			end
		end
	end
	
	return inputs, inputDeltaDistance
end

function _M.clearJoypad()
	controller = {}
	for b = 1,#config.ButtonNames do
		controller["P1 " .. config.ButtonNames[b]] = false
	end
	joypad.set(controller)
end

return _M
