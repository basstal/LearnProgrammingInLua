local g = {}
local mt = { -- create metatable
    __index = function(t, k)
        return g[t][k]
    end,
    __newindex = function (t, k, v)
        error("attempt to update a read-only table", 2)
    end
}

function ReadOnly (t)
    local proxy = {}
    g[proxy] = t
    setmetatable(proxy, mt)
    return proxy
end

function Test()
    local a = {1, 2, 3, abc = 4}
    a = ReadOnly(a)
    local b = {a = a}
    -- a[1] = 2
    print(a.abc)
    print(b.a.abc)
    -- b.a.abc = 2
    b.a = 4
end

Test()