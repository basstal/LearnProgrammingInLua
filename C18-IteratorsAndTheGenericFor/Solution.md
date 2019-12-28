# Iterators And The Generic For #

## Exercise 18.1 ##

Write an iterator fromto such that the next loop becomes equivalent to a numeric for:

```lua
for i in fromto(n, m) do
    body
end
```

Can you implement it as a stateless iterator?

[FromTo.lua](./Resources/FromTo.lua)

## Exercise 18.2 ##

Add a step parameter to the iterator from the previous exercise. Can you still implement it as a stateless iterator?

```markdown
上一个练习已实现
```

## Exercise 18.3 ##

Write an iterator uniquewords that returns all words from a given file without repetitions.
(Hint: start with the allwords code in Figure 18.1, “Iterator to traverse all words from the standard input”; use a table to keep all words already reported.)

[IteratorUniquewords.lua](./Resources/IteratorUniquewords.lua)

## Exercise 18.4 ##

Write an iterator that returns all non-empty substrings of a given string.

[IteratorSubstrings.lua](./Resources/IteratorSubstrings.lua)

## Exercise 18.5 ##

Write a true iterator that traverses all subsets of a given set. (Instead of creating a new table
for each subset, it can use the same table for all its results, only changing its contents between iterations.)

``todo``