# BitsAndBytes #

## Exercise 13.1 ##

Write a function to compute the modulo operation for unsigned integers.

[ModuloOperation.lua](./Resources/ModuloOperation.lua)

## Exercise 13.2 ##

Implement different ways to compute the number of bits in the representation of a Lua integer.

[NumberOfBits.lua](./Resources/NumberOfBits.lua)

## Exercise 13.3 ##

How can you test whether a given integer is a power of two?

``a & 1 == 0``

## Exercise 13.4 ##

Write a function to compute the Hamming weight of a given integer. (The Hamming weight of a number is the number of ones in its binary representation.)

[HammingWeight](./Resources/HammingWeight.lua)

## Exercise 13.5 ##

Write a function to test whether the binary representation of a given integer is a palindrome.

[IsPalindromeBits](./Resources/IsPalindromeBits.lua)

## Exercise 13.6 ##

Implement a bit array in Lua. It should support the following operations:

• newBitArray(n) (creates an array with n bits),

• setBit(a, n, v) (assigns the Boolean value v to bit n of array a),

• testBit(a, n) (returns a Boolean with the value of bit n).

## Exercise 13.7 ##

Suppose we have a binary file with a sequence of records, each one with the following format:

```markdown
struct Record {
    int x;
    char[3] code;
    float value;
};
```

Write a program that reads that file and prints the sum of the value fields.

``todo``
