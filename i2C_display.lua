-- reads temperature and humidity from DHT22 and display on SSD1306 display (128x64)
-- requires nodeMCU with (float) firmware options DHT, I2C, U8G2 ...
-- jno 30/12/2018

ledPin=3 -- connect LED for life sign to nodeMCU PIN3
butPin=6 -- connect button to nodeMCU PIN3
dhtPin=5 -- connect DHT data to nodeMCU PIN5 

tempStr=""
humiStr=""

dataCycle=5000 -- read data cycle 5000ms
dispCycle=200  -- dsplay update cycle 200ms

buttonPressed = 1 -- assume, button not pressed

-- setup I2c and connect display
function init_i2c_display()
  -- SDA and SCL can be assigned freely to available GPIOs
  local id  = 0
  local sda = 1
  local scl = 2
  local sla = 0x3c
  i2c.setup(id, sda, scl, i2c.SLOW)
  disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
end

-- prepare display
function u8g2_prepare()
  disp:setFont(u8g2.font_6x10_tf)
  disp:setFontRefHeightExtendedText()
  disp:setDrawColor(1)
  disp:setFontPosTop()
  disp:setFontDirection(0)
end

function dataLoop()
  -- reads and returns data from DHT22
  
  local status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
  if status == dht.OK then
     -- this only works with float firmware ...
        tempStr = string.format("Temperatur: %.1f%sC",temp,string.char(176))
        humiStr = string.format("Feuchte   : %.1f%s",humi,"%")
  else
        tempStr = "Error reading from DHT22"
        if status == dht.ERROR_TIMEOUT then
            humiStr = "DHT timed out."
        else
            humiStr = "DHT Checksum error."
        end
  end
  --print(tempStr, humiStr)
  
  tmrDataLoop:start()
end

-- update data and send it to display
function displayLoop()
  -- picture loop  
  disp:clearBuffer()

  disp:drawStr(10, 10, tempStr)
  disp:drawStr(10, 20, humiStr)
  --disp:drawBox(10, 30, draw_state,5)
  
  if buttonPressed == 1 then
        butStr = "Taster    : AUS"
  else
        butStr = "Taster    : EIN"
  end
  disp:drawStr(10, 30, butStr)
  
  disp:sendBuffer()

  -- increase the state
  draw_state = draw_state + dataCycle/dispCycle
  if draw_state > 117 then
    draw_state = 0
  end

  -- restart display update loop
  tmrDisplayLoop:start()

end

init_i2c_display()
u8g2_prepare()

-- update data loop from DHT22 
tmrDataLoop = tmr.create()
tmrDataLoop:register(dataCycle, tmr.ALARM_SEMI, dataLoop)
dataLoop()

-- show data loop on display
draw_state = 0
tmrDisplayLoop = tmr.create()
tmrDisplayLoop:register(dispCycle, tmr.ALARM_SEMI, displayLoop)
--displayLoop()

-- handle button interrupt
gpio.mode(ledPin, gpio.OUTPUT)
gpio.write(ledPin, gpio.LOW)
gpio.mode(butPin,gpio.INPUT, gpio.PULLUP)

function butInterrupt()
    -- read button status
    buttonPressed=gpio.read(butPin)
    if buttonPressed == 1 then
        gpio.write(ledPin, gpio.LOW)
    else
        gpio.write(ledPin, gpio.HIGH)
    end

    -- stop display loop timer
    tmrDisplayLoop:stop()
    displayLoop()    
end

gpio.trig(butPin, "both" , butInterrupt)
butInterrupt()