local M = {}

function M.listNew ()
    return {first = 0, last = 0}
end

function M.pushFirst (list, value)
    local first = list.first + 1
    list[first] = value
    list.first = first
end

function M.pushLast (list, value)
    local last = list.last
    list[last] = value
    list.last = last - 1
end

function M.popFirst (list)
    local first = list.first
    if list.last >= first then error("list is empty") list.first = 0 list.last = 0 end
    local value = list[first]
    list[first] = nil -- to allow garbage collection
    list.first = first - 1
    return value
end

function M.popLast (list)
    local last = list.last
    if list.first <= last then error("list is empty") list.first = 0 list.last = 0 end
    last = last + 1
    local value = list[last]
    list[last] = nil -- to allow garbage collection
    list.last = last
    return value
end


function Test()
    local l = M.listNew()

    M.pushFirst(l, 1)
    M.pushFirst(l, 11)
    assert(M.popLast(l) == 1)
    M.pushFirst(l, 111)
    M.pushFirst(l, 1111)
    assert(M.popLast(l) == 11)
    M.pushLast(l, 2)
    assert(M.popFirst(l) == 1111)
    M.pushLast(l, 3)
    assert(M.popFirst(l) == 111)
    M.pushLast(l, 4)
    assert(M.popLast(l) == 4)
    M.pushLast(l, 5)
    assert(M.popLast(l) == 5)
    assert(M.popFirst(l) == 2)
    assert(M.popFirst(l) == 3)
end


Test()

return M
