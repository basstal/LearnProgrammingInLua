# Coroutines #

## Exercise 24.1 ##

Rewrite the producer–consumer example in the section called “Who Is the Boss?” using a producer-driven design, where the consumer is the coroutine and the producer is the main thread.

[ProducerDrivenDesign.lua](./Resources/ProducerDrivenDesign.lua)

## Exercise 24.2 ##

Exercise 6.5 asked you to write a function that prints all combinations of the elements in a given array. Use coroutines to transform this function into a generator for combinations, to be used like here:

```lua
for c in combinations({"a", "b", "c"}, 2) do
    printResult(c)
end
```

[Combinations.lua](./Resources/Combinations.lua)
