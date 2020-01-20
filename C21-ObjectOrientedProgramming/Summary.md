# Object-Oriented Programming #

## Classes ##

```lua
function Account:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end
```

## Inheritance ##

```lua
SpecialAccount = Account:new()
s = SpecialAccount:new{limit=1000.00}
```

SpecialAccount inherits new from Account, like any other method. This time, however, when new executes, its self parameter will refer to SpecialAccount. Therefore, the metatable of s will be SpecialAccount, whose value at field __index is also SpecialAccount. So, s inherits from SpecialAccount, which inherits from Account.

## Multiple Inheritance ##

```lua
-- look up for 'k' in list of tables 'plist'
local function search (k, plist)
    for i = 1, #plist do
        local v = plist[i][k] -- try 'i'-th superclass
        if v then return v end
    end
end
function createClass (...)
    local c = {} -- new class
    local parents = {...} -- list of parents
    -- class searches for absent methods in its list of parents
    setmetatable(c, {__index = function (t, k)
        return search(k, parents)
    end})
    -- prepare 'c' to be the metatable of its instances
    c.__index = c
    -- define a new constructor for this new class
    function c:new (o)
        o = o or {}
        setmetatable(o, c)
        return o
    end
    return c -- return new class
end
```

A simple way to improve this performance is to copy inherited methods into the subclasses.

```lua
setmetatable(c, {__index = function (t, k)
    local v = search(k, parents)
    t[k] = v -- save for next access
    return v
end})
```

## Privacy ##

The basic idea of this alternative design is to represent each object through two tables: one for its state and another for its operations, or its interface. We access the object itself through the second table, that is, through the operations that compose its interface. To avoid unauthorized access, the table representing the state of an object is not kept in a field of the other table; instead, it is kept only in the closure of the methods.

## The Single-Method Approach ##

it is worth remembering iterators like io.lines or string.gmatch. An iterator that keeps state internally is nothing more than a single-method object.

## Dual Representation ##

```lua
function Account.withdraw (self, v)
    balance[self] = balance[self] - v
end
```

The access balance[self] can be slightly slower than self.balance, because the latter uses a local variable while the first uses an external variable.
