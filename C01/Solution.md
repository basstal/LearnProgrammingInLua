
# C01-Solution #

## Exercise 1.1 ##

Run the factorial example. What happens to your program if you enter a negative number? Modify the example to avoid this problem.

``stack overflow caused``

## Exercise 1.2 ##

Run the twice example, both by loading the file with the -l option and with dofile. Which way do you prefer? 

``-l 方式需要将lua文件放到package目录下``

Exercise 1.3: Can you name other languages that use "--" for comments? 


Exercise 1.4: Which of the following strings are valid identifiers? 

```
valid: ___ _end End NULL
not valid: end until? nil one-step
```

Exercise 1.5: What is the value of the expression type(nil) == nil? (You can use Lua to check your answer.) Can you explain this result?

``
false
``

Exercise 1.6: How can you check whether a value is a Boolean without using the function type?

``
value == true or value == false
``

Exercise 1.7: Consider the following expression: 
(x and y and (not z)) or ((not y) and x)
Are the parentheses necessary? Would you recommend their use in that expression?

``
yse
``

Exercise 1.8: Write a simple script that prints its own name without knowing it in advance.

``
print(arg[0])
``