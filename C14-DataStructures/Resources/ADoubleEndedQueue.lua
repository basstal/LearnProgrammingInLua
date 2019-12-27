function listNew ()
    return {first = 0, last = 0}
end

function pushFirst (list, value)
    local first = list.first + 1
    list[first] = value
    list.first = first
end

function pushLast (list, value)
    local last = list.last
    list[last] = value
    list.last = last - 1
end

function popFirst (list)
    local first = list.first
    if list.last >= first then error("list is empty") list.first = 0 list.last = 0 end
    local value = list[first]
    list[first] = nil -- to allow garbage collection
    list.first = first - 1
    return value
end

function popLast (list)
    local last = list.last
    if list.first <= last then error("list is empty") list.first = 0 list.last = 0 end
    last = last + 1
    local value = list[last]
    list[last] = nil -- to allow garbage collection
    list.last = last
    return value
end



function Test()
    local l = listNew()

    pushFirst(l, 1)
    pushFirst(l, 11)
    assert(popLast(l) == 1)
    pushFirst(l, 111)
    pushFirst(l, 1111)
    assert(popLast(l) == 11)
    pushLast(l, 2)
    assert(popFirst(l) == 1111)
    pushLast(l, 3)
    assert(popFirst(l) == 111)
    pushLast(l, 4)
    assert(popLast(l) == 4)
    pushLast(l, 5)
    assert(popLast(l) == 5)
    assert(popFirst(l) == 2)
    assert(popFirst(l) == 3)
end


Test()