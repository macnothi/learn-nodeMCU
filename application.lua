-- global variables
dataCycle = 30000 -- read data cycle 30000ms
firstCycle = 2000 -- delay first data cycle after system reset
temperature = 0.0
humidity = 0.0
dataError = 0
errMsg = ""
buttonPressed = 1

-- read data from sensors
function updateData()
    
    -- read from DHT22 sensor (temperature / humidity)
    local status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
    if status == dht.OK then
        dataError = 0
        -- this only works with float firmware ...
        temperature = temp
        humidity = humi
        -- push new values to broker ... (only when changed?)
        if mqttIsConnected == 1 then
            publish(mqttClient)
        end

    elseif status == dht.ERROR_TIMEOUT then
        dataError = 1
        errMsg = "DHT22 time out error"

    elseif status == dht.ERROR_CHECKSUM then
        dataError = 1
        errMsg = "DHT22 checksum error"     
          
    end
   
    -- update display data 
    updateDisplay()
    
    tmrDataLoop:start()
end
  
-- update data shown on display
function updateDisplay()

    disp:clearBuffer()
  
    if dataError == 1 then
        disp:drawStr(10, 10, "Data reading error")
        disp:drawStr(10, 20, errMsg)       
    else
        disp:drawStr(10, 10, string.format("Temperatur: %.1f%sC",temperature,string.char(176)))
        disp:drawStr(10, 20, string.format("Feuchte   : %.1f%s",humidity,"%"))
    end
        
    if buttonPressed == 1 then
          butStr = "Taster    : AUS"
    else
          butStr = "Taster    : EIN"
    end
    disp:drawStr(10, 30, butStr)
    
    if gpio.read(webPin) == 1 then
        disp:drawStr(10, 40, "LED (gn)  : EIN")
    else
        disp:drawStr(10, 40, "LED (gn)  : AUS")
    end

    if mqttIsConnected == 0 then
      disp:drawStr(10, 50, "MQTT      : offline")
    else
      disp:drawStr(10, 50, "MQTT      : online")
    end
  
    disp:sendBuffer()
  
end

function trigButton()
    -- read button status
    buttonPressed=gpio.read(butPin)
    if buttonPressed == 1 then
        gpio.write(ledPin, gpio.LOW)
    else
        gpio.write(ledPin, gpio.HIGH)
    end

    -- push value to broker ... (only when changed?)
    -- publish(mqttClient)
    
    -- update display data 
    updateDisplay()   
end

-- timer update data from DHT22 
tmrDataLoop = tmr.create()
tmrDataLoop:register(dataCycle, tmr.ALARM_SEMI, updateData)
 
-- register trigger for button changes
gpio.trig(butPin, "both" , trigButton)

-- seems we have to delay the first data sampling after reset,
-- reason (guess) DHT22 system needs time to be ready,
-- started to happen, after compiling the lua scripts :-)
tmrFirstCycle = tmr.create()
tmrFirstCycle:register(firstCycle, tmr.ALARM_SINGLE, function()
        -- initial data sampling and screen setup
        buttonPressed=gpio.read(butPin)
        updateData()
    end)
tmrFirstCycle:start()
