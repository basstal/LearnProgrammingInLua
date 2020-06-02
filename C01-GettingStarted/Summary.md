# Getting Started #

```lua
-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end
print("enter a number:")
a = io.read("*n") -- reads a number
print(fact(a))
```

## Chunks ##

**dofile:** The function dofile is useful also when we are testing a piece of code.

## Some Lexical Conventions ##

**reserved identifiers:**
||||||
|---|---|---|---|---|
|and| break| do| else| elseif|
|end| false| for| function| goto|
|if| in| local| nil| not|
|or| repeat| return| then| true|
|until| while|

## Types and Values ##

There are eight basic types in Lua:

```markdown
nil, Boolean, number, string, userdata, function, thread, and table.
```

### Booleans ###

```markdown
> 4 and 5 --> 5
> nil and 13 --> nil
> false and 13 --> false
> 0 or 5 --> 0
> false or "hi" --> "hi"
> nil or false --> false
```

Another useful idiom is ((a and b) or c) or simply (a and b or c) (given that and has a higher precedence than or). It is equivalent to the C expression a ? b : c, provided that b is not false. For instance, we can select the maximum of two numbers x and y with the expression (x > y) and x or y. When x > y, the first expression of the and is true, so the and results in its second operand (x), which is always true (because it is a number), and then the or expression results in the value of its first operand, x. When x > y is false, the and expression is false and so the or results in its second operand, y.

## The Stand-Alone Interpreter ##

(a and b or c) (given that and has a higher precedence than or). It is equivalent to the C expression a ? b : c, provided that b is not false.
