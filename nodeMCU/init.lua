-- file : init.lua

-- globale Variablen
-- PINs f�r die rote/gr�ne LED
pinR=1 
pinG=2
-- onboard LED
pinLED=0

app = require("application")  
config = require("config")  
setup = require("setup")
tm1638 = require("tm1638")

setup.start()
