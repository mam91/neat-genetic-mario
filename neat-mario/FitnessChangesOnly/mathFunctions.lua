--Notes here

local _M = {}

function _M.sigmoid(x)
	return 2/(1+math.exp(-4.9*x))-1
end

return _M