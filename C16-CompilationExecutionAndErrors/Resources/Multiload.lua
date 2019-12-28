function Multiload(...)
    local t = {...}
    local i = 1
    local currentFunction
    local readerFunction = function()
        if currentFunction ~= nil then
            local result = currentFunction()
            if result ~= nil then
                -- print(9, result)
                return result
            end
            -- print(12, "??")
        end
        currentFunction = nil
        local nextChunk = t[i]
        i = i + 1
        -- print(nextChunk)
        if type(nextChunk) == "function" then
            local result = nextChunk()
            if result ~= nil then
                currentFunction = nextChunk
                -- print(21, result)
                return result
            else
                -- ** 为了继续下一个chunk
                return ""
            end
        else
            -- print(28, nextChunk)
            return nextChunk
        end
        -- print(31, "here??")
    end
    -- ** assert方便debug
    return assert(load(readerFunction))
end

function Test()
    io.input("Test")
    local r = Multiload("local x = 10;", io.lines(), "print(a)\n return a")
    -- local r = Multiload("local x = 10", " return x")
    print(r)
    print(r())
    -- assert(r() == 10)
end


Test()