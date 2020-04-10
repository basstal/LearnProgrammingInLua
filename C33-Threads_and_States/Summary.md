# Threads and States #

## Multiple Threads ##

Whenever we create a Lua state, Lua automatically creates a main thread within this state and returns a lua_State representing this thread. This main thread is never collected. It is released together with the state, when we close the state with lua_close. Programs that do not bother with threads run everything in this main thread.

We can create other threads in a state calling lua_newthread: ``lua_State *lua_newthread (lua_State *L);``

```cpp
L1 = lua_newthread(L);
printf("%d\n", lua_gettop(L1)); --> 0
printf("%s\n", luaL_typename(L, -1)); --> thread
```

```cpp
lua_State *L1 = lua_newthread (L);
lua_pop(L, 1); /* L1 now is garbage for Lua */
lua_pushstring(L1, "hello");
```

```cpp
lua_getglobal(L1, "f"); /* assume a global function 'f' */
lua_pushinteger(L1, 5);
lua_call(L1, 1, 1);
lua_xmove(L1, L, 1);
```

The function lua_xmove moves Lua values between two stacks in the same state. A call like lua_xmove(F, T, n) pops n elements from the stack F and pushes them on T.

```cpp
int lua_resume (lua_State *L, lua_State *from, int narg);
```

The behavior is also much like lua_pcall, with three differences. First, lua_resume does not have a parameter for the number of wanted results; it always returns all results from the called function. Second, it does not have a parameter for a message handler; an error does not unwind the stack, so we can inspect the stack after the error. Third, if the running function yields, lua_resume returns the code LUA_YIELD and leaves the thread in a state that can be resumed later.

```lua
function foo (x) coroutine.yield(10, x) end
function foo1 (x) foo(x + 1); return 3 end
```

```cpp
lua_State *L1 = lua_newthread(L);
lua_getglobal(L1, "foo1");
lua_pushinteger(L1, 20);
lua_resume(L1, L, 1);
printf("%d\n", lua_gettop(L1)); --> 2
printf("%lld\n", lua_tointeger(L1, 1)); --> 10
printf("%lld\n", lua_tointeger(L1, 2)); --> 21

lua_resume(L1, L, 0);
printf("%d\n", lua_gettop(L1)); --> 1
printf("%lld\n", lua_tointeger(L1, 1)); --> 3
```

This second call to lua_resume will return LUA_OK, which means a normal return.

```cpp
int lua_yieldk (lua_State *L, int nresults, int ctx, lua_CFunction k);
```

This call immediately suspends the running coroutine. The nresults parameter is the number of values on the stack to be returned to the respective lua_resume; ctx is the context information to be passed to the continuation; and k is the continuation function. When the coroutine resumes, the control goes directly to the continuation function k. After yielding, myCfunction cannot do anything else; it must delegate any further work to its continuation.

```cpp
int readK (lua_State *L, int status, lua_KContext ctx) {
    (void)status; (void)ctx; /* unused parameters */
    if (something_to_read()) {
        lua_pushstring(L, read_some_data());
        return 1;
    }
    else
    {
        return lua_yieldk(L, 0, 0, &readK);
    }
}

int prim_read (lua_State *L) {
    return readK(L, 0, 0);
}
```

If a C function has nothing else to do after yielding, it can call lua_yieldk without a continuation function or use the macro lua_yield: ``return lua_yield(L, nres);``

## Lua States ##

