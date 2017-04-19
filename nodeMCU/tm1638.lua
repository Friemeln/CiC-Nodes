local module = {}

pinStb = 7
pinClk = 6
pinDio = 5

font = { }

local function setupFont()
    font[" "] = '0x00'
    font['0'] = '0x3F'
    font['1'] = '0x06'
    font['2'] = '0x5B'
    font['3'] = '0x4F'
    font['4'] = '0x66'
    font['5'] = '0x6D'
    font['6'] = '0x7D'
    font['7'] = '0x07'
    font['8'] = '0x7F'
    font['9'] = '0x6F'
    font['A'] = '0x77'
    font['B'] = '0x7C'
    font['C'] = '0x39'
    font['D'] = '0x5E'
    font['E'] = '0x79'
    font['F'] = '0x71'
    font["H"] = '0x76'
    font["'"] = '0x63'
    font["-"] = '0x20'
end

local function send(byte)
    mask = 0x1
    for i=0,7 do
        gpio.write(pinClk, gpio.LOW)
        if bit.band(byte, mask) > 0 then
            gpio.write(pinDio, gpio.HIGH)
        else
            gpio.write(pinDio, gpio.LOW)
        end
        mask = bit.lshift(mask, 1)
        gpio.write(pinClk, gpio.HIGH)
    end
end

local function sendCommand(cmd)
    gpio.write(pinStb, gpio.LOW)
    send(cmd)
    gpio.write(pinStb, gpio.HIGH)
end

local function sendData(address, data)
    sendCommand(0x44)
    gpio.write(pinStb, gpio.LOW)
    send(bit.bor(0xC0, address))
    send(data)
    gpio.write(pinStb, gpio.HIGH)
end

local function sendChar(address, char, dot)
    data = font[char];
    if data then
        if dot then
            data = bit.bor(data, 0x80)
        end
    else
        data = 0;
    end

    address = bit.lshift(address, 1)
    sendData(address, data)
end

function module.setChar(address, char, dot)
    -- Adresse:0..7 -> gerade Adressen
    address = bit.band(address, 0x0F)
    sendChar(address, char:upper(), dot)
end

function module.setLED(address, value)
    -- Adresse:0..7 --> ungerade Adressen
    address = bit.band(address, 0x0F)
    address = bit.lshift(address, 1)
    address = bit.bor(address, 0x01)

    sendData(address, value)
end

function module.getKey()
  local button = 0
  local v      = 0

  sendCommand(0x42)
  -- Data-Port auf Input stellen
  gpio.mode(pinDio, gpio.INPUT)
  gpio.write(pinDio, gpio.HIGH)



  -- hole 4 Bytes
  for j=0,3 do
    gpio.write(pinStb, gpio.LOW)
    for i=0,7 do
        gpio.write(pinClk, gpio.LOW)

        tmr.delay(1000)

        v = gpio.read(pinDio)
        button = bit.bor(bit.lshift(button,1),v)

        print(j,i,v,button)

        gpio.write(pinClk, gpio.HIGH)
    end
    gpio.write(pinStb, gpio.HIGH)
  end -- j
  -- Data-Port auf OUTPUT stellen
  gpio.mode(pinDio, gpio.OUTPUT)
  gpio.write(pinDio, gpio.LOW)


  return 0
end

function module.print(iString)
    print ("print [" .. iString .. "]")
    i = 1
    j = 0
    repeat
        dot = false
        char = string.sub(iString, i, i)
        if (char == ".") then
            char = " "
            dot = true
        else
            if (string.sub(iString, i+1, i+1) == ".") then
                i=i+1
                dot=true
            end
        end

        -- print ("i=" .. i .. " char=" .. char .. " dot=" .. tostring(dot))
        sendChar(j, char, dot)
        i=i+1
        j=j+1
    until (j == 8)
end

function module.test_modul()
    -- Alle LEDs an
    for i=0,7 do
        module.setLED(i,1)
    end

    -- Alle DOTs an
    for i=0,7 do
        module.setChar(i,"_",true)
    end

    -- Alle Segmente an
    for i=0,7 do
        module.setChar(i,"8",false)
    end

    -- Alles wieder aus
    for i=0,7 do
        module.setChar(i,"_",false)
    end

    -- Alle LEDs wieder aus
    for i=0,7 do
        module.setLED(i,0)
    end

end

function module.setup()
    setupFont()

    gpio.mode(pinStb, gpio.OUTPUT)
    gpio.mode(pinClk, gpio.OUTPUT)
    gpio.mode(pinDio, gpio.OUTPUT)

    gpio.write(pinClk, gpio.HIGH)
    gpio.write(pinStb, gpio.HIGH)

    sendCommand(0x40)
    sendCommand(bit.bor(0x80, 8, 8))

    gpio.write(pinStb, gpio.LOW)
    send(0xC0)
    for i=0,15 do
        send(0x00)
    end
    gpio.write(pinStb, gpio.HIGH)
end

function module.start()
	setup()
end

return module
