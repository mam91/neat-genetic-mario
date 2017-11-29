--Notes here

local _M = {}

function _M.sigmoid(x)
	return 2/(1+math.exp(-4.9*x))-1
end

function _M.squashDistance(x)
	local window = 0.20
	local delta = 0.25
	
	local dist = (x-8)
	local newDist = 1
	
	while dist > 0 do
		newDist = newDist - (window*delta)
		dist = dist - 1
	end
	
	if newDist < 0.80 then
		newDist = 0.80
	end
	
	return newDist
end


return _M