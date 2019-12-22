# C04-Solution #

## Exercise 4.1 ##

How can you embed the following fragment of XML as a string in a Lua program?

``<![CDATA[ Hello world ]]>``

Show at least two different ways

```markdown
1. [=[<![CDATA[ Hello world ]]>]=]
2. "<![CDATA[ Hello world ]]>"
```

## Exercise 4.2 ##

Suppose you need to write a long sequence of arbitrary bytes as a literal string in Lua. What format would you use? Consider issues like readability, maximum line length, and size.

## Exercise 4.3 ##

Write a function to insert a string into a given position of another one:

```markdown
> insert("hello world", 1, "start: ")   --> start: hello world
> insert("hello world", 7, "small ")    --> hello small world
```

```lua
function insert(src, index, toInsert)
	local prefix = src:sub(1, index - 1)
	local postfix = src:sub(index, -1)
	return prefix .. toInsert .. postfix
end
```

## Exercise 4.4 ##

Redo the previous exercise for UTF-8 strings:

```markdown
> insert("ação", 5, "!") --> ação!
```

(Note that the position now is counted in codepoints.)

```lua
function insert(src, index, toInsert)
	local offset = utf8.offset(src, index) or utf8.len(src)

	local prefix = src:sub(1, offset - 1)
	local postfix = src:sub(offset, -1)
	return prefix .. toInsert .. postfix
end
```

## Exercise 4.5 ##

Write a function to remove a slice from a string; the slice should be given by its initial position and its length:

```markdown
> remove("hello world", 7, 4) --> hello d
```

```lua
function remove(src, bg, len)
	local prefix = src:sub(1, bg -  1)
	local postfix = src:sub(bg + len +  1, -1)
	return prefix .. postfix
end
```

## Exercise 4.6 ##

Redo the previous exercise for UTF-8 strings:

```markdown
> remove("ação", 2, 2) --> ao
```

(Here, both the initial position and the length should be counted in codepoints.)

```lua
function remove(src, bg, len)
	local bgBytePos = utf8.offset(src, bg)
	local edBytePos = utf8.offset(src, bg + len)
	local prefix = src:sub(1, bgBytePos -  1)
	local postfix = src:sub(edBytePos, -1)
	return prefix .. postfix
end
```

## Exercise 4.7 ##

Write a function to check whether a given string is a palindrome:

```markdown
> ispali("step on no pets")     --> true
> ispali("banana")              --> false
```

```lua
function ispali(src)
	return  string.reverse( src ) == src
end
```

## Exercise 4.8 ##

Redo the previous exercise so that it ignores differences in spaces and punctuation.

```lua
function ispali(src)
    src = string.gsub( src, "%p","")
    src = string.gsub( src, "%s","")
    return string.reverse( src ) == src
end
```

## Exercise 4.9 ##

Redo the previous exercise for UTF-8 strings.

```lua
function ispali(src)
    src = string.gsub( src, "%p","")
    src = string.gsub( src, "%s","")
    local len = utf8.len(src)
    local halfLen = len // 2
    local start = 1
    local sub1 = 1
    local esub2 = -1
    while start <= halfLen do
        local sub2 = utf8.offset(src, start + 1)
        local cp1 = string.sub(src, sub1, sub2 - 1)

        sub1 = sub2
        local esub1 = utf8.offset(src, - start)
        local cp2 = string.sub(src, esub1, esub2)
        esub2 = esub1 - 1

        start = start + 1
        if cp1 ~= cp2 then
            return false
        end
    end
    return true
end
```
