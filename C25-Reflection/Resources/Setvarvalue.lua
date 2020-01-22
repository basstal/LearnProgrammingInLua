function Setvarvalue(name, setvalue)
    for i = 1, math.huge do
        local n, v = debug.getlocal(2, i)
        if not n then break end
        if n == name then
            debug.setlocal(2, i, setvalue)
            return
        end
    end
    local func = debug.getinfo(2, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then
            debug.setupvalue(func, i, setvalue)
            return
        end
    end
    _ENV[name] = setvalue
end

local f = 10

function Test()
    local a = 10
    print(a)
    Setvarvalue('a', 20)
    print(a)
    print(f)
    Setvarvalue('f', 30)
    print(f, cc)
    Setvarvalue('cc', 'yyy')
    print(cc)
end

Test()