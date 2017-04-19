-- file : gpio.lua
local module    = {}

-- fake my nodeLUA for standalone use & test
local segmanzeige = {" "," "," "," "," "," "," "," "}
local ledsanzeige = {" "," "," "," "," "," "," "," "}

function module.setChar(address, char, dot)
    if char == "'" then
        char ="°"
    elseif char == "-" then
        char = "'"
    end
    if dot then
        segmanzeige[address] = char.."."
    else
        segmanzeige[address] = char
    end
end

function module.setLED(address, value)
    ledsanzeige[address] = value
end

function module.test_modul()

end

print("FakeNode.TM1638 loaded...")

return module
