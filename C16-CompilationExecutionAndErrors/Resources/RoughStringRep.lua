function RoughStringRep(s, n)
    local t = {}
    table.insert(t, string.format("local r = %q", ""))
    table.insert(t, string.format("local s = %q", s))
    local rAdds = "r = r .. s"
    local sAdds = "s = s .. s"
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then table.insert(t, rAdds) end
            table.insert(t, sAdds)
            n = math.floor(n / 2)
        end
        table.insert(t, rAdds)
    end
    table.insert(t, "return r")
    return assert(load(table.concat(t, ";")))
end

function stringrep (s, n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then r = r .. s end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
    return r
end

function Test()
    local t1 = os.clock()
    local r1 = RoughStringRep("aabb", 100000000)()
    local t2 = os.clock()
    print("rough : ", t2 - t1)
    t1 = os.clock()
    local r2 = stringrep("aabb", 100000000)
    t2 = os.clock()
    print("book : ", t2 - t1)
    -- print(r1)
    -- print(r2)
    assert(r1 == r2)
end

Test()