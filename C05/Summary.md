# Tables #

## Table Traversal ##

Due to the way that Lua implements tables, the order that elements appear in a traversal is undefined. The same program can produce different orders each time it runs. The only certainty is that each element will appear once during the traversal.

## Safe Navigation ##

```lua
E = {}     -- can be reused in other similar expressions
-- some codes
zip = (((company or E).director or E).address or E).zipcode
```

## The Table Library ##

The call table.move(a, f, e, t) moves the elements in table a from index f until e (both inclusive) to position t. For instance, to insert an element in the beginning of a list a, we can do the following:

```lua
table.move(a, 1, #a, 2)
a[1] = newElement
```

The next code removes the first element:

```lua
table.move(a, 2, #a, 1)
a[#a] = nil
```

We can call table.move with an extra optional parameter, a table. In that case, the function moves the elements from the first table into the second one. For instance, the call table.move(a, 1, #a, 1, {}) returns a clone of list a (by copying all its elements into a new list), while table.move(a, 1, #a, #b + 1, b) appends all elements from list a to the end of list b.
