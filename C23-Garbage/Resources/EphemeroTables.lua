local t = {}

-- setmetatable(t, {})
setmetatable(t, {__mode = "k"})

do
    local f = {}
    t[f] = f
end

for k, v in pairs(t) do
    print(k)
end

collectgarbage()

print("after collect")
for k, v in pairs(t) do
    print(k)
end