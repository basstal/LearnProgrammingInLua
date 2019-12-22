# Numbers #

## Numerals ##

**math.type:** In the rare occasions when we need to distinguish between floats and integers, we can use math.type.

## Arithmetic Operators ##

- division always operates on floats and gives float results.

- floor division（//） always rounds the quotient towards minus infinity, ensuring an integral result for all operands.

- a % b == a - ((a // b) * b). if both operands are integers, the result is an integer; otherwise, the result is a float.

```markdown
> x = math.pi
> x - x%0.01                --> 3.14
> x - x%0.001               --> 3.141
> math.sin(math.pi / 2)     --> 1.0
> math.max(10.4, 7, -3, 20) --> 20
> math.huge                 --> inf
```

## The Mathematical Library ##

**math.random:** generates pseudo-random numbers. We can call it in three ways. When we call it without arguments, it returns a pseudo-random real number with uniform distribution in the interval [0,1). When we call it with only one argument, an integer n, it returns a pseudo-random integer in the interval [1,n]. For instance, we can simulate the result of tossing a die with the call random(6). Finally, we can call random with two integer arguments, l and u, to get a pseudo-random integer in the interval [l,u].

## Conversions ##

**math.tointeger:** which returns nil when the number cannot be converted.
