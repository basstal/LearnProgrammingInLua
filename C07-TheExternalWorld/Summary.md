# The External World #

## The Simple I/O Model ##

A call like io.input(filename) opens a stream over the given file in read mode and sets it as the current input stream. From this point on, all input will come from this file, until another call to io.input.

The function io.read reads strings from the current input stream. Its arguments control what to read:

|||
|---|---|
|"a"| reads the whole file|
|"l"| reads the next line (dropping the newline)|
|"L"| reads the next line (keeping the newline)|
|"n"| reads a number|
|num| reads num characters as a string|

we can call read with a number n as an argument: in this case, it tries to read n characters from the input stream. If it cannot read any character (end of file), the call returns nil;

```lua
while true do
    local block = io.read(2^13) -- block size is 8K
    if not block then break end
    io.write(block)
end
```

We can call read with multiple options; for each argument, the function will return the respective result.

```lua
while true do
    local n1, n2, n3 = io.read("n", "n", "n")
    if not n1 then break end
    print(math.max(n1, n2, n3))
end
```

## The Complete I/O Model ##

To open a file, we use the function io.open, which mimics the C function fopen. It takes as arguments the name of the file to open plus a mode string. This mode string can contain an r for reading, a w for writing (which also erases any previous content of the file), or an a for appending, plus an optional b to open binary files. The function open returns a new stream over the file. In case of error, open returns nil, plus an error message and a system-dependent error number.

A typical idiom to check for errors is to use the function assert:

```lua
local f = assert(io.open(filename, mode))
```

The I/O library offers handles for the three predefined C streams, called io.stdin, io.stdout, and io.stderr.

## Other Operations on Files ##

The seek method can both get and set the current position of a stream in a file. Its general form is f:seek(whence, offset), where the whence parameter is a string that specifies how to interpret the offset.

The default value for whence is "cur" and for offset is zero. Therefore, the call file:seek() returns the current stream position, without changing it; the call file:seek("set") resets the position to the beginning of the file (and returns zero); and the call file:seek("end") sets the position to the end of the file and returns its size.

```lua
function fsize (file)
    local current = file:seek() -- save current position
    local size = file:seek("end") -- get file size
    file:seek("set", current) -- restore position
    return size
end
```

## Running system commands ##

The function os.execute runs a system command; it is equivalent to the C function system. It takes a string with the command and returns information regarding how the command terminated. The first result is a Boolean: true means the program exited with no errors. The second result is a string: "exit" if the program terminated normally or "signal" if it was interrupted by a signal. A third result is the return status (if the program terminated normally) or the number of the signal that terminated the program.
