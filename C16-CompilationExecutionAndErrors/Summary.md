# Compilation Execution And Errors #

## Compilation ##

- if there is any syntax error, load will return nil and the final error message will be something like “attempt to call a nil value”. For clearer error messages, it is better to use assert: ``assert(load(s))()``
- load always compiles its chunks in the global environment.
- We can call load also with a reader function as its first argument. A reader function can return the chunk in parts; load calls the reader successively until it returns nil, which signals the chunk's end.
