-- file : config.lua
local module    = {}

module.PORT     = 1883
module.ID       = node.chipid()

module.ENDPOINT = "CiC/"

-- mögliche WLAN Konfigurationen...
module.SSID = {}
module.SSID["BC-Testnetz"] = "TestTestTest"
module.SSID["Naboo"]       = "tc9tc9tc9"

-- ... und welche IP dort der MQTT-Broker hat.
module.HOST = {}
module.HOST["BC-Testnetz"] = "192.168.118.19"
module.HOST["Naboo"]       = "192.168.111.177"

return module
