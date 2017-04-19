-- file : gpio.lua
local module    = {}
-- fake my nodeLUA for standalone use & test

module.MODE_SINGLE = 0
module.LOW    = 0
module.HIGH   = 1

function module.init(mode)
end

function module.write(pin, state)
    print("GPIO:"..pin.."="..state)
end

function module.read(pin)
    return 0
end

print("FakeNode.ws2812 loaded...")

return module
