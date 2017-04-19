-- file : init.lua

-- globale Variablen
-- PINs f�r die rote/gr�ne LED
pinR=1
pinG=2
-- onboard LED
pinLED=0

standalone = true

if standalone then
    node   = require ("fakenode/node")
    gpio   = require ("fakenode/gpio")
    ws2812 = require ("fakenode/ws2812")
    tm1638 = require("fakenode/tm1638")
else
    tm1638 = require("tm1638")
end

app    = require("application")
config = require("config")
setup  = require("setup")

setup.start()
