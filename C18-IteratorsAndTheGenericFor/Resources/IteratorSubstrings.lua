function IteratorSubstrings(s)
    local len = 0
    local start = 1
    local sl = string.len(s)

    return function()
        if len < sl - 1 then
            if start <= sl and start + len <= sl then
                local r = string.sub(s, start, start + len)
                start = start + 1
                return r
            else
                len = len + 1
                if len < sl - 1 then
                    start = 2
                    local r = string.sub(s, 1, 1 + len)
                    return r
                else
                    return nil
                end
            end
        else
            return nil
        end
    end

end


function Test()
    for subStr in IteratorSubstrings("string") do
        print(subStr)
    end
end


Test()