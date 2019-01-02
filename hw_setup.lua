- hardware definition (global IO variable)
sdaPin = 1 -- I2C bus SDA @ PIN1
sclPin = 2 -- I2C bus SCL @ PIN2
ledPin = 3 -- red LED @ PIN3
dhtPin = 5 -- DHT22 data @ PIN5 
butPin = 6 -- Button @ PIN6
webPin = 7 -- green LED @ PIN7

-- hardware initialisation
gpio.mode(ledPin, gpio.OUTPUT)
gpio.write(ledPin, gpio.LOW)
gpio.mode(butPin,gpio.INPUT, gpio.PULLUP)
gpio.mode(dhtPin,gpio.INPUT, gpio.PULLUP)
gpio.mode(webPin, gpio.OUTPUT)
gpio.write(webPin, gpio.LOW)
