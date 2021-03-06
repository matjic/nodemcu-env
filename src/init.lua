print('init.lua ver 1.2')
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())

-- wifi config start
wifi.sta.config("dd-wrt","wifipass")
-- wifi config end

-- include main file
dofile("main.lua")