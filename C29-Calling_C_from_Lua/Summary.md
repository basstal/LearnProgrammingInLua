# Calling C from Lua #

An important point here is that the stack is not a global structure; each function has its own private local stack. When Lua calls a C function, the first argument will always be at index 1 of this local stack. Even when a C function calls Lua code that calls the same (or another) C function again, each of these invocations sees only its own private stack, with its first argument at index 1.

## C Functions ##

```cpp
static int l_sin (lua_State *L) {
    double d = lua_tonumber(L, 1); /* get argument */
    lua_pushnumber(L, sin(d)); /* push result */
    return 1; /* number of results */
}

static int l_sin (lua_State *L) {
    double d = luaL_checknumber(L, 1);
    lua_pushnumber(L, sin(d));
    return 1; /* number of results */
}
```

```cpp
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
static int l_dir (lua_State *L) {
    DIR *dir;
    struct dirent *entry;
    int i;
    const char *path = luaL_checkstring(L, 1);
    /* open directory */
    dir = opendir(path);
    if (dir == NULL) { /* error opening the directory? */
        lua_pushnil(L); /* return nil... */
        lua_pushstring(L, strerror(errno)); /* and error message */
        return 2; /* number of results */
    }
    /* create result table */
    lua_newtable(L);
    i = 1;
    while ((entry = readdir(dir)) != NULL) { /* for each entry */
        lua_pushinteger(L, i++); /* push key */
        lua_pushstring(L, entry->d_name); /* push value */
        lua_settable(L, -3); /* table[i] = entry name */
    }
    closedir(dir);
    return 1; /* table is already on top */
}
```

## Continuations ##

```cpp
static int finishpcall (lua_State *L, int status, intptr_t ctx) {
    (void)ctx; /* unused parameter */
    status = (status != LUA_OK && status != LUA_YIELD);
    lua_pushboolean(L, (status == 0)); /* status */
    lua_insert(L, 1); /* status is first result */
    return lua_gettop(L); /* return status + all results */
}

static int luaB_pcall (lua_State *L) {
    int status;
    luaL_checkany(L, 1);
    status = lua_pcallk(L, lua_gettop(L) - 1, LUA_MULTRET, 0,
    0, finishpcall);
    return finishpcall(L, status, 0);
}
```

## C Modules ##

Lua perceives C functions through this registration process. Once a C function is represented and stored in Lua, Lua calls it through a direct reference to its address

The macro luaL_newlib takes an array of C functions with their respective names and registers all of them inside a new table.

```cpp
static int l_dir (lua_State *L) {
    as before
}

static const struct luaL_Reg mylib [] = {
    {"dir", l_dir},
    {NULL, NULL} /* sentinel */
};

```
