local Stack = {}

local stackData = {}


function Stack:New(o)
    o = o or {}
    stackData[o] = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Stack:Push(n)
    table.insert(stackData[self], n)
end


function Stack:Pop()
    local d = stackData[self]
    if #d == 0 then
        error("Stack is empty")
        return
    end
    return table.remove(d, #d)
end

function Stack:Top()
    local d = stackData[self]
    if #d == 0 then
        error("Stack is empty")
        return
    end
    return d[#d]
end


function Stack:IsEmpty()
    local d = stackData[self]
    return #d == 0
end

function Test()
    local s = Stack:New()
    s:Push(1)
    s:Push(2)
    s:Push(3)
    s:Push(4)
    s:Push(5)
    print(s:Top())
    print(s:Pop())
    print(s:Pop())
    print(s:IsEmpty())
end

Test()
return Stack