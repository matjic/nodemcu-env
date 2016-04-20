gpio.mode(1, gpio.OUTPUT)

m = mqtt.Client("NodeMCU", 120, "nodemcu", "esp8266")

m:on("connect", function(client) 
	print ("connected")
	m:publish("/hello", "hello from the other side boi",0,0, function(client) 
		print("sent") 
		end)
	m:subscribe("/topic",0, function(client) 
		print("subscribe success") 
		end)
end)

m:on("offline", function(client) 
	print ("offline") 
end)

ledVal = gpio.LOW

m:on("message", function(client, topic, data)
	if data ~= nil then
		print(topic..":"..data)
	else
		print(topic)
	end

	if ledVal == gpio.HIGH then
		ledVal = gpio.LOW
	else
		ledVal = gpio.HIGH
	end
	gpio.write(1, ledVal)
	end)

m:connect("192.168.11.34", 1883, 0)