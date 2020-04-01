# Techniques for Writing C Functions #

## Array Manipulation ##

lua_settable and lua_gettable

the API provides special functions to access and update tables with integer keys

```cpp
void lua_geti (lua_State *L, int index, int key);
void lua_seti (lua_State *L, int index, int key);
```

it involves two indices: index refers to where the table is on the stack; key refers to where the element is in the table. The call lua_geti(L, t, key) is equivalent to the following sequence when t is positive

```cpp
int l_map (lua_State *L) {
    int i, n;
    /* 1st argument must be a table (t) */
    luaL_checktype(L, 1, LUA_TTABLE);
    /* 2nd argument must be a function (f) */
    luaL_checktype(L, 2, LUA_TFUNCTION);
    n = luaL_len(L, 1); /* get size of table */
    for (i = 1; i <= n; i++) {
        lua_pushvalue(L, 2); /* push f */
        lua_geti(L, 1, i); /* push t[i] */
        lua_call(L, 1, 1); /* call f(t[i]) */
        lua_seti(L, 1, i); /* t[i] = result */
    }
    return 0; /* no results */
}
```

The function luaL_checktype (from lauxlib.h) ensures that a given argument has a given type; otherwise, it raises an error.

The function luaL_len (the one used in the example, from the auxiliary library) returns the length as an integer, raising an error if the coercion is not possible.

The function lua_call does an unprotected call.

## String Manipulation ##

there are only two rules that it must observe: not to pop the string from the stack while using it and never to modify the string.

remember that the basic operation lua_pushlstring gets the string length as an extra argument. Therefore, if we want to pass to Lua a substring of a string s ranging from position i to j (inclusive)

``lua_pushlstring(L, s + i, j - i + 1);``

```cpp
static int l_split (lua_State *L) {
    const char *s = luaL_checkstring(L, 1); /* subject */
    const char *sep = luaL_checkstring(L, 2); /* separator */
    const char *e;
    int i = 1;
    lua_newtable(L); /* result table */
    /* repeat for each separator */
    while ((e = strchr(s, *sep)) != NULL) {
        lua_pushlstring(L, s, e - s); /* push substring */
        lua_rawseti(L, -2, i++); /* insert it in table */
        s = e + 1; /* skip separator */
    }
    /* insert last substring */
    lua_pushstring(L, s);
    lua_rawseti(L, -2, i);
    return 1; /* return the table */
}
```

To concatenate strings, Lua provides a specific function, called lua_concat. It is equivalent to the concatenation operator (..) in Lua: it converts numbers to strings and triggers metamethods when necessary. Moreover, it can concatenate more than two strings at once. The call lua_concat(L, n) will concatenate (and pop) the top-most n values on the stack and push the result.

``const char *lua_pushfstring (lua_State *L, const char *fmt, ...);``

|%s| inserts a zero-terminated string|
|%d| inserts an int|
|%f| inserts a Lua float|
|%p| inserts a pointer|
|%I| inserts a Lua integer|
|%c| inserts an int as a one-byte character|
|%U| inserts an int as a UTF-8 byte sequence|
|%%| inserts a percent sign|

```cpp

static int str_upper (lua_State *L) {
    size_t l;
    size_t i;
    luaL_Buffer b;
    const char *s = luaL_checklstring(L, 1, &l);
    char *p = luaL_buffinitsize(L, &b, l);
    for (i = 0; i < l; i++)
        p[i] = toupper(uchar(s[i]));
    luaL_pushresultsize(&b, l);
    return 1;
}
```

The auxiliary library offers several functions to add things to a buffer: luaL_addvalue adds a Lua string that is on the top of the stack; luaL_addlstring adds strings with an explicit length; luaL_addstring adds zero-terminated strings; and luaL_addchar adds single characters.

```cpp
void luaL_buffinit (lua_State *L, luaL_Buffer *B);
void luaL_addvalue (luaL_Buffer *B);
void luaL_addlstring (luaL_Buffer *B, const char *s, size_t l);
void luaL_addstring (luaL_Buffer *B, const char *s);
void luaL_addchar (luaL_Buffer *B, char c);
void luaL_pushresult (luaL_Buffer *B);
```

although we can use the stack for other tasks while using a buffer, the push/pop count for these uses must be balanced every time we access the buffer. The only exception to this rule is luaL_addvalue, which assumes that the string to be added to the buffer is on the top of the stack.

## Storing State in C Functions ##

The C API offers two similar places to store non-local data: the registry and upvalues.

### The registry ###

The registry is always located at the pseudo-index LUA_REGISTRYINDEX

to get a value stored with key "Key" in the registry, we can use the following call

``lua_getfield(L, LUA_REGISTRYINDEX, "Key");``

We should never use our own numbers as keys in the registry, because Lua reserves numeric keys for its reference system.

``int ref = luaL_ref(L, LUA_REGISTRYINDEX);``

Lua does not even offer pointers to other objects, such as tables or functions. So, we cannot refer to Lua objects through pointers. Instead, when we need such pointers, we create a reference and store it in C.

``lua_rawgeti(L, LUA_REGISTRYINDEX, ref);``

``luaL_unref(L, LUA_REGISTRYINDEX, ref);``

When we create a Lua state, the registry comes with two predefined references

LUA_RIDX_MAINTHREAD keeps the Lua state itself, which is also its main thread.

LUA_RIDX_GLOBALS keeps the global environment.

```cpp
/* variable with a unique address */
static char Key = 'k';
/* store a string */
lua_pushlightuserdata(L, (void *)&Key); /* push address */
lua_pushstring(L, myStr); /* push value */
lua_settable(L, LUA_REGISTRYINDEX); /* registry[&Key] = myStr */
/* retrieve a string */
lua_pushlightuserdata(L, (void *)&Key); /* push address */
lua_gettable(L, LUA_REGISTRYINDEX); /* retrieve value */
myStr = lua_tostring(L, -1); /* convert to string */
```

```cpp
static char Key = 'k';
/* store a string */
lua_pushstring(L, myStr);
lua_rawsetp(L, LUA_REGISTRYINDEX, (void *)&Key);
/* retrieve a string */
lua_rawgetp(L, LUA_REGISTRYINDEX, (void *)&Key);
myStr = lua_tostring(L, -1);
```

### Upvalues ###

