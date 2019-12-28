-- function readgraph ()
--     local graph = {}
--     for line in io.lines() do
--         -- split line in two names
--         local namefrom, nameto = string.match(line, "(%S+)%s+(%S+)")
--         -- find corresponding nodes
--         local from = name2node(graph, namefrom)
--         local to = name2node(graph, nameto)
--         -- adds 'to' to the adjacent set of 'from'
--         from.adj[to] = true
--     end
--     return graph
-- end


-- local TestData = [[
    -- a b 1
    -- c a 2
    -- d c 3
    -- f c 4
    -- c e 5
    -- e d 6
    -- q
-- ]]
local R = {}
function R.ReadGraph()

    local graph = {}

    for line in io.lines() do
        if string.find(line, "q") then
            break
        end
        local namefrom, nameto, label = string.match(line, "(%S+)%s+(%S+)%s+(%S+)")
        local arc = {name = label, pointsTo = nameto}
        local g = graph[namefrom] or {}
        table.insert(g, arc)
        graph[namefrom] = g
        graph[nameto] = graph[nameto] or {}
    end
    return graph
end


function Test()
    local g = ReadGraph()
    assert(#g["d"] == 1)
    assert(#g["c"] == 2)
    assert(g["b"] == nil)
    assert(#g["a"] == 1)
    local arc = g["a"][1]
    assert(arc.name == "l1")
    assert(arc.pointsTo == "b")
end

-- Test()

return R