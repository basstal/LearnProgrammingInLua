function ModuloOperation(n, m)
    if m < 0 then
        if math.ult(n, m) then return n
        else return n - m
        end
    end
    local q = ((n >> 1) // m) << 1
    local r = n - q * m
    if not math.ult(r, m) then r = r - m end
    return r
end

print(string.format("%u", ModuloOperation(-1000, -1)))
print(string.format("%u", ModuloOperation(-1, 3)))
print(string.format("%u", ModuloOperation(7, 3)))