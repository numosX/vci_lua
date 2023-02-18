local pulse_clock = function(self)
    t = os.clock()
    a = self._high_time
    b = self._low_time
    f = math.floor( (t+a+b)/(a+b) )
    g = math.floor( (t+b)/(a+b) )
    return f - g
end

local pulse_clock_low_start = function(self)
    t = os.clock()
    a = self._high_time
    b = self._low_time
    f = math.floor( (t+a)/(a+b) )
    g = math.floor( t/(a+b) )
    return f - g
end

local saw_clock = function(self)
    t = os.clock()
    f = self._frequency
    return f * t - math.floor(f * t)
end

local select_clock = function(self, clock_name)
    if      clock_name == "pulse"           then self._clock_func = pulse_clock
    elseif  clock_name == "pulse_low_start" then self._clock_func = pulse_clock_low_start
    elseif  clock_name == "saw"             then self._clock_func = saw_clock
    else
        print("select a clock name below:")
        print("* pulse")
        print("* pulse_low_start")
        print("* saw")
    end
end

---------

local set_threshold = function(self, th)
    self._threshold = th
end

local set_high_time = function(self, tt)
    self._high_time = tt
end

local set_low_time = function(self, tt)
    self._low_time = tt
end

local set_frequency = function(self, ff)
    self._frequency = ff
end

---------

local get_clock = function(self)
    return self:_clock_func()
end

local is_rising = function(self)
    t1 = self:get_clock()
    if (self._t0 - self._threshold <= 0) and (t1 - self._threshold > 0) then
        self._t0 = t1
        return true
    end
    self._t0 = t1
end

local is_falling = function(self)
    t1 = self:get_clock()
    if (self._t0 - self._threshold >= 0) and (t1 - self._threshold < 0) then
        self._t0 = t1
        return true
    end
    self._t0 = t1
end

local member_functions = {
    get_clock       = get_clock,
    is_rising       = is_rising,
    is_falling      = is_falling,
    set_threshold   = set_threshold,
    set_high_time   = set_high_time,
    set_low_time    = set_low_time,
    set_frequency   = set_frequency,
    select_clock    = select_clock,
    _clock_func     = pulse_clock,
}

local new = function()
    local self = {}
    local member_params = {
        _t0         = 0,
        _threshold  = 0.5,
        _frequency  = 1,
        _high_time  = 0.5,
        _low_time   = 0.5,
    }
    setmetatable(self, {__index = member_params})
    setmetatable(member_params, {__index = member_functions})
    return self
end

return {
    new = new
}