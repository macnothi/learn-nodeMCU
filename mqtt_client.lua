-- MQTT Protokoll mit adafruit io ...
-- Code basiert auf: http://www.electronicwings.com/nodemcu/nodemcu-mqtt-client-with-esplorer-ide

-- adafruit server details
server          = "io.adafruit.com"
port            = 1883
pub_humidity    = "macnothi/f/nodemcu.humidity"
pub_temperature = "macnothi/f/nodemcu.temperature"
sub_greenledSta = "macnothi/f/nodemcu.greenled"
sub_greenledCom = "macnothi/f/nodemcu.green-led-command"
pub_redledSta   = "macnothi/f/nodemcu.redled"
aio_username    = "macnothi"
aio_key         = "fb834016e230436687e6bbda5340a2b2"
client_id       = "04ada60b-03fa-4779-a6ec-0ba7b1a85f49" -- did fail with simple client_id ...

-- mqtt client status
mqttIsConnected = 0

-- init mqtt client with logins, keepalive timer 120s
mqttClient = mqtt.Client(client_id, 120, aio_username, aio_key)
-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client dont send keepalive packet
mqttClient:lwt("/lwt", "offline", 0, 0)

--[
-- I never saw the "connect" callback ?
mqttClient:on("connect", function(client) 
      print ("mqtt client connected") 
      mqttIsConnected = 1
      tmrReconnectMQTT:stop()
    end)
--]]

--[
mqttClient:on("offline", function(client) 
      print ("mqtt client offline")
      tmrReconnectMQTT:start()
      mqttIsConnected = 0
    end)
--]]

-- on message receive event
mqttClient:on("message", function(client, topic, data) 
   --[
  print("MQTT message from " .. topic .. " : " ) 
  if data ~= nil then
    print("received : ", data)
  end
  --]]
  if topic == sub_greenledCom then
    if data == "0" then
      gpio.write(webPin, gpio.LOW)
      client:publish(sub_greenledSta, "0" , 0, 0)
    elseif data == "1" then
      gpio.write(webPin, gpio.HIGH)
      client:publish(sub_greenledSta, "1" , 0, 0)
    end
  end
  updateDisplay()
end)

function subscribe(mq_client)
  mq_client:connect(server, port, 0, 0,
    function(client)
      print("MQTT connected to broker")
      mqttIsConnected = 1
      tmrReconnectMQTT:stop()
      -- subscribe topic with qos = 0
      client:subscribe(sub_greenledCom, 0, function(client) print("MQTT subscribe success") end)
      publish(client)
      updateDisplay()
    end,
    function(client, reason)
      print("MQTT connect failed reason: " .. reason)
      mqttIsConnected = 0
      updateDisplay()
    end)
end

function publish(mq_client)
    -- publish a message with data, QoS = 0, retain = 0
    mq_client:publish(pub_humidity, string.format("%.1f",humidity), 0, 0)
    -- publish a message with data, QoS = 0, retain = 0
    mq_client:publish(pub_temperature, string.format("%.1f",temperature), 0, 0)
    print("MQTT data published") 
end

-- delay start of mqtt client (seems needed after using .lc files)
tmrStartMQTT = tmr.create()
tmrStartMQTT:register(1000, tmr.ALARM_SEMI, function() subscribe(mqttClient) end)

-- try to reconnect after client went offline
tmrReconnectMQTT = tmr.create()
tmrReconnectMQTT:register(10000, tmr.ALARM_AUTO, function() subscribe(mqttClient) end)

-- EOF