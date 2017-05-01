-- file : mqtt.lua

local module = {}

local MQTT = require("mqtt_library")

local function callback(
  topic,    -- string
  message)  -- string

  print("Topic: " .. topic .. ", message: '" .. message .. "'")
  mqtt_client:publish(args.topic_p, message)

end

function module.Client(id, tt)
    local arg_host = config.HOST[setup.KEY]
    local arg_port = config.PORT
    mqtt_client = MQTT.client.create(arg_host, arg_port, callback)
    return 0
end

return module
