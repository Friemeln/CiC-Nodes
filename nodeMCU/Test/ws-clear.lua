ws2812.init(ws2812.MODE_SINGLE)

-- 16 LED 
buffer = ws2812.newBuffer(16, 3)

-- fill the buffer with color for a RGB strip
buffer:fill(0, 0, 0) 
ws2812.write(buffer)
