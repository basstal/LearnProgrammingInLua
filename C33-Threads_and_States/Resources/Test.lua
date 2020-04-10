_ENV = _G

function foo (x) coroutine.yield(10, x) end
function foo1 (x) foo(x + 1); return 3 end