lighton=0
pin=3

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)


local t2 = tmr.create()
t2:register(1000, tmr.ALARM_AUTO, function (t) 
    lighton=gpio.read(pin)
    if lighton == gpio.HIGH then
        gpio.write(pin, gpio.LOW)
    else
        gpio.write(pin, gpio.HIGH)
    end
    end)
    
t2:start()

--[[
tmr.alarm (0, 1000, tmr.ALARM_AUTO, function ( )
    lighton=gpio.read(pin)
    if lighton == gpio.HIGH then
        gpio.write(pin, gpio.LOW)
    else
        gpio.write(pin, gpio.HIGH)
    end
    end)
--]]
