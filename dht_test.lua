-- DHT22 Test
dhtPin=5

function readDHT22(PIN)
   -- read data from DHT22
   --print(PIN)
    status, temp, humi, temp_dec, humi_dec = dht.read(PIN)
    if status == dht.OK then
        percent='%'
        -- this only works with float firmware ...
        return string.format("DHT Temperature: %.2f°C; Humidity: %.2f%s",temp,humi,"%")
    elseif status == dht.ERROR_CHECKSUM then
        return "DHT Checksum error."
    elseif status == dht.ERROR_TIMEOUT then
        return "DHT timed out."
    end
end

print(readDHT22(dhtPin))

local t1 = tmr.create()
t1:register(5000, tmr.ALARM_AUTO, function (t) print(readDHT22(5)) end)
t1:start()
--tmr.alarm (1, 5000, tmr.ALARM_AUTO, function () print(readDHT22(5)) end)