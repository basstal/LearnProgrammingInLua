function SparseMatricesAdd(a, b)
    local maxRow = math.max(#a, #b)
    local result = {}
    for r, row in pairs(a) do
        result[r] = result[r] or {}
        for c, val in pairs(row) do
            result[r][c] = val
        end
    end
    for r, row in pairs(b) do
        result[r] = result[r] or {}
        for c, val in pairs(row) do
            result[r][c] = (result[r][c] or 0) + val
        end
    end
    return result
end

function Test()
    local a = {}
    local b = {
        {1, nil, 3},
        {5},
        {2, 4},
    }
    local result = SparseMatricesAdd(a, b)
    local output = {}
    for r, row in pairs(result) do
        for c, val in pairs(row) do
            table.insert(output, string.format("\t%s", val))
        end
        table.insert(output, "\n")
    end
    print(table.concat(output))
end

Test()
