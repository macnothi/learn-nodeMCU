--[[ STATION MODE
wifi.setmode(wifi.STATION)
--]]

--[[ set host name
if (wifi.sta.sethostname("NodeMCU1") == true) then
    print("hostname was successfully changed")
else
    print("hostname was not changed")
end
--]]

--[ 
-- connect to Access Point (DO NOT save config to flash)
station_cfg={}
station_cfg.ssid="STICK"
station_cfg.pwd="hfgrt875656FGJDZEHori85"
station_cfg.save=false
wifi.sta.config(station_cfg)

-- connect to AP
wifi.sta.connect() 

tmr.alarm(1, 2000, 1, function()
    if wifi.sta.getip() == nil then
        print("IP unavailable, Waiting...")
    else
        tmr.stop(1)
        print("ESP8266 mode is: " .. wifi.getmode())
        print("The module MAC address is: " .. wifi.ap.getmac())
        print("Config done, IP is "..wifi.sta.getip())
    end
end)
--]]

--[
-- call data and display update cycles
dofile("i2C_display.lua")
