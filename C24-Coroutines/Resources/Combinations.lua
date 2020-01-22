function Combinations(tb, c)
    local n, m = #tb, c
    return coroutine.wrap(function() Combination(tb, n, m, {}) end)
end

function Combination(tb, n, m, result)
    if m == 0 then
        coroutine.yield(result)
    elseif n >= m then
        for i = 1, #tb do
            local newArray = {}
            table.move(tb, 1, #tb, #newArray + 1, newArray)
            table.remove(newArray, i)
            table.insert(result, tb[i])
            Combination(newArray, n - 1, m - 1, result)
            table.remove(result, #result)
            Combination(newArray, n - 1, m, result)
        end
    end
end

function Test()
    local distinct = {}
    for c in Combinations({'a', 'b', 'c', 'd'}, 3) do
        distinct[table.concat( c, ", ")] = true
    end
    local sorted = {}
    for f in pairs(distinct) do
        table.insert(sorted, f)
    end
    table.sort(sorted, function(a, b) return a < b end)
    for _, f in pairs(sorted) do
        print(f)
    end
end

Test()