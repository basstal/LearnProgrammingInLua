# Getting Started #

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

## The Stand-Alone Interpreter ##

(a and b or c) (given that and has a higher precedence than or). It is equivalent to the C expression a ? b : c, provided that b is not false.
