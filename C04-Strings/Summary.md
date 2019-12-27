# Strings #

## Coercions ##

**tonumber:** By default, tonumber assumes decimal notation, but we can specify any base between 2 and 36 for the conversion.

**string.format reference:**[https://alvinalexander.com/programming/printf-format-cheat-sheet](https://alvinalexander.com/programming/printf-format-cheat-sheet)

A summary of printf format specifiers:

|格式|含义|
|---|---|
|%c|character|
|%d|decimal (integer) number (base 10)|
|%e|exponential floating-point number|
|%f|floating-point number|
|%i|integer (base 10)|
|%o|octal number (base 8)|
|%s|a string of characters|
|%u|unsigned decimal (integer) number|
|%x|number in hexadecimal (base 16)|
|%X|number in hexadecimal (base 16) uppercase|
|%%|print a percent sign|
|\%|print a percent sign|

printf special characters:

|字符|含义|
|---|---|
|\a|audible alert|
|\b|backspace|
|\f|form feed|
|\n|newline, or linefeed|
|\r|carriage return|
|\t|tab|
|\v|vertical tab|
|\\|backslash|

## The String Library ##

**string.sub:** The call string.sub(s, i, j) extracts a piece of the string s, from the i-th to the j-th character inclusive.

```markdown
> s = "[in brackets]"
> string.sub(s, 2, -2) --> in brackets
> string.sub(s, 1, 1) --> [
> string.sub(s, -1, -1) --> ]
```

```markdown
> string.rep("abc", 3) --> abcabcabc
> string.reverse("A Long Line!") --> !eniL gnoL A
> string.lower("A Long Line!") --> a long line!
> string.upper("A Long Line!") --> A LONG LINE!
```

```markdown
> string.find("hello world", "wor") --> 7 9
> string.find("hello world", "war") --> nil
```

## Unicode ##

**utf8:** The function utf8.len returns the number of UTF-8 characters (codepoints) in a given string. utf8.char and utf8.codepoint are the equivalent of string.char and string.byte in the UTF-8 world. Most functions in the utf8 library work with indices in bytes. the function utf8.offset converts a character position to a byte position. The last function in the utf8 library is utf8.codes. It allows us to iterate over the characters in a UTF-8 string. If we want to use character indices, the function utf8.offset converts a character position to a byte position.
