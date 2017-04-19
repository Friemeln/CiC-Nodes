-- file : application.lua

local module = {}

-- Changelog: Version.txt
local appVers = "V0.1g"

local m       = {}

local heapalt = 0
local heapakt = 0

local shipID  = "leer"

-- Sends a simple ping to the broker
local function send_ping()
    gpio.write(pinLED, gpio.LOW)
    m:publish(config.ENDPOINT .. "ping", shipID,0,0)
    gpio.write(pinLED, gpio.HIGH)
end

-- Sends my id to the broker for registration
local function register_myself()
    m:subscribe(config.ENDPOINT..shipID,0,function(conn)
        print("Successfully subscribed to data endpoint: "..config.ENDPOINT..shipID)
        m:publish(config.ENDPOINT .. "log",shipID..": ist jetzt online "..appVers,0,0)
    end)
end

local function mqtt_start()
    -- Anmeldung beim Broker mu� eine eindeutige ID sein! (?)
    -- daher hier nicht shipID sondern config.ID (das wiederum die CHIP.ID des nodeMCU ist).
    -- m = mqtt.Client(config.ID, 120)
    m = mqtt.Client(shipID, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data)
        if data ~= nil then
            -- print(topic .. ": " .. data)
            -- do something, we have received a message

            i, j   = data:find(":")
            if i == nil then
                befehl = data
                op = "-"
            else
                befehl = data:sub(1,i-1)
                op     = data:sub(j+1,-1)
            end

            -- print(data.."-->["..befehl..":"..op.."]",i,j)

            if befehl == "help" then
                print("Hilfe: ["..appVers.."]")
                print("red   : LED => rot")
                print("green : LED => gr�n")
                print("clear : LED => aus")
                print("alert : 5x LED rot blinken")
                print("setID:xx : shipID = xx")

                print("help  : dieser Text")

            elseif befehl == "red" then
                -- print("LED => Rot")
                gpio.write(pinG, gpio.LOW)
                gpio.write(pinR, gpio.HIGH)

            elseif befehl == "green" then
                -- print("LED => Gr�n")
                gpio.write(pinG, gpio.HIGH)
                gpio.write(pinR, gpio.LOW)

            elseif befehl == "clear" then
                -- print("LED => aus")
                gpio.write(pinR, gpio.LOW)
                gpio.write(pinG, gpio.LOW)

            elseif befehl == "wsred" then
                buffer:fill(0, 8, 0)
                ws2812.write(buffer)

            elseif befehl == "wsgreen" then
                buffer:fill(8, 0, 0)
                ws2812.write(buffer)

            elseif befehl == "wsblue" then
                buffer:fill(0, 0, 8)
                ws2812.write(buffer)

            elseif befehl == "wswrite" then
                -- wswrite:<RGB>..<RGB>
                local tmp
                local v = {}
                for i=1,op:len(),3 do
                    tmp = op:sub(i,i+2)
                    -- print("i["..i.."]:"..tmp)
                    for j=1,3 do
                        v[j] = tmp:byte(j)
                        if v[j] == nil then
                            v[j] = 0
                        else
                            -- rudimentäre Anpassung des Strings um Steuer-Chars zu überspringen [v-32]
                            -- Verdopplung um den kompletten Farbraum halbwegs abzudecken
                            -- ASC("~") = 126 -> 0 bis 252 in 2er Schritten
                            v[j] = 2 * (v[j] - 32)
                        end
                    end
                    -- befülle buffer mit dem GRB-Muster <op>
                    buffer:set(math.floor(i/3)+1, v[1], v[2], v[3] )
                end
                ws2812.write(buffer)

                -- local var'S löschen ?!?
                tmp,v = nil, nil


            elseif befehl == "wsclear" then
                buffer:fill(0, 0, 0)
                ws2812.write(buffer)

            elseif befehl == "alert" then
                gpio.serout(pinR,gpio.HIGH,{9000,995000},10, function() print("Alarm done") end)
                gpio.write(pinG, gpio.LOW)

            elseif befehl == "heap" then
                heapakt=node.heap()
                m:publish(config.ENDPOINT .. "log", shipID.." Heap:"..heapakt.."("..heapalt-heapakt..")",0,0)
                heapalt=heapakt

            elseif befehl == "setID" then
                tmr.stop(6)
                shipID=op
                mqtt_start()

            elseif befehl == "tmLEDon" then
                tm1638.setLED(op,1)
            elseif befehl == "tmLEDoff" then
                tm1638.setLED(op,0)

            elseif befehl == "tmPrint" then
                tm1638.print(op)
            elseif befehl == "tmTest" then
                tm1638.test_modul()

            else
                print(topic .. ": " .. data)
            end
        end
    end)
    -- Connect to broker
    m:connect(config.HOST[setup.KEY], config.PORT, 0, 1, function(con)
        register_myself()
        -- shipID = config.ID
        -- And then pings each 1000 milliseconds
        print("register_myself ok")
        tmr.stop(6)
        tmr.alarm(6, 10*1000, 1, send_ping)
    end,
    function(con, reason) gpio.serout(pinR,gpio.HIGH,{9000,995000},10-reason, function() print("failed - reason: "..reason) end)
end)

end

function module.start()
    shipID = config.ID

    -- init (LEDs aus, Display clear, WSxxxx aus etc.
    gpio.write(pinR, gpio.LOW)
    gpio.write(pinG, gpio.LOW)

    mqtt_start()
end

return module
