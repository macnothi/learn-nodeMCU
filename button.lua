ledPin=3 -- connect LED for life sign to nodeMCU PIN3
butPin=6 -- connect button to nodeMCU PIN3
dhtPin=5 -- connect DHT data to nodeMCU PIN5 
lighton=0

-- read pin status
gpio.mode(ledPin, gpio.OUTPUT)
gpio.write(ledPin, gpio.LOW)
gpio.mode(butPin,gpio.INPUT, gpio.PULLUP)

function butInterrupt()
    buttonPressed=gpio.read(butPin)
    if buttonPressed == 1 then
        gpio.write(ledPin, gpio.LOW)
    else
        gpio.write(ledPin, gpio.HIGH)
    end
end

gpio.trig(butPin, "both" , butInterrupt)
