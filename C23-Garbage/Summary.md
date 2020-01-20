# Garbage #

## Weak Tables ##

Under normal circumstances, the garbage collector does not collect objects that appear as keys or as values of an accessible table. That is, both keys and values are strong references, as they prevent the reclamation of objects they refer to. In a weak table, both keys and values can be weak. This means that there are three kinds of weak tables: tables with weak keys, tables with weak values, and tables where both keys and values are weak. Irrespective of the kind of table, when a key or a value is collected the whole entry disappears from the table.

```lua
a = {}
mt = {__mode = "k"}
setmetatable(a, mt) -- now 'a' has weak keys
key = {} -- creates first key
a[key] = 1
key = {} -- creates second key
a[key] = 2
collectgarbage() -- forces a garbage collection cycle
for k, v in pairs(a) do print(v) end
--> 2
```

Notice that only objects can be removed from a weak table. Values, such as numbers and Booleans, are not collectible.

strings are values, not objects. Therefore, like a number or a Boolean, a string key is not removed from a weak table unless its associated value is collected.

## Memorize Functions ##

```lua
local results = {}
setmetatable(results, {__mode = "v"}) -- make values weak
function createRGB (r, g, b)
    local key = string.format("%d-%d-%d", r, g, b)
    local color = results[key]
    if color == nil then
        color = {red = r, green = g, blue = b}
        results[key] = color
    end
    return color
end
```

## Object Attributes ##

## Revisiting Tables with Default Values ##

```lua
local defaults = {}
setmetatable(defaults, {__mode = "k"})
local mt = {__index = function (t) return defaults[t] end}
function setDefault (t, d)
    defaults[t] = d
    setmetatable(t, mt)
end
```

```lua
local metas = {}
setmetatable(metas, {__mode = "v"})
function setDefault (t, d)
    local mt = metas[d]
    if mt == nil then
        mt = {__index = function () return d end}
        metas[d] = mt -- memorize
    end
    setmetatable(t, mt)
end
```

## Ephemeron Tables ##

```lua
do
    local mem = {} -- memorization table
    setmetatable(mem, {__mode = "k"})
    function factory (o)
        local res = mem[o]
        if not res then
            res = (function () return o end)
            mem[o] = res
        end
        return res
    end
end
```

Note that the value (the constant function) associated with an object in mem refers back to its own key (the object itself). Although the keys in that table are weak, the values are not. From a standard interpretation of weak tables, nothing would ever be removed from that memorizing table.

a table with weak keys and strong values is an ephemeron table. In an ephemeron table, the accessibility of a key controls the accessibility of its corresponding value. More specifically, consider an entry (k,v) in an ephemeron table. The reference to v is only strong if there is some other external reference to k. Otherwise, the collector will eventually collect k and remove the entry from the table, even if v refers (directly or indirectly) to k.

## Finalizers ##

A finalizer is a function associated with an object that is called when that object is about to be collected. Lua implements finalizers through the metamethod __gc

```lua
o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})
o = nil
collectgarbage() --> hi
```

```lua
o = {x = "hi"}

mt = {}
setmetatable(o, mt)
mt.__gc = function (o) print(o.x) end
o = nil
collectgarbage() --> (prints nothing)

-- ** 与上面对照
mt = {__gc = true}
setmetatable(o, mt)
mt.__gc = function (o) print(o.x) end
o = nil
collectgarbage() --> hi
```

When the collector finalizes several objects in the same cycle, it calls their finalizers in the reverse order that the objects were marked for finalization.

```lua
mt = {__gc = function (o) print(o[1]) end}
list = nil
for i = 1, 3 do
list = setmetatable({i, link = list}, mt)
end
list = nil
collectgarbage()
--> 3
--> 2
--> 1
```

```lua
A = {x = "this is A"}
B = {f = A}
setmetatable(B, {__gc = function (o) print(o.f.x) end})
A, B = nil
collectgarbage() --> this is A
```

Because of resurrection, Lua collects objects with finalizers in two phases. The first time the collector detects that an object with a finalizer is not reachable, the collector resurrects the object and queues it to be finalized. Once its finalizer runs, Lua marks the object as finalized. The next time the collector detects that the object is not reachable, it deletes the object. If we want to ensure that all garbage in our program has been actually released, we must call collectgarbage twice; the second call will delete the objects that were finalized during the first call.

If an object is not collected until the end of a program, Lua will call its finalizer when the entire Lua state is closed. This last feature allows a form of atexit functions in Lua, that is, functions that will run immediately before the program terminates.

```lua
local t = {__gc = function ()
    -- your 'atexit' code comes here
    print("finishing Lua program")
end}
setmetatable(t, t)
_G["*AA*"] = t
```

Another interesting technique allows a program to call a given function every time Lua completes a collection cycle.

```lua
do
    local mt = {__gc = function (o)
        -- whatever you want to do
        print("new cycle")
        -- creates new object for next cycle
        setmetatable({}, getmetatable(o))
    end}
    -- creates first object
    setmetatable({}, mt)
end
collectgarbage() --> new cycle
collectgarbage() --> new cycle
collectgarbage() --> new cycle
```

## The Garbage Collector ##

Each cycle comprises four phases: mark, cleaning, sweep, and finalization.

## Controlling the Pace of Collection ##

The function collectgarbage allows us to exert some control over the garbage collector.

||The options for the first argument|
|---|---|
|"stop" | stops the collector until another call to collectgarbage with the option "restart".|
|"restart"|restarts the collector.|
|"collect" | performs a complete garbage-collection cycle, so that all unreachable objects are collected and finalized. This is the default option.|
|"step" | performs some garbage-collection work. The second argument, data, specifies the amount of work, which is equivalent to what the collector would do after allocating data bytes.|
|"count" | returns the number of kilobytes of memory currently in use by Lua. This result is a floating-point number that multiplied by 1024 gives the exact total number of bytes. The count includes dead objects that have not yet been collected.|
|"setpause" | sets the collector's pause parameter. The data parameter gives the new value in percentage points: when data is 100, the parameter is set to 1 (100%).|
|"setstepmul" | sets the collector's step multiplier (stepmul) parameter. The new value is given by data, also in percentage points.|

The pause parameter controls how long the collector waits between finishing a collection and starting a new one. A pause of zero makes Lua start a new collection as soon as the previous one ends. A pause of 200% waits for memory usage to double before restarting the collector. We can set a lower pause if we want to trade more CPU time for lower memory usage. Typically, we should keep this value between 0 and 200%.

The step-multiplier parameter (stepmul) controls how much work the collector does for each kilobyte of memory allocated. The higher this value the less incremental the collector. A huge value like 100000000% makes the collector work like a non-incremental collector. The default value is 200%. Values lower than 100% make the collector so slow that it may never finish a collection.
