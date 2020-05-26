-- global variables
relayPin = 1 -- heating relay @ PIN5
dataCycle = 1000 -- read data cycle 1000ms

-- hardware initialisation
gpio.mode(relayPin, gpio.OUTPUT)
gpio.write(relayPin, gpio.LOW)

toggle = false

function updateData()

    if toggle then
        toggle=false
        gpio.write(relayPin, gpio.HIGH)
    else
        toggle=true
        gpio.write(relayPin, gpio.LOW)
    end

    tmrDataLoop:start()
end

-- timer update data from DHT22 
tmrDataLoop = tmr.create()
tmrDataLoop:register(dataCycle, tmr.ALARM_SEMI, updateData)
tmrDataLoop:start()