local Counters = {}
local Names = {}

local function hook ()
    local f = debug.getinfo(2, "f").func
    local count = Counters[f]
    if count == nil then -- first time 'f' is called?
        Counters[f] = {func = f, count = 1}
        Names[f] = debug.getinfo(2, "Sn")
    else -- only increment the counter
        Counters[f].count = Counters[f].count + 1
    end
end

function getname (func)
    local n = Names[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        return string.format("%s (%s)", lc, n.name)
    else
        return lc
    end
end

function Test()
    debug.sethook(hook, "c")
    local t = require("Getvarvalue1")
    debug.sethook()
    local sorted = {}
    for _, data in pairs(Counters) do
        table.insert(sorted, data)
        -- print(getname(func), count)
    end
    table.sort(sorted, function(a, b)
        return a.count < b.count
    end)
    for _, data in ipairs(sorted) do
        print(getname(data.func), data.count)
    end
end

Test()