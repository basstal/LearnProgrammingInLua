# Functions #

## The function table.unpack ##

An important use for unpack is in a generic call mechanism. A generic call mechanism allows us to call any function, with any arguments, dynamically.

In Lua, if we want to call a variable function f with variable arguments in an array a, we simply write this:

```lua
f(table.unpack(a))
```

The call to unpack returns all values in a, which become the arguments to f.
