function Searcher(modname)
    local path =  "./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua"
    local p = package.searchpath(modname, path)
    if p ~= nil then
        local loaded = loadfile(p)
        if loaded == nil then
            loaded = package.loadlib(p)
        end
        return loaded
    end
end


function Test()
    assert(Searcher("ADoubleEndedQueue") ~= nil)
    assert(Searcher("haha123") == nil)
end

Test()