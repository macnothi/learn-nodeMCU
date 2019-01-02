-- hardware definition and initialisation
sdaPin = 1 -- I2C bus SDA @ PIN1
sclPin = 2 -- I2C bus SCL @ PIN2
ledPin = 3 -- red LED @ nodeMCU PIN3
dhtPin = 5 -- DHT22 data @ nodeMCU PIN5 
butPin = 6 -- Button @ nodeMCU PIN6
webPin = 7 -- green LED @ nodeMCU PIN7

gpio.mode(ledPin, gpio.OUTPUT)
gpio.write(ledPin, gpio.LOW)
gpio.mode(butPin,gpio.INPUT, gpio.PULLUP)
gpio.mode(dhtPin,gpio.INPUT, gpio.PULLUP)
gpio.mode(webPin, gpio.OUTPUT)
gpio.write(webPin, gpio.LOW)

