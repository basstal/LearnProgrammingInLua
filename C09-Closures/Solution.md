# Closures #

## Exercise 9.1 ##

Write a function integral that takes a function f and returns an approximation of its integral.

## Exercise 9.2 ##

What will be the output of the following chunk:

```lua
function F (x)
	return {
		set = function (y) x = y end,
		get = function () return x end
	}
end
o1 = F(10)
o2 = F(20)
print(o1.get(), o2.get())
o2.set(100)
o1.set(300)
print(o1.get(), o2.get())
```

## Exercise 9.3 ##

Exercise 5.4 asked you to write a function that receives a polynomial (represented as a table) and a value for its variable, and returns the polynomial value. Write the curried version of that function. Your function should receive a polynomial and return a function that, when called with a value for x, returns the value of the polynomial for that x. See the example:

```markdown
f = newpoly({3, 0, 1})
print(f(0))     --> 3
print(f(5))     --> 28
print(f(10))    --> 103
```

```lua
function calPolynomial(polynomial, x, i)
    i = i or 1
    if i >= #polynomial then
        return polynomial[#polynomial] or 0
    end
    return calPolynomial(polynomial, x, i + 1) * x + polynomial[i]
end

function newpoly(polynomial)
    return function(x, i)
        return calPolynomial(polynomial, x, i)
    end
end
```

## Exercise 9.4 ##

Using our system for geometric regions, draw a waxing crescent moon as seen from the Northern Hemisphere.

## Exercise 9.5 ##

In our system for geometric regions, add a function to rotate a given region by a given angle.
