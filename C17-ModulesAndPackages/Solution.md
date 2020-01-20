# ModulesAndPackages #

## Exercise 17.1 ##

Rewrite the implementation of double-ended queues (Figure 14.2, “A double-ended queue”) as a proper module.

[ADoubleEndedQueue.lua](./Resources/ADoubleEndedQueue.lua)

## Exercise 17.2 ##

Rewrite the implementation of the geometric-region system (the section called “A Taste of Functional Programming”) as a proper module.

``todo``

## Exercise 17.3 ##

What happens in the search for a library if the path has some fixed component (that is, a component without a question mark)? Can this behavior be useful?

```markdown
定向到指定文件，而不根据需要搜索的文件名来定向。作用的话...有点迷，可能可以防止完全找不到文件的其他错误吧，通过指定的文件来做统一的错误处理之类的。
```

## Exercise 17.4 ##

Write a searcher that searches for Lua files and C libraries at the same time. For instance, the path used for this searcher could be something like this:

``./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua``

(Hint: use package.searchpath to find a proper file and then try to load it, first with loadfile and next with package.loadlib.)

[Searcher.lua](./Resources/Searcher.lua)
