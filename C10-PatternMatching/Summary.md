# Pattern Matching #

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