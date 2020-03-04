function Getvarvalue()
    
    local result = {}
    for level = 2, math.huge do
        if not debug.getinfo(level) then break end
        for i = 1, math.huge do
            local n, v = debug.getlocal( level, i )
            if not n then break end
            result[n] = v
        end
    end
    local env = {}
    for level = 2, math.huge do
        if not debug.getinfo(level) then break end
        local func = debug.getinfo( level, "f" ).func
        for i = 1, math.huge do
            local n, v = debug.getupvalue( func, i )
            if not n then break end
            if n == "_ENV" then
                for ek, ev in pairs(v) do
                    env[ek] = ev
                end
            else
                env[n] = v
            end
        end
    end
    setmetatable(result, {__index = env})
    return result
end

local Getv = Getvarvalue
local G = _ENV._G
_ENV.a = 10
b = 11
_ENV = nil
local c = 12
local function Test1()
    return 2
end

_ENV = {
    Getvarvalue = Getv,
    math = G.math,
    debug = G.debug,
    pairs = G.pairs,
    setmetatable = G.setmetatable,
    print = G.print
}

function Test()
    local d = 12
    local r = Getvarvalue()
    print("** locals ** ")
    for n, v in pairs(r) do
        print(n, v)
    end
    print("** env ** ")

    print(r.Test1)
end

Test()