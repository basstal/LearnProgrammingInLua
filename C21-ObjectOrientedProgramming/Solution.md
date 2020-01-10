# Object-Oriented Programming #

## Exercise 21.1 ## 

Implement a class Stack, with methods push, pop, top, and isempty.

[Stack.lua](./Resources/Stack.lua)

## Exercise 21.2 ##

Implement a class StackQueue as a subclass of Stack. Besides the inherited methods, add to this class a method insertbottom, which inserts an element at the bottom of the stack. (This method allows us to use objects of this class as queues.)

[StackQueue.lua](./Resources/StackQueue.lua)

## Exercise 21.3 ##

Reimplement your Stack class using a dual representation.

[StackDualRepresentation.lua](./Resources/StackDualRepresentation.lua)

## Exercise 21.4 ##

A variation of the dual representation is to implement objects using proxies (the section called “Tracking table accesses”). Each object is represented by an empty proxy table. An internal table maps proxies to tables that carry the object state. This internal table is not accessible from the outside, but methods use it to translate their self parameters to the real tables where they operate. Implement the Account example using this approach and discuss its pros and cons.

[Account.lua](./Resources/Account.lua)