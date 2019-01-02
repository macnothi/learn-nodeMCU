-- wifi Anmeldung und event handling   
-- connect to Access Point (DO NOT save config to flash)
sta_cfg={}
sta_cfg.ssid="STICK"
sta_cfg.pwd="hfgrt875656FGJDZEHori85"
sta_cfg.save=false
wifi.sta.config(sta_cfg)

-- connect to AP
wifi.sta.autoconnect(1)

-- register wifi events
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\tChannel: "..T.channel)
    end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
    print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
    print(T)
    end)
   
wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
    print("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode)
    end)
   
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
    end)
   
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
    print("\n\tSTA - DHCP TIMEOUT")
    end)
