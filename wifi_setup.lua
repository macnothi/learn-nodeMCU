-- wifi configuration   
sta_cfg={}
sta_cfg.ssid="STICK"
sta_cfg.pwd="hfgrt875656FGJDZEHori85"
sta_cfg.save=false
wifi.sta.config(sta_cfg)

-- connect to AP
wifi.sta.autoconnect(1)

-- register wifi events
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
    print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
    -- stop wifi services
    -- updateDisplay()
    end)
   
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
    print("\n\tSTA - DHCP TIMEOUT")
    -- connection not possible...
    end)

-- from here wifi depending services are possible ...
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
    -- updateDisplay()
    subscribe(mqttClient)
    end)