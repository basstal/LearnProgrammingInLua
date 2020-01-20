# Garbage #

## Exercise 23.1 ##

Write an experiment to determine whether Lua actually implements ephemeron tables. (Remember to call collectgarbage to force a garbage collection cycle.) If possible, try your code both in Lua 5.1 and in Lua 5.2/5.3 to see the difference.

[EphemeroTables.lua](./Resources/EphemeroTables.lua)

## Exercise 23.2 ##

Consider the first example of the section called “Finalizers”, which creates a table with a finalizer that only prints a message when activated. What happens if the program ends without a collection cycle? What happens if the program calls os.exit? What happens if the program ends with an error?

[TestFinalizers.lua](./Resources/TestFinalizers.lua)

``os.exit没有finalizer调用``

## Exercise 23.3 ##

Imagine you have to implement a memorizing table for a function from strings to strings. Making the table weak will not do the removal of entries, because weak tables do not consider strings as collectable objects. How can you implement memorization in that case?

``给每个string映射一个独立的table（弱value类型table），再用table来映射到对应的string（弱key类型table）``

## Exercise 23.4 ##

Explain the output of the program in Figure 23.3, “Finalizers and memory”.

```lua
local count = 0
local mt = {__gc = function () count = count - 1 end}
local a = {}
for i = 1, 10000 do
    count = count + 1
    a[i] = setmetatable({}, mt)
end
collectgarbage()
print(collectgarbage("count") * 1024, count)
a = nil
collectgarbage()
print(collectgarbage("count") * 1024, count)
collectgarbage()
print(collectgarbage("count") * 1024, count)
```

[FinalizersAndMemory.lua](./Resources/FinalizersAndMemory.lua)

## Exercise 23.5 ##

For this exercise, you need at least one Lua script that uses lots of memory. If you do not have one, write it. (It can be as simple as a loop creating tables.)

- Run your script with different values for pause and stepmul. How they affect the performance and memory usage of the script? What happens if you set the pause to zero? What happens if you set the pause to 1000? What happens if you set the step multiplier to zero? What happens if you set the step multiplier to 1000000?

- Adapt your script so that it keeps full control over the garbage collector. It should keep the collector stopped and call it from time to time to do some work. Can you improve the performance of your script with this approach?

[Experiment.lua](./Resources/Experiment.lua)
