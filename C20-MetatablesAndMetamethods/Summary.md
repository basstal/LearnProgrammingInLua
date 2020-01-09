# Metatables and Metamethods #

The string library sets a metatable for strings; all other types by default have no metatable

```lua
print(getmetatable("hi")) --> table: 0x80772e0
print(getmetatable("xuxu")) --> table: 0x80772e0
print(getmetatable(10)) --> nil
print(getmetatable(print)) --> nil
```

a table can be its own metatable, so that it describes its own individual behavior.

## Arithmetic Metamethods ##

there are metamethods for subtraction (__sub), float division (__div), floor division (__idiv), negation (__unm), modulo (__mod), and exponentiation (__pow). Similarly, there are metamethods for all bitwise operations: bitwise AND (__band), OR (__bor), exclusive OR (__bxor), NOT (__bnot), left shift (__shl), and right shift (__shr). We may define also a behavior for the concatenation operator, with the field __concat.

When looking for a metamethod, Lua performs the following steps: if the first value has a metatable with the required metamethod, Lua uses this metamethod, independently of the second value; otherwise, if the second value has a metatable with the required metamethod, Lua uses it; otherwise, Lua raises an error.

```markdown
error("attempt to 'add' a set with a non-set value", 2)
```

second argument to error (2, in this example) sets the source location in the error message to the code that called the operation.

## Relational Metamethods ##

```markdown
__eq (equal to), __lt (less than), and __le (less than or equal to).
```

```markdown
Lua translates a ~= b to not (a == b), a > b to b < a, and a >= b to b <= a.
```
this translation is incorrect when we have a partial order. This means that NaN <= x is always false, but x < NaN is also false.

The equality comparison has some restrictions. If two objects have different basic types, the equality operation results in false, without even calling any metamethod.

## Library-Defined Metamethods ##

```lua
mt.__metatable = "not your business"

s1 = Set.new{}
print(getmetatable(s1)) --> not your business
setmetatable(s1, {})
    stdin:1: cannot change protected metatable
```

When an object has a __pairs metamethod, pairs will
call it to do all its work.

## Table-Access Metamethods ##

### The __index metamethod ###

```lua
-- create the prototype with default values
prototype = {x = 0, y = 0, width = 100, height = 100}
mt.__index = prototype
```

The call rawget(t, i) does a raw access to table t, that is, a primitive access without considering metatables.

### The __newindex metamethod ###

When we assign a value to an absent index in a table, the interpreter looks for a __newindex metamethod: if there is one, the interpreter calls it instead of making the assignment.

the call rawset(t, k, v) does the equivalent to t[k] = v without invoking any metamethod.

### Tables with default values ###

```lua
local key = {} -- unique key
local mt = {__index = function (t) return t[key] end}
function setDefault (t, d)
    t[key] = d
    setmetatable(t, mt)
end
```

### Tracking table accesses ###

```lua
function track (t)
    local proxy = {} -- proxy table for 't'
    -- create metatable for the proxy
    local mt = {
        __index = function (_, k)
            print("*access to element " .. tostring(k))
            return t[k] -- access the original table
        end,
        __newindex = function (_, k, v)
            print("*update of element " .. tostring(k) ..
            " to " .. tostring(v))
            t[k] = v -- update original table
        end,
        __pairs = function ()
            return function (_, k) -- iteration function
                local nextkey, nextvalue = next(t, k)
                if nextkey ~= nil then -- avoid last value
                    print("*traversing element " .. tostring(nextkey))
                end
                return nextkey, nextvalue
            end
        end,
        __len = function () return #t end
    }
    setmetatable(proxy, mt)
    return proxy
end
```

### Read-only tables ##

```lua
function readOnly (t)
    local proxy = {}
    local mt = { -- create metatable
        __index = t,
        __newindex = function (t, k, v)
            error("attempt to update a read-only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end
```