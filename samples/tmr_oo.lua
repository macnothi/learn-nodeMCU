-- oo call of timers
local t1 = tmr.create()

t1:register(5000, tmr.ALARM_SINGLE, function (t) print("expired"); t:unregister() end)
t1:start()