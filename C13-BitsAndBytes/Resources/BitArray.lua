function NewBitArray(n)
    local b = {}
    if n > 0 then
        for i = 1, n do
            b[i] = false
        end
    end
    return b
end

function SetBit(a, n, v)
    if n > #a or n < 1 then return end
    a[n] = v
end

function TestBit(a, n)
    if n > #a or n < 1 then return end
    return a[n]
end


function Test()
    local bitArray = NewBitArray(12)
    SetBit(bitArray, 11, false)
    SetBit(bitArray, 7, true)
    SetBit(bitArray, 15, false)
    SetBit(bitArray, -1, true)
    SetBit(bitArray, 0, true)
    assert(TestBit(bitArray, 0) == nil)
    assert(TestBit(bitArray, 1) == false)
    assert(TestBit(bitArray, 7) == true)
    assert(TestBit(bitArray, 15) == nil)
    assert(TestBit(bitArray, -1) == nil)
end

Test()