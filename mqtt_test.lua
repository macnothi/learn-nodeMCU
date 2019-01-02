-- Test MQTT Protokoll mit adafruit io ...
-- Code basiert auf: http://www.electronicwings.com/nodemcu/nodemcu-mqtt-client-with-esplorer-ide

-- adafruit server details
server          = "io.adafruit.com"
port            = 1883
publish_topic   = "macnothi/feeds/nodemcu.humidity"
subscribe_topic = "macnothi/feeds/nodemcu.greenled"
aio_username    = "macnothi"
aio_key         = "fb834016e230436687e6bbda5340a2b2"
client_id       = "1"

-- init mqtt client with logins, keepalive timer 120s
mqttClient = mqtt.Client(client_id, 120, aio_username, aio_key)
-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client dont send keepalive packet
mqttClient:lwt("/lwt", "offline", 0, 0)

mqttClient:on("connect", function(client) print ("client connected") end)
mqttClient:on("offline", function(client) print ("client offline") end)

-- on message receive event
mqttClient:on("message", function(client, topic, data) 
  print(topic .. " : " ) 
  if data ~= nil then
    print("received : ", data)
  end
end)

function subscribe(mq_client)
    mq_client:connect(server, port, 0, 0,
    function(client)
        print("connected")
        -- subscribe topic with qos = 0
        client:subscribe(subscribe_topic, 0, function(client) print("subscribe success") end)
        -- set auto (continuous) alarm of 500ms to send pot value on alarm.
        -- tmr.alarm(timer_id, 500, tmr.ALARM_AUTO, function() publish(mqttClient) end)
    end,
    function(client, reason)
      print("failed reason: " .. reason)
    end)
end

function publish(mq_client)
   
    -- publish a message with pot data, QoS = 0, retain = 0
    mq_client:publish(publish_topic, humiStr, 0, 0, function(client) print("sent : ",humiStr) end)
    
end

subscribe(mqttClient)