tm = require("tm1638") 

print("setup")
tm.setup()
tm.sendChar(0, "A", false) 
tm.sendChar(1, "B", false)
tm.sendChar(2, "C", true)
tm.sendChar(3, "D", false)
tm.sendChar(4, "E", false)
tm.sendChar(5, "F", false)
tm.sendChar(6, "0", false)
tm.sendChar(7, "1", false)

tm.sendChar(4, "x", 1)

tmr.delay(1000)

tm.print("  1984  ")

tm.print("37.4")

tmr.delay(1000)

for j=61,60 do
-- without delay my nodemcu crashes
tmr.delay(1000)
tm.print(j .. "")
end

tm.print("")
