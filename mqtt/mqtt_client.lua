-- MQTT Protokoll mit adafruit io ...
-- Code basiert auf: http://www.electronicwings.com/nodemcu/nodemcu-mqtt-client-with-esplorer-ide

-- adafruit server details
server          = "io.adafruit.com"
port            = 1883
pub_testfeed    = "macnothi/feeds/testfeed"
aio_username    = "macnothi"
aio_key         = "fb834016e230436687e6bbda5340a2b2"
client_id       = "04ada60b-03fa-4779-a6ec-0ba7b1a85f49"

-- mqtt client status
mqttIsConnected = 0
mqttCounter = 0

-- init mqtt client with logins, keepalive timer 120s
mqttClient = mqtt.Client(client_id, 120, aio_username, aio_key)
-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client dont send keepalive packet
mqttClient:lwt("/lwt", "offline", 0, 0)

--[
mqttClient:on("connect", function(client) 
      print ("mqtt client connected") 
      mqttIsConnected = 1
      end)
--]]

--[
mqttClient:on("offline", function(client) 
      print ("mqtt client offline")
      mqttIsConnected = 0
    end)
--]]

-- on message receive event
mqttClient:on("message", function(client, topic, data) 
   --[
  print(topic .. " : " ) 
  if data ~= nil then
    print("received : ", data)
  end
  --]]
end)

function subscribe(mq_client)
    mq_client:connect(server, port, 0, 0,
    function(client)
        print("connected")
    end,
    function(client, reason)
      print("failed reason: " .. reason)
      mqttIsConnected = 0
    end)
end

function publish(mq_client)
    mqttCounter = mqttCounter +1
    -- publish a message with data, QoS = 0, retain = 0
    mq_client:publish(pub_testfeed, mqttCounter, 0, 0)
    print("data published") 
end

--subscribe(mqttClient)