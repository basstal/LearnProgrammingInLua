function HammingWeight(a)
    local count = 0
    while a ~= 0 do
        if a & 1 == 1 then
            count = count + 1
        end
        a = a >> 1
    end
    return count
end

function Test()
    assert(HammingWeight(0xABCDEF) == 17)
    assert(HammingWeight(0x11111) == 5)
    assert(HammingWeight(16) == 1)
    assert(HammingWeight(127) == 7)
end

Test()