function IteratorUniquewords()
    local wordsReported = {}
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    return function () -- iterator function
        while line do -- repeat while there are lines
            local w, e = string.match(line, "(%w+)()", pos)
            if w then -- found a word?
                pos = e -- next position is after this word
                if wordsReported[w] == nil then
                    wordsReported[w] = true
                    return w -- return the word
                end
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

function Test()
    io.input("Test")
    for word in IteratorUniquewords() do
        print(word)
    end
end

Test()