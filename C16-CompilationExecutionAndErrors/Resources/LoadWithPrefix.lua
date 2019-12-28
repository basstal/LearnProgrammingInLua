function LoadWithPrefix(prefix, chunk)
    local isPrefixReturned = false
    local isChunkReturned = false
    local readerFunction = function()
        if not isPrefixReturned then
            isPrefixReturned = true
            return prefix
        end
        if not isChunkReturned then
            isChunkReturned = true
            return chunk
        end
    end
    return load(readerFunction)
end

function Test()
    local f = LoadWithPrefix("return ", "x == 5")
    local rf = f()
    print(rf)
    local c = load("return x == 5")
    print(c)
    local r = c()
    print(r)
end

Test()