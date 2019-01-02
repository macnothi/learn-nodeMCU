-- MQTT Protokoll mit adafruit io ...
-- Code basiert auf: http://www.electronicwings.com/nodemcu/nodemcu-mqtt-client-with-esplorer-ide

-- adafruit server details
server          = "io.adafruit.com"
port            = 1883
pub_humidity    = "macnothi/feeds/nodemcu.humidity"
pub_temperature = "macnothi/feeds/nodemcu.temperature"
sub_greenled    = "macnothi/feeds/nodemcu.greenled"
aio_username    = "macnothi"
aio_key         = "fb834016e230436687e6bbda5340a2b2"
client_id       = "1"

-- mqtt client status
mqttIsConnected = 0

-- init mqtt client with logins, keepalive timer 120s
mqttClient = mqtt.Client(client_id, 120, aio_username, aio_key)
-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client dont send keepalive packet
mqttClient:lwt("/lwt", "offline", 0, 0)

mqttClient:on("connect", function(client) 
      print ("mqtt client connected") 
      mqttIsConnected = 1
    end)
mqttClient:on("offline", function(client) 
      print ("client offline")
      mqttIsConnected = 0
    end)

-- on message receive event
mqttClient:on("message", function(client, topic, data) 
  -- print(topic .. " : " ) 
  if topic == sub_greenled then
    --[[
    if data ~= nil then
      print("received : ", data)
    end
    --]]
    if data == "0" then
      gpio.write(webPin, gpio.LOW)
    elseif data == "1" then
      gpio.write(webPin, gpio.HIGH)
    end
    updateDisplay()   
  end
end)

function subscribe(mq_client)
    mq_client:connect(server, port, 0, 0,
    function(client)
        print("connected")
        -- subscribe topic with qos = 0
        client:subscribe(sub_greenled, 0, function(client) print("subscribe success") end)
        -- publish data
        -- publish(mq_client)
    end,
    function(client, reason)
      print("failed reason: " .. reason)
    end)
end

function publish(mq_client)
   
    -- publish a message with data, QoS = 0, retain = 0
    mq_client:publish(pub_humidity, string.format("%.1f",humidity), 0, 0)
    -- publish a message with data, QoS = 0, retain = 0
    mq_client:publish(pub_temperature, string.format("%.1f",temperature), 0, 0)
    
end

subscribe(mqttClient)