# Metatables and Metamethods #

## Exercise 20.1 ##

Define a metamethod __sub for sets that returns the difference of two sets. (The set a - b is the set of elements from a that are not in b.)

[MetamethodSet.lua](./Resources/MetamethodSet.lua)

## Exercise 20.2 ##

Define a metamethod __len for sets so that #s returns the number of elements in the set s.

[MetamethodSet.lua](./Resources/MetamethodSet.lua)

## Exercise 20.3 ##

An alternative way to implement read-only tables might use a function as the __index metamethod. This alternative makes accesses more expensive, but the creation of read-only tables is cheaper, as all read-only tables can share a single metatable. Rewrite the function readOnly using this approach.

[ReadOnly.lua](./Resources/ReadOnly.lua)

## Exercise 20.4 ##

Proxy tables can represent other kinds of objects besides tables. file as array Write a function fileAsArray that takes the name of a file and returns a proxy to that file, so that after a call t = fileAsArray("myFile"), an access to t[i] returns the i-th byte of that file, and an assignment to t[i] updates its i-th byte.

[FileAsArray.lua](./Resources/FileAsArray.lua)

## Exercise 20.5 ##

Extend the previous example to allow us to traverse the bytes in the file with pairs(t) and get the file length with #t.

[FileAsArray.lua](./Resources/FileAsArray.lua)
