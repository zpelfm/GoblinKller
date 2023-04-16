function findKey(tab, val)
    for key, value in next, tab do if (value == val) then return key end end
end

function copy(original)
	local c = {}
	for key, value in pairs(original) do
		c[key] = value
	end
	return c
end


function Debug()
  debug_keyboard()
end

require 'system.attack'
require 'system.keyboard'
require 'system.state'
