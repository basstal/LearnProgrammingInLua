# Compilation Execution And Errors #

## Exercise 16.1 ##

Frequently, it is useful to add some prefix to a chunk of code when loading it. (We saw an example previously in this chapter, where we prefixed a **return** to an expression being loaded.) Write a function loadwithprefix that works like load, except that it adds its extra first argument (a string) as a prefix to the chunk being loaded.

Like the original load, loadwithprefix should accept chunks represented both as strings and as reader functions. Even in the case that the original chunk is a string, loadwithprefix should not actually concatenate the prefix with the chunk. Instead, it should call load with a proper reader function that first returns the prefix and then returns the original chunk.

[LoadWithPrefix.lua](./Resources/LoadWithPrefix.lua)

## Exercise 16.2 ##

Write a function multiload that generalizes loadwithprefix by receiving a list of readers, as in the following example:

```lua
f = multiload("local x = 10;", io.lines("temp", "*L"), " print(x)")
```

In the above example, multiload should load a chunk equivalent to the concatenation of the string "local...", the contents of the temp file, and the string "print(x)". Like loadwithprefix, from the previous exercise, multiload should not actually concatenate anything.

[Multiload.lua](./Resources/Multiload.lua)

## Exercise 16.3 ##

The function stringrep, in Figure 16.2, “String repetition”, uses a binary multiplication algorithm to concatenate n copies of a given string s.

```lua
function stringrep (s, n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then r = r .. s end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
    return r
end
```

For any fixed n, we can create a specialized version of stringrep by unrolling the loop into a sequence of instructions r = r .. s and s = s .. s. As an example, for n = 5 the unrolling gives us the following function:

```lua
function stringrep_5 (s)
    local r = ""
    r = r .. s
    s = s .. s
    s = s .. s
    r = r .. s
    return r
end
```

Write a function that, given n, returns a specialized function stringrep_n. Instead of using a closure, your function should build the text of a Lua function with the proper sequence of instructions (a mix of r = r .. s and s = s .. s) and then use load to produce the final function. Compare the performance of the generic function stringrep (or of a closure using it) with your tailor-made functions.

[RoughStringRep.lua](./Resources/RoughStringRep.lua)

## Exercise 16.4 ##

Can you find any value for f such that the call pcall(pcall, f) returns false as its first result? Why is this relevant?

```markdown
保护调用本身是不会在正确调用的情况下把错误传递到外层，所以外层的保护调用不会出现第一个参数为false的情况
```
