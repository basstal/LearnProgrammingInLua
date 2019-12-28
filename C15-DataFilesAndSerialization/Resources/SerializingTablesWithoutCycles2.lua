local reservedIdentifiers = {
    ["and"] = true,
    ["break"] = true,
    ["do"] = true,
    ["else"] = true,
    ["elseif"] = true,
    ["end"] = true,
    ["false"] = true,
    ["for"] = true,
    ["function"] = true,
    ["goto"] = true,
    ["if"] = true,
    ["in"] = true,
    ["local"] = true,
    ["nil"] = true,
    ["not"] = true,
    ["or"] = true,
    ["repeat"] = true,
    ["return"] = true,
    ["then"] = true,
    ["true"] = true,
    ["until"] = true,
    ["while"] = true,
}

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
            if type(k) ~= "number" then
                if reservedIdentifiers[k] or tonumber(k) ~= nil then
                    io.write(string.format("[%s] = ", serialize(k)))
                else
                    io.write(k, " = ")
                end
            end
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
            ["nil"] = 555,
            "ccc1",
            "ccc2",
            "ccc3",
        },
    }
    local b = {
        a=12, b='Lua', key='another "one"'
    }
    io.output("111.tmp")
    serialize(a, '\t')
    io.write('\n')
    serialize(b, '\t')
end

Test()