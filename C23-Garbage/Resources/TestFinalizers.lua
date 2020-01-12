o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})
o = nil
-- error("1")
-- os.exit()
-- collectgarbage() --> hi