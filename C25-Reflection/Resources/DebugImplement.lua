local Getvarvalue = require("Getvarvalue1")

function DebugImplement()
    _ENV = {
        load = _G.load,
        io = _G.io,
        debug = _G.debug,
        print = _G.print,
        assert = _G.assert
    }
    local isBreak = false
    local func = debug.getinfo(2, "f").func
    -- local env = Getvarvalue()
    while true do
        io.write("debug> ")
        -- local GetNextChunk = function()
        -- end
        local line = io.read()
        if line == "cont" then break end
        -- _ENV = env
        
        assert(load("_ENV = {}", line))()
    end
end

function Test()
    local a = 1
    DebugImplement()
end

Test()