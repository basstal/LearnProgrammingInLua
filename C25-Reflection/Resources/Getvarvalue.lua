function Getvarvalue(...)
    local p = {...}
    local name, level, isenv, thread = table.unpack(p)
    if type(name) == "thread" then
        thread, name, level, isenv = table.unpack(p)
    else
        name, level, isenv = table.unpack({...})
        thread = nil
    end

    local value
    local found = false
    level = (level or 1) + 1
    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if thread ~= nil and type(v) == "thread" then
            n, v = debug.getlocal(v, 2, 1)
        end
        if n == name then
            value = v
            found = true
        end
    end
    if found then return "local", value end
    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then return "upvalue", v end
    end
    if isenv then return "noenv" end -- avoid loop
    -- not found; get value from the environment
    local _, env = getvarvalue("_ENV", level, true)
    if env then
        return "global", env[name]
    else -- no _ENV available
        return "noenv"
    end
end

function Test()
    local co = coroutine.create(function()
        local x = 10
        print(Getvarvalue('x'))
    end)
    print(Getvarvalue(co, 'x'))
    coroutine.resume(co)
end

Test()