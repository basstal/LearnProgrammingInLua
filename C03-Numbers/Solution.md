# Numbers #

## Exercise 3.1 ##

Which of the following are valid numerals? What are their values?

``.0e12 .e12 0.0e 0x12 0xABFG 0xA FFFF 0xFFFFFFFF 0x 0x1P10 0.1e1 0x0.1p1``

```markdown
valid:
> .0e12      ---> 0.0
> 0x12       ---> 18
> 0xA        ---> 160
> 0xFFFFFFFF ---> 4294967295
> 0x1P10     ---> 1024.0
> 0.1e1      ---> 1.0
> 0x0.1p1    ---> 0.125
```

## Exercise 3.2 ##

Explain the following results:

```markdown
> math.maxinteger * 2 				--> -2
> math.mininteger * 2 				--> 0
> math.maxinteger * math.maxinteger --> 1
> math.mininteger * math.mininteger --> 0
```

``用位运算来解释``

## Exercise 3.3 ##

What will the following program print?

```lua
for i = -10, 10 do
	print(i, i % 3)
end
```

## Exercise 3.4 ##

What is the result of the expression ``2^3^4``? What about ``2^-3^4``?

```markdown
> 2^3^4 	---> 2^81
> 2^-3^4 	---> 2^-81
```

## Exercise 3.5 ##

The number 12.7 is equal to the fraction 127/10, where the denominator is a power of ten. Can you express it as a common fraction where the denominator is a power of two? What about the number 5.5?

```markdown
> 5.5 	---> 101.1
> 12.7 	---> 1100.1011001....
```

## Exercise 3.6 ##

Write a function to compute the volume of a right circular cone, given its height and the angle between a generatrix and the axis.

## Exercise 3.7 ##

Using math.random, write a function to produce a pseudo-random number with a standard normal (Gaussian) distribution

```lua
function StandardNormalDistribution()
	math.randomseed( os.time() )
	local x =  math.random()
	return (1  / (math.pi  *  2) ^  0.5) *  math.exp( -0.5  * x ^  2)
end
```
