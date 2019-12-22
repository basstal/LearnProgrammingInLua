# ProgrammingInLua
# types
- There are eight basic types in Lua: 
``
nil, Boolean, number, string, userdata, function, thread, and table. 
``
# idiom

- (a and b or c) (given that and has a higher precedence than or). It is equivalent to the C expression a ? b : c, provided that b is not false.

# useful function
**dofile：** The function dofile is useful also when we are testing a piece of code.
**math.type：** In the rare occasions when we need to distinguish between floats and integers, we can use math.type.
**math.tointeger：** which returns nil when the number cannot be converted
**tonumber：** By default, tonumber assumes decimal notation, but we can specify any base between 2 and 36 for the conversion:
**string.format reference：**[https://alvinalexander.com/programming/printf-format-cheat-sheet](https://alvinalexander.com/programming/printf-format-cheat-sheet)
**utf8：** The function utf8.len returns the number of UTF-8 characters (codepoints) in a given string. utf8.char and utf8.codepoint are the equivalent of string.char and string.byte in the UTF-8 world. Most functions in the utf8 library work with indices in bytes. the function utf8.offset converts a character position to a byte position. The last function in the utf8 library is utf8.codes. It allows us to iterate over the characters in a UTF-8 string. If we want to use character indices, the function utf8.offset converts a character position to a byte position:
**string.sub： ** The call string.sub(s, i, j) extracts a piece of the string s, from the i-th to the j-th character inclusive.

# mathematics
- division always operates on floats and gives float results:
- floor division（//） always rounds the quotient towards minus infinity, ensuring an integral result for all operands.
- a % b == a - ((a // b) * b). if both operands are integers, the result is an integer; otherwise, the result is a float
```
> x = math.pi 
> x - x%0.01 --> 3.14 
> x - x%0.001 --> 3.141
> math.sin(math.pi / 2) --> 1.0 
> math.max(10.4, 7, -3, 20) --> 20 
> math.huge --> inf
```

The math.random function generates pseudo-random numbers. We can call it in three ways. When we call it without arguments, it returns a pseudo-random real number with uniform distribution in the interval [0,1). When we call it with only one argument, an integer n, it returns a pseudo-random integer in the interval [1,n]. For instance, we can simulate the result of tossing a die with the call random(6). Finally, we can call random with two integer arguments, l and u, to get a pseudo-random integer in the interval [l,u].
# table

- Due to the way that Lua implements tables, the order that elements appear in a traversal is undefined. The same program can produce different orders each time it runs. The only certainty is that each element will appear once during the traversal.
- Safe Navigation
```
E = {}     -- can be reused in other similar expressions
...
zip = (((company or E).director or E).address or E).zipcode
```
- The call table.move(a, f, e, t) moves the elements in table a from index f until e (both inclusive) to position t. For instance, to insert an element in the beginning of a list a, we can do the following:
```
table.move(a, 1, #a, 2)
a[1] = newElement 
```
The next code removes the first element:
```
table.move(a, 2, #a, 1)
a[#a] = nil
```
We can call table.move with an extra optional parameter, a table. In that case, the function moves the
elements from the first table into the second one. For instance, the call table.move(a, 1, #a, 1,
{}) returns a clone of list a (by copying all its elements into a new list), while table.move(a, 1,
#a, #b + 1, b) appends all elements from list a to the end of list b.

# table.unpack

An important use for unpack is in a generic call mechanism. A generic call mechanism allows us to call any function, with any arguments, dynamically.

In Lua, if we want to call a variable function f with variable arguments in an array a, we simply write this: 
```
f(table.unpack(a)) 
```
The call to unpack returns all values in a, which become the arguments to f.

# I/O

A typical idiom to check for errors is to use the function assert: 
``
local f = assert(io.open(filename, mode))
``

The I/O library offers handles for the three predefined C streams, called io.stdin, io.stdout, and io.stderr.

The function open returns a new stream over the file. In case of error, open returns nil, plus an error message and a system-dependent error number

The seek method can both get and set the current position of a stream in a file. Its general form is f:seek(whence, offset), where the whence parameter is a string that specifies how to interpret the offset.
The default value for whence is "cur" and for offset is zero. Therefore, the call file:seek() returns the current stream position, without changing it; the call file:seek("set") resets the position to the beginning of the file (and returns zero); and the call file:seek("end") sets the position to the end of the file and returns its size.

The function os.execute runs a system command; it is equivalent to the C function system. It takes a string with the command and returns information regarding how the command terminated. The first result is a Boolean: true means the program exited with no errors. The second result is a string: "exit" if the program terminated normally or "signal" if it was interrupted by a signal. A third result is the return status (if the program terminated normally) or the number of the signal that terminated the program.