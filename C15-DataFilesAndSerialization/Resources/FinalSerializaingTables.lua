function basicSerialize (o)
    -- assume 'o' is a number or a string
    return string.format("%q", o)
end

function save (name, value, saved)
    saved = saved or {} -- initial value
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then -- value already saved?
            io.write(saved[value], "\n") -- use its previous name
        else
            saved[value] = name -- save name for next time
            io.write("{}\n") -- create a new table
            for k,v in pairs(value) do -- save its fields
                k = basicSerialize(k)
                local fname = string.format("%s[%s]", name, k)
                save(fname, v, saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end


function Test()
    local b = {
        a=12, b='Lua', key='another "one"'
    }
    local a = {
        t = {
            ["1"] = "ccc",
            wa = "ccc",
            u = {
                b = b,
                f = "ggg",
                uf = 6,
                ef = {
                    cg = "aaa",
                },
            },
            cycle = a,
        },
    }

    io.output("1111.tmp")
    save("haha", a)
end