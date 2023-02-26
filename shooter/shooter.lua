local set_ballet = function(self, obj)
    self._ballet = obj
end

local shot = function(self)
    self:set_position()
    self:set_velocity()
end

local set_position = function(self)
    self._ballet.SetPosition(self._shot_origin.GetPosition())
end

local set_velocity = function(self)
    self._ballet.SetVelocity(self._shot_origin.GetForward() * self._velocity)
end

local set_shot_origin = function(self, obj)
    self._shot_origin = obj
end

local public_fuctions = {
    set_shot_origin = set_shot_origin,
    set_ballet = load_ballet,
    shot = shot,
    set_position = set_position,
    set_velocity = set_velocity,
}

local new = function(self)
    local _member_params = {
        _origin_item = nil,
        _velocity  = 100
    }
    return setmetatable(_member_params, {__index = public_fuctions})
end

return {
    new = new
}