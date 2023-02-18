Clock = require("clock")
clock = Clock:new()
clock:set_threshold(0.50)

clock:select_clock("pulse")
clock:set_high_time(1.2)
clock:set_low_time(2.8)

-- test functions

function sleep(s)
    local t0 = os.clock()
    while os.clock() - t0 <= s do end
end

function detect_rising()
    while(true)
    do
        if clock:is_rising() then
            print(os.clock() .. " rising")
            break
        end
    end
end

function detect_falling()
    while(true)
    do
        if clock:is_falling() then
            print(os.clock() .. " falling")
            break
        end
    end
end

-- tests
function test0()
    print("* using clock")
    for i=0, 5, 1
    do
        detect_rising()
        detect_falling()
    end
end

function test1()
    print("* using sleep")
    for i=0, 5, 1
    do
        sleep(1.2)
        print(os.clock() .. " rising")
        sleep(2.8)
        print(os.clock() .. " falling")
    end
end

test0()
test1()