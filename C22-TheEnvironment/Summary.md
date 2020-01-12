# The Environment #

In a first approximation, we can think that Lua keeps all its global variables in a regular table, called the global environment. Later in this chapter, we will see that Lua can keep its “global” variables in several environments.

## Global Variables with Dynamic Names ##

```lua
function getfield (f)
    local v = _G -- start with the table of globals
    for w in string.gmatch(f, "[%a_][%w_]*") do
        v = v[w]
    end
    return v
end
```

```lua
function setfield (f, v)
    local t = _G -- start with the table of globals
    for w, d in string.gmatch(f, "([%a_][%w_]*)(%.?)") do
        if d == "." then -- not last name?
            t[w] = t[w] or {} -- create table if absent
            t = t[w] -- get the table
        else -- last name
            t[w] = v -- do the assignment
        end
    end
end
```

## Global-Variable Declarations ##

```lua
__newindex = function (t, n, v)
    local w = debug.getinfo(2, "S").what
    if w ~= "main" and w ~= "C" then
        error("attempt to write to undeclared variable " .. n, 2)
    end
    rawset(t, n, v)
end
```


```lua
local declaredNames = {}
setmetatable(_G, {
    __newindex = function (t, n, v)
        if not declaredNames[n] then
            local w = debug.getinfo(2, "S").what
            if w ~= "main" and w ~= "C" then
                error("attempt to write to undeclared variable "..n, 2)
            end
            declaredNames[n] = true
        end
        rawset(t, n, v) -- do the actual set
    end,
    __index = function (_, n)
        if not declaredNames[n] then
            error("attempt to read undeclared variable "..n, 2)
        else
            return nil
        end
    end,
})
```

## Non-Global Environments ##

Now comes the important part: The Lua compiler translates any free name x in the chunk to _ENV.x.

```lua
local z = 10
_ENV.x = _ENV.y + z -- x = y + z
```

Lua compiles our original chunk as the following code

```lua
local _ENV = some value
return function (...)
    local z = 10
    _ENV.x = _ENV.y + z
end
```

- The compiler creates a local variable _ENV outside any chunk that it compiles.
- The compiler translates any free name var to _ENV.var.
- The function load (or loadfile) initializes the first upvalue of a chunk with the global environment, which is a regular table kept internally by Lua.

## Using _ENV ##

The assignment _ENV = nil will invalidate any direct access to global variables in the rest of the chunk.

```lua
local print, sin = print, math.sin
_ENV = nil
print(13) --> 13
print(sin(13)) --> 0.42016703682664
print(math.cos(13)) -- error!
```

_ENV is a local variable, and all accesses to “global variables” in reality are accesses to it. _G is a global variable with no special status whatsoever.

The main use for _ENV is to change the environment used by a piece of code.

```lua
-- change current environment to a new empty table
_ENV = {}
a = 1 -- create a field in _ENV
print(a)
--> stdin:4: attempt to call global 'print' (a nil value)
```

```lua
a = 15 -- create a global variable
_ENV = {g = _G} -- change current environment
a = 1 -- create a field in _ENV
g.print(_ENV.a, g.a) --> 1 15
```

_ENV follows the usual scoping rules. In particular, functions defined inside a chunk access _ENV as they access any other external variable

```lua
_ENV = {_G = _G}
local function foo ()
    _G.print(a) -- compiled as '_ENV._G.print(_ENV.a)'
end
a = 10
foo() --> 10
_ENV = {_G = _G, a = 20}
foo() --> 20
```

```lua
a = 2
do
    local _ENV = {print = print, a = 14}
    print(a) --> 14
end
print(a) --> 2 (back to the original _ENV)
```

## Environments and Modules ##

We can declare all public functions as global variables and they will go to a separate table automatically. All the module has to do is to assign this table to the _ENV variable.

```lua
local M = {}
_ENV = M
function add (c1, c2)
    return new(c1.r + c2.r, c1.i + c2.i)
end
```


```lua
-- module setup
local M = {}
-- Import Section:
-- declare everything this module needs from outside
local sqrt = math.sqrt
local io = io
-- no more external access after this point
_ENV = nil
```

## _ENV and load ##

```lua
env = {}
loadfile("config.lua", "t", env)()
```

we may want to run a chunk several times, each time with a different environment table. In that case, the extra argument to load is not useful. Instead, we have two other options.

The first option is to use the function debug.setupvalue, from the debug library. As its name implies, setupvalue allows us to change any upvalue of a given function.

```lua
f = load("b = 10; return a")
env = {a = 20}
debug.setupvalue(f, 1, env)
print(f()) --> 20
print(env.b) --> 10
```

when a function represents a chunk, Lua assures that it has only one upvalue and that this upvalue is _ENV.

Another option to run a chunk with several different environments is to twist the chunk a little when loading it.

```lua
prefix = "_ENV = ...;"
f = loadwithprefix(prefix, io.lines(filename, "*L"))
...
env1 = {}
f(env1)
env2 = {}
f(env2)
```
