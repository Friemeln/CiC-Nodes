-- file: setup.lua
local module = {}
local ledstat = false

local function wifi_wait_ip()
    if wifi.sta.getip()== nil then
        if ledstat then
            gpio.write(pinR, gpio.LOW)
            ledstat = not ledstat
        else
            gpio.write(pinR, gpio.HIGH)
            ledstat = not ledstat
        end
        print("IP unavailable, Waiting...")
    else
        tmr.stop(1)
        gpio.write(pinR, gpio.LOW)
        gpio.write(pinG, gpio.HIGH)
        print("\n====================================")
        print("ESP8266 mode is: " .. wifi.getmode())
        print("MAC address is: " .. wifi.ap.getmac())
        print("IP is "..wifi.sta.getip())
        print("WLAN is "..module.KEY)
        print("====================================")
        -- auf dem TM1638 die IP ausgeben
        tm1638.print( string.sub(wifi.sta.getip(),-10) )
        -- starte nun die APP
        app.start()
    end
end

local function wifi_start(list_aps)
    if list_aps then
        for key,value in pairs(list_aps) do
            if config.SSID and config.SSID[key] then
                wifi.setmode(wifi.STATION);
                wifi.sta.config(key,config.SSID[key])
                wifi.sta.connect()
                print("Connecting to " .. key .. " ...")
                module.KEY = key
                --config.SSID = nil  -- can save memory
                tmr.alarm(1, 2500, 1, wifi_wait_ip)
            end
        end
    else
        print("Error getting AP list")
    end
end

function module.start()

    print("init LEDs")
    gpio.mode(pinR, gpio.OUTPUT)
    gpio.write(pinR, gpio.LOW)
    gpio.mode(pinG, gpio.OUTPUT)
    gpio.write(pinG, gpio.LOW)
    gpio.mode(pinLED, gpio.OUTPUT)
    gpio.write(pinLED, gpio.HIGH)

    print("init WS2812-16 LED")
    ws2812.init(ws2812.MODE_SINGLE)
    -- 16 LEDs für die 4x4 Matrix
    buffer = ws2812.newBuffer(16, 3)
    buffer:fill(0, 0, 0)
    ws2812.write(buffer)

    print("init TM1638")
    tm1638.setup()
    tm1638.test_modul()

    print("Configuring Wifi ...")
    if not standalone then
        wifi.setmode(wifi.STATION);
        wifi.sta.getap(wifi_start)
    else
        -- direkt weiter zu:
        app.start()
    end
end

return module
