local Set = {}

function Set.union (a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection (a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.difference(a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = nil end
    return res
end

-- presents a set as a string
function Set.tostring (set)
    local l = {} -- list to put all elements from the set
    for e in pairs(set) do
        l[#l + 1] = tostring(e)
    end
    return "{" .. table.concat(l, ", ") .. "}"
end

function Set.len(set)
    local count = 0
    for k in pairs(set) do
        count = count + 1
    end
    return count
end

local mt = {
    __add = Set.union,
    __mul = Set.intersection,
    __tostring = Set.tostring,
    __sub = Set.difference,
    __len = Set.len,
}

-- create a new set with the values of a given list
function Set.new (l)
    local set = {}
    setmetatable(set, mt)
    print(getmetatable(set))
    for _, v in ipairs(l) do set[v] = true end
    return set
end

-- return Set


function Test()
    local a = Set.new{1,2,3,5}
    local b = Set.new{1,2,3,5}
    local c = Set.new{3,5}
    print(a - b)
    print(a - c)
    print(#a)
    print(#b)
    print(#(a - c))
end

Test()