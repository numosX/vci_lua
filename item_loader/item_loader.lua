local add = function(self, basename, number_of_obj)
	for i=0, number_of_obj - 1 do
		local item_name   = string.format("%s%d",basename, i)
		local obj = vci.assets.GetTransform(item_name)
		self._items[ #self._items + 1] = obj 
	end
end

local increase_index = function(self)
	self._index = self._index + 1
	if self._index > #self._items then
		self._index = 1
	end
end

local get = function(self)
	self:increase_index()
	local obj		= self._items[self._index]
	return obj
end

local get_index = function(self)
	return self._index
end

local methods = {
	add = add,
	increase_index = increase_index,
	get = get,
	get_index = get_index,
}

local new = function(self)
	local __member_params = {
		_index = 0,
		_items = {}
	}
	return setmetatable(__member_params, {__index = methods})
end

return {
	new = new
}