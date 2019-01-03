-- kudos to Marcos Kirsch ...

-- compiles an existing lua file to lc code,
-- then deletes the lua file
local compileAndRemoveIfNeeded = function(f)
    if file.exists(f) then
       print('Compiling:', f)
       node.compile(f)
       file.remove(f)
       collectgarbage()
    end
 end
 
 -- list of lua files that may exist
 local luaFiles = {
   'application.lua',
   'hw_setup.lua',
   'i2c_setup.lua',
   'mqtt_client.lua',
   'wifi_setup.lua'
 }
 -- work off the list ...
 for i, f in ipairs(luaFiles) do compileAndRemoveIfNeeded(f) end
 
 -- clean up the mess
 compileAndRemoveIfNeeded = nil
 luaFiles = nil
 collectgarbage()