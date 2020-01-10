local Account = {}
local proxies = {}

function Account:New(o)
    o = o or {}

    proxies[o] = {balance = 0}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Account:Balance()
    return proxies[self].balance
end

function Account:Deposit(v)
    local d = proxies[self]
    d.balance = d.balance + v
end

function Account:Withdraw(v)
    local d = proxies[self]
    d.balance = d.balance - v
end

function Test()
    local a = Account:New()
    a:Deposit(5)
    a:Withdraw(2)
    print(a:Balance())
end

Test()