local r = require("ReadGraph")


function Dijkstra(g, s)
    local d, previous, Q = {}, {}, {}
    
    for point, arcs in pairs(g) do
        d[point] = math.huge
        Q[point] = true
        Q.count = (Q.count or 0) + 1
    end
    print(Q.count)
    d[s] = 0
    while Q.count > 0 do
        -- ** Extract_Min(Q)
        local val, u
        for point, v in pairs(d) do
            if Q[point] ~= nil and (val == nil or val > v) then
                val = v
                u = point
            end
        end
        Q[u] = nil
        Q.count = Q.count - 1

        for _, arc in pairs(g[u]) do
            local v = arc.pointsTo
            print(v)
            if d[v] > d[u] + tonumber(arc.name) then
                d[v] = d[u] + tonumber(arc.name)
                print(v, u, d[v])
                previous[v] = u
            end
        end

    end
    return previous
end

function GetPath(previous, t)
    local S = {}
    local u = t
    while u ~= nil do
        table.insert(S, 1, u)
        u = previous[u]
    end
    return S
end

function Test()
    local graphData = r.ReadGraph()
    local previous = Dijkstra(graphData, "f")
    local path = GetPath(previous, "b")
    assert(table.concat(path, ",") == "f,c,a,b")
end

Test()