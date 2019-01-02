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
dofile("application.lc")

--]]

dofile("hw_setup.lua")
dofile("wifi_setup.lua")
dofile("i2c_setup.lua")
dofile("application.lua")