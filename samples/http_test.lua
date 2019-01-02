-- simple http control of an output...
-- see https://github.com/nodemcu/nodemcu-firmware/blob/master/lua_examples/webap_toggle_pin.lua

webPin=7 -- connect LED for http control to nodeMCU PIN3
gpio.mode(webPin, gpio.OUTPUT)

srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
  conn:on("receive", function(client, request)
    print("inside receive ...")
    
    --tmrDataLoop:stop()
    --dataLoop()

    local buf = ""
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
    if (method == nil) then
      _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
    end
    local _GET = {}
    if (vars ~= nil) then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end
    
    buf = buf .. "<!DOCTYPE html><html><head><title>NodeMCU1 Data</title></head><body><h1>Daten vom NodeMCU.</h1>"
    buf = buf .. "<form src=\"/\">LED an PIN7 schalten :<select name=\"pin\" onchange=\"form.submit()\">"
    
    local _on, _off = "", ""
    if (_GET.pin == "ON") then
      _on = " selected=true"
      gpio.write(webPin, gpio.HIGH)
    elseif (_GET.pin == "OFF") then
      _off = " selected=\"true\""
      gpio.write(webPin, gpio.LOW)
    end
    
    buf = buf .. "<option" .. _on .. ">ON</option><option" .. _off .. ">OFF</option></select></form>"
    buf = buf .. "<p>" .. tempStr .. "</p>" .. "<p>" .. humiStr .. "</p>" .. "<p>" .. butStr .. "</p>" 
    buf = buf .. "</body></html>"
    
    client:send(buf)
  end)
  conn:on("sent", function(c) c:close() end)
end)
