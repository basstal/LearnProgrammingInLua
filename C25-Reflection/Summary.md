# Reflection #

The debug library comprises two kinds of functions: introspective functions and hooks.

## Introspective Facilities ##

When we call debug.getinfo(foo) for a function foo, it returns a table with some data about this function. The table can have the following fields

|field|function|
|---|---|
|source| This field tells where the function was defined. If the function was defined in a string (through a call to load), source is that string. If the function was defined in a file, source is the file name prefixed with an at-sign.|
|short_src | This field gives a short version of source (up to 60 characters). It is useful for error messages.|
|linedefined| This field gives the number of the first line in the source where the function was defined.|
|lastlinedefined| This field gives the number of the last line in the source where the function was defined.|
|what| This field tells what this function is. Options are "Lua" if foo is a regular Lua function, "C" if it is a C function, or "main" if it is the main part of a Lua chunk.|
|name| This field gives a reasonable name for the function, such as the name of a global variable that stores this function.|
|namewhat| This field tells what the previous field means. This field can be "global", "local", "method", "field", or "" (the empty string). The empty string means that Lua did not find a name for the function.|
|nups| This is the number of upvalues of that function.|
|nparams| This is the number of parameters of that function.|
|isvararg| This tells whether the function is variadic (a Boolean).|
|activelines| This field is a table representing the set of active lines of the function. An active line is a line with some code, as opposed to empty lines or lines containing only comments. (A typical use of this information is for setting breakpoints. Most debuggers do not allow us to set a breakpoint outside an active line, as it would be unreachable.)|
|func| This field has the function itself.|

When we call debug.getinfo(n) for some number n, we get data about the function active at that stack level. A stack level is a number that refers to a particular function that is active at that moment. The function calling getinfo has level one, the function that called it has level two, and so on. (At level zero, we get data about getinfo itself, a C function.)

If n is larger than the number of active functions on the stack, debug.getinfo returns nil.

getinfo has an optional second parameter that selects what information to get.

|option|function|
|---|---|
|n| selects name and namewhat|
|f| selects func|
|S| selects source, short_src, what, linedefined, and lastlinedefined|
|l| selects currentline|
|L| selects activelines|
|u| selects nup, nparams, and isvararg|

debug.traceback does not print its result; instead, it returns a (potentially long) string containing the traceback

### Accessing local variables ###

```lua
function foo (a, b)
    local x
    do local c = a - b end
    local a = 1
    while true do
        local name, value = debug.getlocal(1, a)
        if not name then break end
        print(name, value)
        a = a + 1
    end
end

foo(10, 20)

-- a 10
-- b 20
-- x nil
-- a 4
```

We can also change the values of local variables, with debug.setlocal. Its first two parameters are a stack level and a variable index, like in getlocal. Its third parameter is the new value for the variable. It returns the variable name or nil if the variable index is out of scope.

### Accessing non-local variables ###

the first argument for getupvalue is not a stack level, but a function (a closure, more precisely). The second argument is the variable index.

```lua
function getvarvalue (name, level, isenv)
    local value
    local found = false
    level = (level or 1) + 1
    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if n == name then
            value = v
            found = true
        end
    end
    if found then return "local", value end
    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then return "upvalue", v end
    end
    if isenv then return "noenv" end -- avoid loop
    -- not found; get value from the environment
    local _, env = getvarvalue("_ENV", level, true)
    if env then
        return "global", env[name]
    else -- no _ENV available
        return "noenv"
    end
end
```

```lua
> local a = 4; print(getvarvalue("a")) --> local 4
> a = "xx"; print(getvarvalue("a")) --> global xx
```

The parameter level tells where on the stack the function should look; one (the default) means the immediate caller. The plus one in the code corrects the level to include the call to getvarvalue itself.

### Accessing other coroutines ###

```lua
co = coroutine.create(function ()
local x = 10
coroutine.yield()
error("some error")
end)

coroutine.resume(co)
print(debug.traceback(co))

--[[
stack traceback:
    [C]: in function 'yield'
    temp:3: in function <temp:1>

]]--
print(coroutine.resume(co)) --> false temp:4: some error

--[[
stack traceback:
    [C]: in function 'error'
    temp:4: in function <temp:1>
]]

print(debug.getlocal(co, 1, 1)) --> x 10
```

## Hooks ##

There are four kinds of events that can trigger a hook

- call events happen every time Lua calls a function;
- return events happen every time a function returns;
- line events happen when Lua starts executing a new line of code;
- count events happen after a given number of instructions. (Instructions here mean internal opcodes, which we visited briefly in the section called “Precompiled Code”.)

Lua calls all hooks with a string argument that describes the event that generated the call: "call" (or "tail call"), "return", "line", or "count". For line events, it also passes a second argument, the new line number.

we call debug.sethook with two or three arguments: the first argument is the hook function; To monitor the call, return, and line events, we add their first letters (c, r, or l) into the mask string (the second argument). To monitor the count event, we simply supply a counter as the third argument. To turn off hooks, we call sethook with no arguments.

## Profiles ##

```lua
local function hook ()
    local f = debug.getinfo(2, "f").func
    local count = Counters[f]
    if count == nil then -- first time 'f' is called?
        Counters[f] = 1
        Names[f] = debug.getinfo(2, "Sn")
    else -- only increment the counter
        Counters[f] = count + 1
    end
end
```

```lua
function getname (func)
    local n = Names[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        return string.format("%s (%s)", lc, n.name)
    else
        return lc
    end
end
```

## Sandboxing ##

```lua
local debug = require "debug"
-- maximum "steps" that can be performed
local steplimit = 1000
local count = 0 -- counter for steps
-- maximum memory (in KB) that can be used
local memlimit = 1000
-- maximum "steps" that can be performed
local steplimit = 1000
local function checkmem ()
    if collectgarbage("count") > memlimit then
        error("script uses too much memory")
    end
end
local count = 0
local function step ()
    checkmem()
    count = count + 1
    if count > steplimit then
        error("script uses too much CPU")
    end
end
-- load file
local f = assert(loadfile(arg[1], "t", {}))
debug.sethook(step, "", 100) -- set hook
f() -- run file
```

```lua
local debug = require "debug"
-- maximum "steps" that can be performed
local steplimit = 1000
local count = 0 -- counter for steps
-- set of authorized functions
local validfunc = {
    [string.upper] = true,
    [string.lower] = true,
    ... -- other authorized functions
}
local function hook (event)
    if event == "call" then
        local info = debug.getinfo(2, "fn")
        if not validfunc[info.func] then
            error("calling bad function: " .. (info.name or "?"))
        end
    end
    count = count + 1
    if count > steplimit then
        error("script uses too much CPU")
    end
end
-- load chunk
local f = assert(loadfile(arg[1], "t", {}))
debug.sethook(hook, "", 100) -- set hook
f() -- run chunk
```

As a rule of thumb, all functions from the mathematical library are safe. Most functions from the string library are safe; just be careful with resource-consuming ones. The debug and package libraries are off-limits; almost everything there can be dangerous.
