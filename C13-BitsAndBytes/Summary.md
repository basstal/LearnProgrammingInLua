# Bits And Bytes #

## Unsigned Integers ##

- **math.ult:** 按无符号整数的二进制大小比较两个值。

- [无符号整数的除法](./Resources/UnsignedDivision.lua)

- 无符号整数和浮点数之间转换方式：

```markdown
> u = 11529215046068469760 -- an example
> f = (u + 0.0) % 2^64
> string.format("%.0f", f) --> 11529215046068469760
```

```markdown
> f = 0xA000000000000000.0 -- an example
> u = math.tointeger(((f + 2^63) % 2^64) - 2^63)
> string.format("%x", u) --> a000000000000000
```
