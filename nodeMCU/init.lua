-- file : init.lua

-- globale Variablen
-- PINs f�r die rote/gr�ne LED
pinR=1
pinG=2
-- onboard LED
pinLED=0

-- NUR! zum lokalen testen!!!
-- geht nicht!

standalone = false
standalone = false
standalone = false

if standalone then
    -- Funktioniert noch nicht!!!!
    node   = require("fakenode/node")
    gpio   = require("fakenode/gpio")
    ws2812 = require("fakenode/ws2812")
    tm1638 = require("fakenode/tm1638")
    mqtt   = require("fakenode/mqtt")

    app    = require("application")
    config = require("config")
    setup  = require("setup")

    app.start()
else
    tm1638 = require("tm1638")
    app    = require("application")
    config = require("config")
    setup  = require("setup")

    setup.start()
end
