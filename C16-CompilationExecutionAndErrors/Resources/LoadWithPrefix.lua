function LoadWithPrefix(prefix, chunk)
    local isPrefixReturned = false
    local isChunkReturned = false
    local readerFunction = function()
        if not isPrefixReturned then
            isPrefixReturned = true
            return prefix
        end
        if not isChunkReturned then
            if type(chunk) == "function" then
                local chunkResult = chunk()
                return chunkResult
            else
                isChunkReturned = true
                return chunk
            end
        end
    end
    return load(readerFunction)
end

function Test()
    local f = LoadWithPrefix("return ", io.lines())
    local rf = f()
    print(rf)
    -- print(rf)
    -- local c = load("return x == 5")
    -- print(c)
    -- local r = c()
    -- print(r)
end

Test()