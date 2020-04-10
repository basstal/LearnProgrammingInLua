# Reflection #

## Exercise 25.1 ##

Adapt getvarvalue (Figure 25.1, “Getting the value of a variable”) to work with different coroutines (like the functions from the debug library).

``todo``

[Getvarvalue.lua](./Resources/Getvarvalue.lua)

## Exercise 25.2 ##

Write a function setvarvalue similar to getvarvalue (Figure 25.1, “Getting the value of a variable”).

[Setvarvalue.lua](./Resources/Setvarvalue.lua)

## Exercise 25.3 ##

Write a version of getvarvalue (Figure 25.1, “Getting the value of a variable”) that returns a table with all variables that are visible at the calling function. (The returned table should not include environmental variables; instead, it should inherit them from the original environment.)

[Getvarvalue1.lua](./Resources/Getvarvalue1.lua)

## Exercise 25.4 ##

Write an improved version of debug.debug that runs the given commands as if they were in the lexical scope of the calling function. (Hint: run the commands in an empty environment and use the __index metamethod attached to the function getvarvalue to do all accesses to variables.)

``todo``

[DebugImplement.lua](./Resources/DebugImplement.lua)

## Exercise 25.5 ##

Improve the previous exercise to handle updates, too.

``todo``

## Exercise 25.6 ##

Implement some of the suggested improvements for the basic profiler that we developed in the section called “Profiles”.

[Profiles.lua](./Resources/Profiles.lua)

## Exercise 25.7 ##

Write a library for breakpoints. It should offer at least two functions:

```lua
setbreakpoint(function, line) --> returns handle
removebreakpoint(handle)
```

We specify a breakpoint by a function and a line inside that function. When the program hits a breakpoint, the library should call debug.debug. (Hint: for a basic implementation, use a line hook that checks whether it is in a breakpoint; to improve performance, use a call hook to trace program execution and only turn on the line hook when the program is running the target function.)

## Exercise 25.8 ##

One problem with the sandbox in Figure 25.6, “Using hooks to bar calls to unauthorized functions” is that sandboxed code cannot call its own functions. How can you correct this problem?
