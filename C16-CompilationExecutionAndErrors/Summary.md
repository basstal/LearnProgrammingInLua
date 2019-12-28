# CompilationExecutionAndErrors #

## Compilation ##

- We can call load also with a reader function as its first argument. A reader function can return the chunk in parts; load calls the reader successively until it returns nil, which signals the chunk's end.
