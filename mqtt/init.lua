--[[
-- Compile freshly uploaded nodemcu lua files.
if file.exists("nodemcu-compile.lc") then
    dofile("nodemcu-compile.lc")
 else
    dofile("nodemcu-compile.lua")
 end
 
dofile("hw_setup.lc")
dofile("wifi_setup.lc")
dofile("i2c_setup.lc")
dofile("mqtt_client.lc")
dofile("application.lc")
--]]

--[
dofile("wifi_setup.lua")
dofile("mqtt_client.lua")
--]]
