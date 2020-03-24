#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "lstate.h"

typedef struct
{
    size_t size;
    size_t limit;
    lua_Alloc alloc;
}LimitData;

static void* my_alloc(void* ud, void* ptr, size_t osize, size_t nsize) {
    LimitData *ld = (LimitData*)ud;
    int sizeDiff = 0;
    if (ptr == NULL)
    {
        sizeDiff = nsize;
    }
    else
    {
        sizeDiff = nsize - osize;
    }
    //printf("sizeDiff : %d\n", sizeDiff);
    if (ld->size + sizeDiff >= ld->limit)
    {
        return NULL;
    }
    else
    {
        lua_Alloc alloc = ld->alloc;
        void *rt = alloc(NULL, ptr, osize, nsize);
        //printf("osize :%d, nsize :%d\n", osize, nsize);
        ld->size += sizeDiff;
        printf("ld->size : %d\n", ld->size);
        return rt;
    }
}


static void setlimit(lua_State *L, size_t limit)
{
    LimitData* ld = (LimitData*)G(L)->ud;
    if (ld != NULL)
    {
        ld->limit = limit;
    }
}

// original alloc in lauxlib.c for luaL_newstate()
static void* l_alloc(void* ud, void* ptr, size_t osize, size_t nsize) {
    (void)ud; (void)osize;  /* not used */
    if (nsize == 0) {
        free(ptr);
        return NULL;
    }
    else
        return realloc(ptr, nsize);
}

int main()
{
    LimitData ld = LimitData();
    ld.alloc = l_alloc;
    ld.size = 0;
    // minimum limit is about 3200
    ld.limit = 5000;

    lua_State * L = lua_newstate(my_alloc, &ld);
    printf("create done\n");
    //ld.alloc = lua_getallocf(L, NULL);

    //lua_setallocf(L, my_alloc, &ld);
    //setlimit(L, 2000);

    //printf("begin\n");
    lua_pushnumber(L, 3.5);
    printf("lua_pushnumber\n");
    lua_pushstring(L, "hello");
    printf("lua_pushstring\n");

    lua_pushnil(L);
    //stackDump(L);
    //printf("stack dump\n");

    lua_rotate(L, 1, -1); //stackDump(L);
    lua_pushvalue(L, -2); //stackDump(L);
    lua_remove(L, 1); //stackDump(L);
    lua_insert(L, -2); //stackDump(L);
    printf("close\n");

    lua_close(L);
    return 0;
}