function Producer()
    while true do
        local x = io.read()
        Send(x)
    end
end


function Consumer(x)
    while true do
        -- local x = Receive()
        io.write(x, "\n")
        x = Receive()
        -- coroutine.yield()
    end

end


function Receive()
    return coroutine.yield(  )
end

function Send(x)
    coroutine.resume( Consumer, x)
end

Consumer = coroutine.create( Consumer )

function Test()
    Producer()
end

Test()