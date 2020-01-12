function Split(s, sep)
    local result = {}
    local start = 1
    local i, j = string.find(s, sep, start, true)
    while i ~= nil do
        table.insert(result, string.sub(s, start, i - 1))
        start = j + 1
        i, j = string.find(s, sep, start, true)
    end
    table.insert(result, string.sub(s, start, #s))
    return result
end

function getfield (f)
    local v = _G -- start with the table of globals
    local r = Split(f, ".")
    for _, w in pairs(r) do
        if string.find(w, "[%c%p]") then
            -- error("illegal field : " .. w)
            return
        end
        v = v[w]
    end
    return v
end


function Test()
    local a = getfield("math.sin")
    a = getfield("math?sin")
    a = getfield("math!!!sin")
end

Test()