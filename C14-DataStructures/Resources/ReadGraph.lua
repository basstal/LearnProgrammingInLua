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


local TestData = [[
    a b l1
    c a l2
    d c l3
    f c l4
    c e l5
    e d l6
    q
]]
function ReadGraph()

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

Test()