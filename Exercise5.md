Exercise 5.1: What will the following script print? Explain.
```
sunday = "monday"; monday = "sunday"
t = {sunday = "monday", [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])
```
Exercise 5.2: Assume the following code:
a = {}; a.a = a
What would be the value of a.a.a.a? Is any a in that sequence somehow different from the others?
Now, add the next line to the previous code:
a.a.a.a = 3
What would be the value of a.a.a.a now?
```
nil
```
Exercise 5.3: Suppose that you want to create a table that maps each escape sequence for strings (the section called “Literal strings”) to its meaning. How could you write a constructor for that table?
```
local result = {}
for i = 1, 128 do 
	result[string.format("\\%03d", i)] = string.char(i)
end
```


Exercise 5.4: We can represent a polynomial a_nx ^ n + a_{n-1}x ^ {n-1} + ... + a_1x ^ 1 + a_0 in Lua as a list of its coefficients, such as {a_0, a_1, ..., a_n}. Write a function that takes a polynomial (represented as a table) and a value for x and returns the polynomial value.

```
function calPolynomial(polynomial, x, i)
    i = i or 1
    if i >= #polynomial then
        return polynomial[#polynomial] or 0
    end
    return calPolynomial(polynomial, x, i + 1) * x + polynomial[i]
end
```


Exercise 5.5: Can you write the function from the previous item so that it uses at most n additions and n multiplications (and no exponentiations)?
```
done as request
```
Exercise 5.6: Write a function to test whether a given table is a valid sequence.
```
function validSequence(t)
    local sequenceCount = #t
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count == sequenceCount
end
```
Exercise 5.7: Write a function that inserts all elements of a given list into a given position of another given list.
```
function insertAtPosition(tar, src, position)
    table.move(tar, position, #tar, position + #src)
    table.move(src, 1, #src, position, tar)
end
```

Exercise 5.8: The table library offers a function table.concat, which receives a list of strings and returns their concatenation:
```
print(table.concat({"hello", " ", "world"})) --> hello world
```
Write your own version for this function. Compare the performance of your implementation against the built-in version for large lists, with hundreds of thousands of entries. (You can use a for loop to create those large lists.)