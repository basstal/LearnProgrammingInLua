# Pattern Matching #

## The Pattern-Matching Functions ##

### The function string.find ###

When string.find finds its pattern, it returns two values: the index where the match begins and the index where the match ends.

```lua
s = "hello world"
i, j = string.find(s, "hello")
print(i, j) --> 1 5
print(string.sub(s, i, j)) --> hello
print(string.find(s, "world")) --> 7 11
i, j = string.find(s, "l")
print(i, j) --> 3 3
print(string.find(s, "lll")) --> nil
```

The function string.find has two optional parameters. The third parameter is an index that tells where in the subject string to start the search. The fourth parameter, a Boolean, indicates a plain search. A plain search, as the name implies, does a plain “find substring” search in the subject, ignoring patterns

```lua
> string.find("a [word]", "[")
stdin:1: malformed pattern (missing ']')
> string.find("a [word]", "[", 1, true) --> 3 3
```

## Patterns ##

|pattern|meanings|
|---|---|
|.| all characters|
|%a| letters|
|%c| control characters|
|%d| digits|
|%g| printable characters except spaces|
|%l| lower-case letters|
|%p| punctuation characters|
|%s| space characters|
|%u| upper-case letters|
|%w| alphanumeric characters|
|%x| hexadecimal digits|

**magic characters:**``( ) . % + - * ? [ ] ^ $``

the percent sign works as an escape for these magic characters. So, '%?' matches a question mark and '%%' matches a percent sign itself.

|modifiers|meanings|
|---|---|
|+| 1 or more repetitions|
|*| 0 or more repetitions|
|-| 0 or more lazy repetitions|
|?| optional (0 or 1 occurrence)|

## Captures ##

When a pattern has captures, the function string.match returns each captured value as a separate result; in other words, it breaks a string into its captured parts.

```lua
pair = "name = Anna"
key, value = string.match(pair, "(%a+)%s*=%s*(%a+)")
print(key, value) --> name Anna
```

```lua
date = "Today is 17/7/1990"
d, m, y = string.match(date, "(%d+)/(%d+)/(%d+)")
print(d, m, y) --> 17 7 1990
```

In a pattern, an item like '%n', where n is a single digit, matches only a copy of the n-th capture.

```lua
s = [[then he said: "it's all right"!]]
q, quotedPart = string.match(s, "([\"'])(.-)%1")
print(quotedPart) --> it's all right
print(q) --> "
```

```lua
p = "%[(=*)%[(.-)%]%1%]"
s = "a = [=[[[ something ]] ]==] ]=]; print(a)"
print(string.match(s, p)) --> = [[ something ]] ]==]
```

The third use of captured values is in the replacement string of gsub. Like the pattern, the replacement string can also contain items like "%n", which are changed to the respective captures when the substitution is made. In particular, the item "%0" becomes the whole match.

```lua
print((string.gsub("hello Lua!", "%a", "%0-%0")))
--> h-he-el-ll-lo-o L-Lu-ua-a!
```

```lua
print((string.gsub("hello Lua", "(.)(.)", "%2%1")))
--> ehll ouLa
```

```lua
s = [[the \quote{task} is to \em{change} that.]]
s = string.gsub(s, "\\(%a+){(.-)}", "<%1>%2</%1>")
print(s)
--> the <quote>task</quote> is to <em>change</em> that.
```

```lua
function trim (s)
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return s
end
```
