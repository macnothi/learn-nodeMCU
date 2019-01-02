-- global variables
dataCycle = 10000 -- read data cycle 10000ms
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
        -- push value to broker ... (only when changed?)
        if mqttIsConnected then
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

    if wifi.sta.getip() == nil then
      disp:drawStr(10, 50, "not connected ...")
    else
      disp:drawStr(10, 50, string.format("IP : %s",wifi.sta.getip()))
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

-- initial data sampling and screen setup
buttonPressed=gpio.read(butPin)
updateData()
