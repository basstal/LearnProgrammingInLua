
local g = {}

function FileAsArray(fileName)
    local n = {}
    
    io.input(fileName)
    local i = 1
    while true do
        local byte = io.read(1)
        if not byte then break end
        n[i] = byte
        i = i + 1
    end
    
    rawset(g, fileName, n)
    setmetatable(g, {
        __index = function(t, k)
            return t[fileName][k]
        end,
        __newindex = function(t, k, v)
            t[fileName][k] = v
            local p = table.concat(t[fileName])
            local f = io.output(fileName)
            f:write(p)
            f:close()
        end,
        __len = function(t)
            return #t[fileName]
        end,
        __pairs = function(t)
            return function(_, k)
                return next(t[fileName], k)
            end
        end,
    })
    return g
end


function Test()
    local t = FileAsArray("MetamethodSet.lua")
    print(t[1])
    print(t[10])
    print(t[11])
    -- t[1] = 'c'
    -- t[2] = 'b'
    local content = {}
    for k, v in pairs(t) do
        table.insert(content, v)
    end
    print(table.concat(content))
    print(#t)
end

Test()