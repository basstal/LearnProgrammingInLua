Exercise 6.1: Write a function that takes an array and prints all its elements. 
```
function printArray(array)
    for k, v in pairs(array) do
        print(v)
    end
end
```
Exercise 6.2: Write a function that takes an arbitrary number of values and returns all of them, except the first one. 
```
function exceptFirstOne(...)
    local d = {...}
    table.remove(d, 1)
    return table.unpack(d)
end
```
Exercise 6.3: Write a function that takes an arbitrary number of values and returns all of them, except the last one. 
```
function exceptLastOne(...)
    local d = {...}
    table.remove(d, #d)
    return table.unpack(d)
end
```
Exercise 6.4: Write a function to shuffle a given list. Make sure that all permutations are equally probable. 
```
function shuffle(t)
    local size = #t
    math.randomseed(os.time())
    for i = 1, size // 2 do
        local r1 = math.floor(math.random() * (size - 1) + 1)
        local r2 = math.floor(math.random() * (size - 1) + 1)
        t[r1], t[r2] = t[r2], t[r1]
    end
end
```
Exercise 6.5: Write a function that takes an array and prints all combinations of the elements in the array. (Hint: you can use the recursive formula for combination: C(n,m) = C(n -1, m -1) + C(n - 1, m). To generate all C(n,m) combinations of n elements in groups of size m, you first add the first element to the result and then generate all C(n - 1, m - 1) combinations of the remaining elements in the remaining slots; then you remove the first element from the result and then generate all C(n - 1, m) combinations of the remaining elements in the free slots. When n is smaller than m, there are no combinations. When m is zero, there is only one combination, which uses no elements.) 
```
function combinations(array, n, m, result)
    if m == 0 then
        print(table.unpack(result))
    elseif n >= m then
        for i = 1, #array do
            local newArray = {}
            table.move(array, 1, #array, #newArray + 1, newArray)
            table.remove(newArray, i)
            table.insert(result, array[i])
            combinations(newArray, n - 1, m - 1, result)
            table.remove(result, #result)
            combinations(newArray, n - 1, m, result)
        end
    end
end
```

Exercise 6.6: Sometimes, a language with proper-tail calls is called properly tail recursive, with the argument that this property is relevant only when we have recursive calls. (Without recursive calls, the maximum call depth of a program would be statically fixed.) Show that this argument does not hold in a dynamic language like Lua: write a program that performs an unbounded call chain without recursion. (Hint: see the section called “Compilation”.)