# Metatables and Metamethods #

The string library sets a metatable for strings; all other types by default have no metatable

```lua
print(getmetatable("hi")) --> table: 0x80772e0
print(getmetatable("xuxu")) --> table: 0x80772e0
print(getmetatable(10)) --> nil
print(getmetatable(print)) --> nil
```

a table can be its own metatable, so that it describes its own individual behavior.

## Arithmetic Metamethods ##

there are metamethods for subtraction (__sub), float division (__div), floor division (__idiv), negation (__unm), modulo (__mod), and exponentiation (__pow). Similarly, there are metamethods for all bitwise operations: bitwise AND (__band), OR (__bor), exclusive OR (__bxor), NOT (__bnot), left shift (__shl), and right shift (__shr). We may define also a behavior for the concatenation operator, with the field __concat.

When looking for a metamethod, Lua performs the following steps: if the first value has a metatable with the required metamethod, Lua uses this metamethod, independently of the second value; otherwise, if the second value has a metatable with the required metamethod, Lua uses it; otherwise, Lua raises an error.

```markdown
error("attempt to 'add' a set with a non-set value", 2)
```

second argument to error (2, in this example) sets the source location in the error message to the code that called the operation.

## Relational Metamethods ##

```markdown
__eq (equal to), __lt (less than), and __le (less than or equal to).
```

```markdown
Lua translates a ~= b to not (a == b), a > b to b < a, and a >= b to b <= a.
```
