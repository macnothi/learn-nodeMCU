-- setup I2c and connect display
function init_i2c_display()
    local id  = 0
    local sla = 0x3c
    i2c.setup(id, sdaPin, sclPin, i2c.SLOW)
    disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
end
  
-- prepare display
function u8g2_prepare()
    disp:setFont(u8g2.font_6x10_tf)
    disp:setFontRefHeightExtendedText()
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
end

init_i2c_display()
u8g2_prepare()
disp:clearBuffer()
