# The External World #

## Exercise 7.1 ##

Write a program that reads a text file and rewrites it with its lines sorted in alphabetical order. When called with no arguments, it should read from standard input and write to standard output. When called with one file-name argument, it should read from that file and write to standard output. When called with two file-name arguments, it should read from the first file and write to the second.

```lua
function sortAndRewrite(src, tar)
    local input = io.stdin
    local output = io.stdout
    if src ~= nil then
        input = io.open(src, 'r')
    end
    if tar ~= nil then
        output = io.open(tar, 'w')
    end
    if input == io.stdin then
        output:write(input:read())
    else
        local sortedLines = {}
        for line in input:lines() do
            table.insert(sortedLines, line)
        end
        table.sort(sortedLines, function(l1, l2) return l1 < l2 end)
        for i = 1, #sortedLines do
            output:write(sortedLines[i], '\n')
        end
    end
end
```

## Exercise 7.2 ##

Change the previous program so that it asks for confirmation if the user gives the name of an existing file for its output.

```lua
function sortAndRewrite(src, tar)
    local input = io.stdin
    local output = io.stdout

    if src ~= nil then
        input = assert(io.open(src, 'r'))
    end
    if tar ~= nil then
        if io.open(tar, 'r') == nil then
            output = io.open(tar, 'w')
        else
            io.stdout:write(string.format("%s is exist. Do you wish to override file %s(yes/no)", tar, tar))
            local command = io.stdin:read()
            if command == "yes" then
                output = assert(io.open(tar, 'w'))
            else
                io.stdout:write("canceled !")
                return
            end
        end
    end
    if input == io.stdin then
        output:write(input:read())
    else
        local sortedLines = {}
        for line in input:lines() do
            table.insert(sortedLines, line)
        end
        table.sort(sortedLines, function(l1, l2) return l1 < l2 end)
        for i = 1, #sortedLines do
            output:write(sortedLines[i], '\n')
        end
    end
    io.stdout:write("success !")
end
```

## Exercise 7.3 ##

Compare the performance of Lua programs that copy the standard input stream to the standard output stream in the following ways:

- byte by byte;
- line by line;
- in chunks of 8 kB;
- the whole file at once.

For the last option, how large can the input file be?

``depends on the I/O cache size``

## Exercise 7.4 ##

Write a program that prints the last line of a text file. Try to avoid reading the entire file when the file is large and seekable.

## Exercise 7.5 ##

Generalize the previous program so that it prints the last n lines of a text file. Again, try to avoid reading the entire file when the file is large and seekable.

## Exercise 7.6 ##

Using os.execute and io.popen, write functions to create a directory, to remove a directory, and to collect the entries in a directory.

```lua
function directoryHandler()
    os.execute(string.format( "mkdir hahah"))
    os.execute(string.format( "rmdir hahah"))
    local f = io.popen('dir -h E:', 'r')
    local dir = {}
    for entry in f:lines() do
        print(entry, '\n')
        table.insert(dir, entry)
    end
end
```

## Exercise 7.7 ##

Can you use os.execute to change the current directory of your Lua script? Why?

``yes``
