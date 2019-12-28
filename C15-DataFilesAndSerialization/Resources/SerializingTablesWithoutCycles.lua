function serialize (o, indent, r)
    r = r or 1
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or
        t == "nil" then
        io.write(string.format("%q,\n", o))
    elseif t == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            io.write(string.rep(indent, r))
            if type(k) ~= "number" then
                if tonumber(k) ~= nil then
                    io.write(string.format("[%q] = ", k))
                else
                    io.write(k, " = ")
                end
            
            end
            serialize(v, indent, r + 1)
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
            "ccc1",
            ["2.2"] = "ccc2",
            ["3.5"] = "ccc",
            "ccc3",
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
    io.output("1.tmp")
    serialize(a, '\t')
    io.write('\n')
    serialize(b, '\t')
end

Test()