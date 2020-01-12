-- collectgarbage("setpause", 1000)
-- collectgarbage("setstepmul", 0)
collectgarbage("stop")
local count = 50000000
local k = {}
for i = 1, count do
    k[i] = {}
end

-- collectgarbage("setpause", 0)
print(collectgarbage("count"))
collectgarbage("collect")
