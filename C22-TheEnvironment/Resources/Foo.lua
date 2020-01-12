local _G = _G
local print = print
local foo
print(foo)
print(_ENV.foo)
do
local _ENV = _ENV
print(_ENV == _G)
print(foo)
foo = function()
    -- ** 这里的X从_ENV中取 实际已经捕获了_ENV所以不论如何都能取到X 这说明了函数的执行环境是在代码加载时就确定了
    print(X)
end
-- ** 这里实际上是给local 的foo赋值
-- function foo () print(X) end
print(foo)
end
X = 13
_ENV = nil
-- ** 这里的foo是上面定义的local的foo 因此不是全局的
print(foo)
foo()
-- ** 这里会报错 因为没有_ENV所以取不到全局的X
-- X = 0