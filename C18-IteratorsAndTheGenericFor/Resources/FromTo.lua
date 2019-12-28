
function FromTo(n, m)
    return function(_, n)
        if n < m then
            return n + 1
        else
            return nil
        end
    end, nil, n - 1
end


function Test()
    local n, m = 1, 10
    for i in FromTo(1, 10) do
        print(i)
    end
end

Test()