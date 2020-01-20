# Coroutines #

The main difference between threads and coroutines is that a multithreaded program runs several threads in parallel, while coroutines are collaborative: at any given time, a program with coroutines is running only one of its coroutines, and this running coroutine suspends its execution only when it explicitly requests to be suspended.

## Coroutine Basics ##

The function create creates new coroutines. It has a single argument, a function with the code that the coroutine will run (the coroutine body). It returns a value of type "thread", which represents the new coroutine.

```lua
co = coroutine.create(function () print("hi") end)
print(type(co)) --> thread
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> hi
```

```lua
co = coroutine.create(function ()
    for i = 1, 10 do
        print("co", i)
        coroutine.yield()
    end
end)
coroutine.resume(co) --> co 2
coroutine.resume(co) --> co 3
...
coroutine.resume(co) --> co 10
coroutine.resume(co) -- prints nothing
print(coroutine.resume(co))
--> false cannot resume dead coroutine
```

Note that resume runs in protected mode, like pcall. Therefore, if there is any error inside a coroutine, Lua will not show the error message, but instead will return it to the resume call.

```lua
co = coroutine.create(function (a, b, c)
    print("co", a, b, c + 2)
end)
coroutine.resume(co, 1, 2, 3) --> co 1 2 5

co = coroutine.create(function (a,b)
    coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10)) --> true 30 10
```

coroutine.yield returns any extra arguments passed to the corresponding resume

```lua
co = coroutine.create (function (x)
    print("co1", x)
    print("co2", coroutine.yield())
end)
coroutine.resume(co, "hi") --> co1 hi
coroutine.resume(co, 4, 5) --> co2 4 5

co = coroutine.create(function ()
    return 6, 7
end)
print(coroutine.resume(co)) --> true 6 7
```

## Who Is the Boss ##

```lua
function receive (prod)
    local status, value = coroutine.resume(prod)
    return value
end

function send (x)
    coroutine.yield(x)
end

function producer ()
    return coroutine.create(function ()
        while true do
            local x = io.read() -- produce new value
            send(x)
        end
    end)
end

function filter (prod)
    return coroutine.create(function ()
        for line = 1, math.huge do
            local x = receive(prod) -- get new value
            x = string.format("%5d %s", line, x)
            send(x) -- send it to consumer
        end
    end)
end

function consumer (prod)
    while true do
        local x = receive(prod) -- get new value
        io.write(x, "\n") -- consume new value
    end
end

consumer(filter(producer()))
```

## Coroutines as Iterators ##

```lua
function permgen (a, n)
    n = n or #a -- default for 'n' is size of 'a'
    if n <= 1 then -- nothing to change?
        coroutine.yield(a)
    else
        for i = 1, n do
            -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]
            -- generate all permutations of the other elements
            permgen(a, n - 1)
            -- restore i-th element
            a[n], a[i] = a[i], a[n]
        end
    end
end

function permutations (a)
    local co = coroutine.create(function () permgen(a) end)
    return function () -- iterator
        local code, res = coroutine.resume(co)
        return res
    end
end
```

This pattern is so common that Lua provides a special function for it: coroutine.wrap. Like create, wrap creates a new coroutine. Unlike create, wrap does not return the coroutine itself; instead, it returns a function that, when called, resumes the coroutine. Unlike the original resume, that function does not return an error code as its first result; instead, it raises the error in case of error.

```lua
function permutations (a)
    return coroutine.wrap(function () permgen(a) end)
end
```

## Event-Driven Programming ##

```lua
local lib = require "async-lib"
function run (code)
    local co = coroutine.wrap(function ()
        code()
        lib.stop() -- finish event loop when done
    end)
    co() -- start coroutine
    lib.runloop() -- start event loop
end
function putline (stream, line)
    local co = coroutine.running() -- calling coroutine
    local callback = (function () coroutine.resume(co) end)
    lib.writeline(stream, line, callback)
    coroutine.yield()
end
function getline (stream, line)
    local co = coroutine.running() -- calling coroutine
    local callback = (function (l) coroutine.resume(co, l) end)
    lib.readline(stream, callback)
    local line = coroutine.yield()
    return line
end
```
