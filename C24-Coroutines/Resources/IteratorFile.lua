local lib = require "Lib"

local memo = setmetatable({}, {__mode = "k"})
function run (code)
    local co = coroutine.wrap(function ()
        code()
        lib.stop() -- finish event loop when done
    end)
    co() -- start coroutine
    lib.runloop() -- start event loop
end
function putline (stream, line)
    local co = coroutine.running() -- calling coroutine
    local callback = memo[co]
    if callback == nil then
        callback = (function () coroutine.resume(co) end)
        memo[co] = callback
    end
    lib.writeline(stream, line, callback)
    coroutine.yield()
end
function getline (stream, line)
    local co = coroutine.running() -- calling coroutine
    local callback = memo[co]
    if callback == nil then
        callback = (function (l) coroutine.resume(co, l) end)
        memo[co] = callback
    end
    lib.readline(stream, callback)
    local line = coroutine.yield()
    return line
end

function IteratorFile(name)
    local lines = {}
    run(function()
        local inp = io.input(name)
        while true do
            local line = getline(inp)
            if not line then break end
            table.insert(lines, line)
        end
    end)
    local n = 1
    return coroutine.wrap(function()
        while true do
            local line = lines[n]
            n = n + 1
            if not line then break end
            coroutine.yield( line )
        end
    end)
end

function Test()
    for line in IteratorFile("Lib.lua") do
        print(line)
    end
end

Test()