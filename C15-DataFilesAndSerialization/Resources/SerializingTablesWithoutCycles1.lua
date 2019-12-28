function serialize (o, indent, r)
    r = r or 1
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or
        t == "nil" then
        return string.format("%q", o)
    elseif t == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            io.write(string.rep(indent, r))
            io.write(string.format("[%s] = ", serialize(k)))
            local v = serialize(v, indent, r + 1)
            if v ~= nil then
                io.write(v, ",\n")
            end
        end
        io.write(string.rep(indent, r - 1), "}")
        if r > 1 then
            io.write(",\n")
        end
    else
        error("cannot serialize a " .. type(o))
    end
end



function Test()
    local a = {
        t = {
            ["1"] = "ccc",
            wa = "ccc",
            u = {
                f = "ggg",
                uf = 6,
                ef = {
                    cg = "aaa",
                },
            },
        },
    }
    local b = {
        a=12, b='Lua', key='another "one"'
    }
    io.output("11.tmp")
    serialize(a, '\t')
    io.write('\n')
    serialize(b, '\t')
end

Test()