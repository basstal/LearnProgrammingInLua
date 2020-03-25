# Extending Your Application #

## The Basics ##

```cpp
int getglobint (lua_State *L, const char *var) {
    int isnum, result;
    lua_getglobal(L, var);
    result = (int)lua_tointegerx(L, -1, &isnum);
    if (!isnum)
        error(L, "'%s' should be a number\n", var);
    lua_pop(L, 1); /* remove result from the stack */
    return result;
}
void load (lua_State *L, const char *fname, int *w, int *h) {
    if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
        error(L, "cannot run config. file: %s", lua_tostring(L, -1));
    *w = getglobint(L, "width");
    *h = getglobint(L, "height");
}
```

lua_getglobal, whose single parameter (besides the omnipresent lua_State) is the variable name, to push the corresponding global value onto the stack.

## Table Manipulation ##

```cpp
lua_getglobal(L, "background");
if (!lua_istable(L, -1))
    error(L, "'background' is not a table");
red = getcolorfield(L, "red");
green = getcolorfield(L, "green");
blue = getcolorfield(L, "blue");
```

```cpp
#define MAX_COLOR 255
/* assume that table is on the top of the stack */
int getcolorfield (lua_State *L, const char *key) {
    int result, isnum;
    lua_pushstring(L, key); /* push key */
    lua_gettable(L, -2); /* get background[key] */
    result = (int)(lua_tonumberx(L, -1, &isnum) * MAX_COLOR);
    if (!isnum)
        error(L, "invalid component '%s' in color", key);
    lua_pop(L, 1); /* remove number */
    return result;
}
```

```cpp
/* assume that table is on top */
void setcolorfield (lua_State *L, const char *index, int value) {
    lua_pushstring(L, index); /* key */
    lua_pushnumber(L, (double)value / MAX_COLOR); /* value */
    lua_settable(L, -3);
}
```

```cpp
void setcolor (lua_State *L, struct ColorTable *ct) {
    lua_newtable(L); /* creates a table */
    setcolorfield(L, "red", ct->red);
    setcolorfield(L, "green", ct->green);
    setcolorfield(L, "blue", ct->blue);
    lua_setglobal(L, ct->name); /* 'name' = table */
}
```

```cpp
lua_getglobal(L, "background");
if (lua_isstring(L, -1)) { /* value is a string? */
    const char *name = lua_tostring(L, -1); /* get string */
    int i; /* search the color table */
    for (i = 0; colortable[i].name != NULL; i++) {
        if (strcmp(colorname, colortable[i].name) == 0)
            break;
    }
    if (colortable[i].name == NULL) /* string not found? */
        error(L, "invalid color name (%s)", colorname);
    else { /* use colortable[i] */
        red = colortable[i].red;
        green = colortable[i].green;
        blue = colortable[i].blue;
    }
} else if (lua_istable(L, -1)) {
    red = getcolorfield(L, "red");
    green = getcolorfield(L, "green");
    blue = getcolorfield(L, "blue");
} else
    error(L, "invalid value for 'background'");
```

## Some short cuts ##

```cpp
lua_pushstring(L, key);
lua_gettable(L, -2); /* get background[key] */
// same as follow
lua_getfield(L, -1, key); /* get background[key] */
```

```cpp
if (lua_getfield(L, -1, key) != LUA_TNUMBER)
    error(L, "invalid component in background color");
```

```cpp
void lua_createtable (lua_State *L, int narr, int nrec);
#define lua_newtable(L) lua_createtable(L, 0, 0)
```

The parameter narr is the expected number of elements in the sequence part of the table (that is, entries with sequential integer indices), and nrec is the expected number of other elements.

## Calling Lua Functions ##

```cpp
/* call a function 'f' defined in Lua */
double f (lua_State *L, double x, double y) {
    int isnum;
    double z;
    /* push functions and arguments */
    lua_getglobal(L, "f"); /* function to be called */
    lua_pushnumber(L, x); /* push 1st argument */
    lua_pushnumber(L, y); /* push 2nd argument */
    /* do the call (2 arguments, 1 result) */
    if (lua_pcall(L, 2, 1, 0) != LUA_OK)
        error(L, "error running function 'f': %s",
    lua_tostring(L, -1));
    /* retrieve result */
    z = lua_tonumberx(L, -1, &isnum);
    if (!isnum)
        error(L, "function 'f' should return a number");
    lua_pop(L, 1); /* pop returned value */
    return z;
}
```