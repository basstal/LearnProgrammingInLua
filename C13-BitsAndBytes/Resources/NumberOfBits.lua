function NumberOfBits(a)
    if a < 0 then
        return 64
    else
        local bits = 0
        while a > 0 do
            bits = bits + 1
            a = a >> 1
        end
        return bits
    end
end

function Test()
    assert(NumberOfBits(0xff) == 8)
    assert(NumberOfBits(0x0) == 0)
    assert(NumberOfBits(0xffffffffffffffff) == 64)
    assert(NumberOfBits(-1) == 64)
    assert(NumberOfBits(2) == 2)
    assert(NumberOfBits(0xff) == 8)
end

Test()