local M = {}

local MAXGEN = 200
local NOWORD = "\\n"

local C = {}

function C:allwords ()
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    return function () -- iterator function
        while line do -- repeat while there are lines
            local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
            if w then -- found a word?
                pos = e -- update next position
                return w -- return the word
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

function C:prefix (...)
    local p = {...}
    local prefixTable = {}
    for i = 1, self.n do
        table.insert(prefixTable, p[i])
    end
    
    return table.concat(prefixTable, " ")
end

function C:insert (prefix, value)
    local list = self.statetab[prefix]
    if list == nil then
        self.statetab[prefix] = {value}
    else
        list[#list + 1] = value
    end
end

function GenMarkovChain(nPreviousWord)
    if nPreviousWord <= 1 then
        print("GenMarkovChain failed, previous word less equal 1.")
        return
    end
    
    local newChain = setmetatable({
        n = nPreviousWord,
        statetab = {},
    }, {__index = C})
    
    -- build table
    local recordWords = {}
    for i = 1, nPreviousWord do
        recordWords[i] = NOWORD
    end
    -- local w1, w2 = NOWORD, NOWORD
    for nextword in newChain:allwords() do
        newChain:insert(newChain:prefix(table.unpack(recordWords)), nextword)
        table.move(recordWords, 2, #recordWords, 1)
        recordWords[#recordWords] = nextword
    end

    newChain:insert(newChain:prefix(table.unpack(recordWords)), NOWORD)
    -- generate text
    -- w1 = NOWORD; w2 = NOWORD -- reinitialize
    for i = 1, nPreviousWord do
        recordWords[i] = NOWORD
    end
    for i = 1, MAXGEN do
        local list = newChain.statetab[newChain:prefix(table.unpack(recordWords))]
        -- choose a random item from list
        local r = math.random(#list)
        local nextword = list[r]
        if nextword == NOWORD then return end
        io.write(nextword, " ")
        table.move(recordWords, 2, #recordWords, 1)
        recordWords[#recordWords] = nextword
        -- w1 = w2; w2 = nextword
    end
    return C
end

function Test()
    -- ** 先验两个单词的情况
    io.input("C19-InterludeMarkovChainAlgorithm\\Resources\\Test1")
    io.output("C19-InterludeMarkovChainAlgorithm\\Resources\\Gen1")
    GenMarkovChain(2)
    
    -- ** 再验五个单词的情况
    io.input("C19-InterludeMarkovChainAlgorithm\\Resources\\Test1")
    io.output("C19-InterludeMarkovChainAlgorithm\\Resources\\Gen2")
    GenMarkovChain(5)
    -- ** 最后验证小于两个单词的情况
    GenMarkovChain(-1)
end

Test()