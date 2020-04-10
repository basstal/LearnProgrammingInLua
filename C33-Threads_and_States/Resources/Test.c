#include "lauxlib.h"
#include "lstate.h"
#include "lapi.h"
#include <stdio.h>
#include <stdlib.h>

static const char* progname="Test.c";	/* actual program name */

static void fatal(const char* message)
{
 fprintf(stderr,"%s: %s\n",progname,message);
 exit(EXIT_FAILURE);
}

int main()
{
    lua_State *L = luaL_newstate();
    const char *fileName = "./C33-Threads_and_States/Resources/Test.lua";
    
    if (luaL_loadfile(L, fileName) || lua_pcall(L, 0, 0, 0))
    {
        fatal(lua_tostring(L,-1));
        return -1;
    }
    // ** need require?
    // luaL_requiref(L, fileName)
    // printf("newstate\n");
    // lua_State *L1 = lua_newthread(L);
    // printf("%d\n", lua_gettop(L1));
    // printf("%s\n", luaL_typename(L, -1));
    
    lua_State *L1 = lua_newthread(L);

    lua_getglobal(L1, "foo1");
    lua_pushinteger(L1, 20);
    lua_resume(L1, L, 1);
    printf("%d\n", lua_gettop(L1)); 
    printf("%lld\n", lua_tointeger(L1, 1)); 
    printf("%lld\n", lua_tointeger(L1, 2)); 

    lua_resume(L1, L, 0);
    printf("%d\n", lua_gettop(L1)); 
    printf("%lld\n", lua_tointeger(L1, 1)); 
    
    lua_close(L);
    return 0;
}