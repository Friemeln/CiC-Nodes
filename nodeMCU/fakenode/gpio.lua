-- file : gpio.lua
local module    = {}
-- fake my nodeLUA for standalone use & test

module.OUTPUT = "OUTPUT"
module.LOW    = "LOW"
module.HIGH   = "HIGH"

function module.mode(pin, mode)
    print("GPIO["..pin.."] : "..mode)
end

function module.write(pin, state)
    print("GPIO["..pin.."] <= "..state)
end

function module.read(pin)
    return 0
end

print("FakeNode.gpio loaded...")

return module
