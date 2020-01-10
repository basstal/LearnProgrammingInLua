local Stack = require("Stack")

local StackQueue = Stack:New()


function StackQueue:InsertBottom(n)
    table.insert(self, 1, n)
end

function Test()
    local sq = StackQueue:New()
    sq:Push(1)
    sq:Push(2)
    sq:Push(3)
    sq:Push(4)
    sq:Push(5)
    print(sq:Top())
    print(sq:Pop())
    print(sq:Pop())
    print(sq:IsEmpty())
    sq:InsertBottom(5)
    print(sq:Pop())
    print(sq:Pop())
    print(sq:Pop())
    print(sq:Pop())
    print(sq:IsEmpty())

end

Test()