connected = false
magic = {0xDE, 0xAD, 0xBE, 0xEF}


-- print("Connecting to AP...\n")
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      -- print("Connecting to AP...\n")
   else
      -- ip, nm, gw=wifi.sta.getip()
      -- print("IP Info: \nIP Address: ",ip)
      -- print("Netmask: ",nm)
      -- print("Gateway Addr: ",gw,'\n')
      connected = true
      sendTerminator()
      tmr.stop(0)
   end
end)

function getPage(url)
   -- http.get(url, nil, function(code, data)
   --    if (code < 0) then
   --       uart.write(0, code .. " HTTP request failed\n")
   --    else
   --       uart.write(0, data)
   --    end
   --    sendTerminator()
   -- end)

   conn=net.createConnection(net.TCP, 0)
   conn:on("receive", function(conn, payload) print(payload) end )
   conn:on("connection", function(c)
      conn:send("GET " .. "/" .. " HTTP/1.1\r\n"
         .."Connection: keep-alive\r\nAccept: */*\r\n\r\n") 
      end)
   conn:connect(80,"google.com")
end


function sendToClient(data)
   uart.write(data)
   sendTerminator()
end

function sendTerminator()
   uart.write(0, magic[4])
   uart.write(0, magic[3])
   uart.write(0, magic[2])
   uart.write(0, magic[1])
end

function initUART()
   -- when '\r' is received.
   uart.on("data", "\r",
     function(data)
         print(data)
         -- check for quit
         if data=="quit\r" then
            uart.on("data") -- unregister callback function
            tmr.stop(0); -- stop attempting to connect to wifi
         end

         if connected == false then
            return
         end

         -- parse arguments
         words = {}
         for w in data:gmatch("%S+") do 
            table.insert(words, w)
         end

         -- check for 2 parameteres
         if #words ~= 2 then
            return
         end

         -- HTTP get
         if words[1] == "get" then
            getPage(words[2])
         end
   end, 0)
end

initUART()