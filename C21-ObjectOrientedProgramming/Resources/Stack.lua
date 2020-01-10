local Stack = {}


function Stack:New(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Stack:Push(n)
    table.insert(self, n)
end

function Stack:Pop()
    if #self == 0 then
        error("stack is empty")
        return
    end
    local p = table.remove(self, #self)
    return p
end


function Stack:Top()
    if #self == 0 then
        error("stack is empty")
        return
    end
    return self[#self]
end

function Stack:IsEmpty()
    return #self == 0
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