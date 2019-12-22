function IsPalindromeBits(a)
    local bits32 = 0xFFFFFFFF
    local lowerBits32 = a & bits32
    local higherBits32 = a >> 32
    local higherReverse = {}
    local i = 32
    while i > 0 do
        higherReverse[i] = higherBits32 & 1
        higherBits32 = higherBits32 >> 1
        i = i - 1
    end
    for i = 1, #higherReverse do
        higherBits32 = higherBits32 + higherReverse[i] * math.tointeger(2 ^ (i - 1))
    end
    return lowerBits32 == higherBits32
end


function Test()
    assert(IsPalindromeBits(1) == false)
    assert(IsPalindromeBits(0xffff) == false)
    assert(IsPalindromeBits(0xffffffffffffffff) == true)
    assert(IsPalindromeBits(0xfffefff00fffefff) == false)
    assert(IsPalindromeBits(0xfffefff00fff7fff) == true)
    assert(IsPalindromeBits(0x8f2efff00fffe2f8) == false)
    assert(IsPalindromeBits(0x8f2efff00fff74f1) == true)
    assert(IsPalindromeBits(0x8f2efff006ffe2f8) == false)
end

Test()