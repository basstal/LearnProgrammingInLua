# PatternMatching #

## Exercise 10.1 ##

Write a function split that receives a string and a delimiter pattern and returns a sequence with the chunks in the original string separated by the delimiter:

```markdown
t = split("a whole new world", " ")

-- t = {"a", "whole", "new", "world"}
```

How does your function handle empty strings? (In particular, is an empty string an empty sequence or a sequence with one empty string?)

```lua
function split(src, splitter)
    local pattern = string.format("%s+",splitter )
    local i, j = string.find( src, pattern)
    local result = {}
    while i ~= nil do
        local word = string.sub(src, 1, i - 1)
        table.insert(result, word)
        src = string.sub(src, j + 1)
        i, j = string.find(src, pattern)
    end
    table.insert(result, src)
    return result
end
```

## Exercise 10.2 ##

The patterns '%D' and '[^%d]' are equivalent. What about the patterns '[^%d%u]' and '[%D%U]'?

``They are not equivalent``

## Exercise 10.3 ##

Write a function transliterate. This function receives a string and replaces each character in that string with another character, according to a table given as a second argument.If the table maps a to b, the function should replace any occurrence of a with b. If the table maps a to false, the function should remove occurrences of a from the resulting string.

```lua
function replacement(src, givenTable)
    return string.gsub( src , ".", function(a)
        if givenTable[a] == false then
            return ""
        elseif givenTable[a] ~= nil then
            return tostring(givenTable[a])
        end
    end)
end
```

## Exercise 10.4 ##

At the end of the section called “Captures”, we defined a trim function. Because of its use of backtracking, this function can take a quadratic time for some strings. (For instance, in my new machine, a match for a 100 KB string can take 52 seconds.)

- Create a string that triggers this quadratic behavior in function trim.
- Rewrite that function so that it always works in linear time.

## Exercise 10.5 ##

Write a function to format a binary string as a literal in Lua, using the escape sequence \x for all bytes:

```markdown
print(escape("\0\1hello\200"))

--> \x00\x01\x68\x65\x6C\x6C\x6F\xC8
```

As an improved version, use also the escape sequence \z to break long lines.

```lua
function escape(src)
    return string.gsub(src, ".", function(m)
        return string.format("\\x%02X", string.byte(m))
    end)
end
```

## Exercise 10.6 ##

Rewrite the function transliterate for UTF-8 characters.

```lua
function replacement(src, givenTable)
    return string.gsub( src , utf8.charpattern, function(a)
        if givenTable[a] == false then
            return ""
        elseif givenTable[a] ~= nil then
            return tostring(givenTable[a])
        end
    end)
end
```

## Exercise 10.7 ##

Write a function to reverse a UTF-8 string.

```lua
function utf8Reverse(src)
    local reverseTable = {}
    for c in string.gmatch(src, utf8.charpattern) do
        table.insert(reverseTable, 1, c)
    end
    return table.concat( reverseTable)
end
```
