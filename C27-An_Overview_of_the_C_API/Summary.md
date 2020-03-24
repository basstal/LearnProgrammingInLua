# An Overview of the C API #

## A First Example ##

```cpp
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main (void) {
    char buff[256];
    int error;
    lua_State *L = luaL_newstate(); /* opens Lua */
    luaL_openlibs(L); /* opens the standard libraries */
    while (fgets(buff, sizeof(buff), stdin) != NULL) {
        error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
        if (error) {
            fprintf(stderr, "%s\n", lua_tostring(L, -1));
            lua_pop(L, 1); /* pop error message from the stack */
        }
    }
    lua_close(L);
    return 0;
}
```

The header file lualib.h declares functions to open the libraries. The function luaL_openlibs opens all standard libraries.

For each line the user enters, the program first compiles it with luaL_loadstring. If there are no errors, the call returns zero and pushes the resulting function on the stack.  Then the program calls lua_pcall, which pops the function from the stack and runs it in protected mode. Like luaL_loadstring, lua_pcall returns zero if there are no errors. In case of error, both functions push an error message on the stack; we then get this message with lua_tostring and, after printing it, remove it from the stack with lua_pop.

```cpp
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
void error (lua_State *L, const char *fmt, ...) {
    va_list argp;
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
    lua_close(L);
    exit(EXIT_FAILURE);
}
```

## The Stack ##

Lua manipulates this stack in a strict LIFO discipline (Last In, First Out). When we call Lua, it changes only the top part of the stack. Our C code has more freedom; specifically, it can inspect any element in the stack and even insert and delete elements at any position.

## Pushing elements ##

For any string that it has to keep, Lua either makes an internal copy or reuses one. Therefore, we can free or modify our buffers as soon as these functions return.

```cpp
// lower-level
int lua_checkstack (lua_State *L, int sz);
// higher-level
void luaL_checkstack (lua_State *L, int sz, const char *msg);
```

sz is the number of extra slots we need. If possible, lua_checkstack grows the stack to accommodate the required extra size. Otherwise, it returns zero.

## Querying elements ##

The first element pushed on the stack has index 1, the next one has index 2, and so on. We can also access elements using the top of the stack as our reference, with negative indices. In this case, -1 refers to the element on top (that is, the last element pushed), -2 to the previous element, and so on. For instance, the call lua_tostring(L, -1) returns the value on the top of the stack as a string.

lua_isnumber does not check whether the value has that specific type, but whether the value can be converted to that type; lua_isstring is similar: in particular, any number satisfies lua_isstring.

When a C function called by Lua returns, Lua clears its stack; therefore, as a rule, we should never store pointers to Lua strings outside the function that got them.

```cpp
size_t len;
const char *s = lua_tolstring(L, -1, &len); /* any Lua string */
assert(s[len] == '\0');
assert(strlen(s) <= len);
```

```cpp
static void stackDump (lua_State *L) {
    int i;
    int top = lua_gettop(L); /* depth of the stack */
    for (i = 1; i <= top; i++) { /* repeat for each level */
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING: { /* strings */
                printf("'%s'", lua_tostring(L, i));
                break;
            }
            case LUA_TBOOLEAN: { /* Booleans */
                printf(lua_toboolean(L, i) ? "true" : "false");
                break;
            }
            case LUA_TNUMBER: { /* numbers */
                if (lua_isinteger(L, i)) /* integer? */
                    printf("%lld", lua_tointeger(L, i));
                else /* float */
                    printf("%g", lua_tonumber(L, i));
                break;
            }
            default: { /* other values */
                printf("%s", lua_typename(L, t));
                break;
            }
        }
        printf(" "); /* put a separator */
    }
    printf("\n"); /* end the listing */
}
```

## Other stack operations ##

The function lua_settop sets the top to a specific value. If the previous top was higher than the new one, the function discards the extra top values. Otherwise, it pushes nils on the stack to get the given size. In particular, lua_settop(L, 0) empties the stack.

```cpp
#define lua_pop(L,n) lua_settop(L, -(n) - 1)
```

The function lua_pushvalue pushes on the stack a copy of the element at the given index.

The function lua_rotate is new in Lua 5.3. As the name implies, it rotates the stack elements from the given index to the top of the stack by n positions. A positive n rotates the elements in the direction of the top; a negative n rotates in the other direction.

```cpp
#define lua_remove(L,idx) (lua_rotate(L, (idx), -1), lua_pop(L, 1))
```

```cpp
#define lua_insert(L,idx) lua_rotate(L, (idx), 1)
```

The function lua_replace pops a value and sets it as the value of the given index, without moving anything;

```cpp
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
static void stackDump (lua_State *L) {
    // stackDump function writen in previous
}

int main (void) {
    lua_State *L = luaL_newstate();
    lua_pushboolean(L, 1);
    lua_pushnumber(L, 10);
    lua_pushnil(L);
    lua_pushstring(L, "hello");
    stackDump(L);
    /* will print: true 10 nil 'hello' */
    lua_pushvalue(L, -4); stackDump(L);
    /* will print: true 10 nil 'hello' true */
    lua_replace(L, 3); stackDump(L);
    /* will print: true 10 true 'hello' */
    lua_settop(L, 6); stackDump(L);
    /* will print: true 10 true 'hello' nil nil */
    lua_rotate(L, 3, 1); stackDump(L);
    /* will print: true 10 nil true 'hello' nil */
    lua_remove(L, -3); stackDump(L);
    /* will print: true 10 nil 'hello' nil */
    lua_settop(L, -5); stackDump(L);
    /* will print: true */
    lua_close(L);
    return 0;
}
```

## Error Handling with the C API ##

When we write library code (C functions to be called from Lua), the use of long jumps requires no extra work from our part, because Lua catches any error. When we write application code (C code that calls Lua), however, we must provide a way to catch those errors.

## Error handling in application code ##

```cpp
static int foo (lua_State *L) {
    // code to run in protected mode
    return 0;
}
int secure_foo (lua_State *L) {
    lua_pushcfunction(L, foo); /* push 'foo' as a Lua function */
    return (lua_pcall(L, 0, 0, 0) == 0);
}
```

## Error handling in library code ##

## Memory Allocation ##

it is quite easy to get full control over Lua allocation, by creating our state with the primitive lua_newstate

```cpp
lua_State *lua_newstate (lua_Alloc f, void *ud);

typedef void * (*lua_Alloc) (void *ud,
                            void *ptr,
                            size_t osize,
                            size_t nsize);
```

The first parameter is always the user data provided to lua_newstate; the second parameter is the address of the block being (re)allocated or released; the third parameter is the original block size; and the last parameter is the requested block size. If ptr is not NULL, Lua ensures that it was previously allocated with size osize.

```cpp
//We can recover the memory allocator of a Lua state by calling lua_getallocf
lua_Alloc lua_getallocf (lua_State *L, void **ud);
//We can change the memory allocator of a Lua state by calling lua_setallocf
void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);
```