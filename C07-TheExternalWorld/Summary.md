# The External World #

## The Simple I/O Model ##

- A call like io.input(filename) opens a stream over the given file in read mode and sets it as the current input stream. From this point on, all input will come from this file, until another call to io.input.

## The Complete I/O Model ##

- The function open returns a new stream over the file. In case of error, open returns nil, plus an error message and a system-dependent error number.

- A typical idiom to check for errors is to use the function assert:

    ```lua
    local f = assert(io.open(filename, mode))
    ```

- The I/O library offers handles for the three predefined C streams, called io.stdin, io.stdout, and io.stderr.

## Other Operations on Files ##

- The seek method can both get and set the current position of a stream in a file. Its general form is f:seek(whence, offset), where the whence parameter is a string that specifies how to interpret the offset.

- The default value for whence is "cur" and for offset is zero. Therefore, the call file:seek() returns the current stream position, without changing it; the call file:seek("set") resets the position to the beginning of the file (and returns zero); and the call file:seek("end") sets the position to the end of the file and returns its size.

## Running system commands ##

The function os.execute runs a system command; it is equivalent to the C function system. It takes a string with the command and returns information regarding how the command terminated. The first result is a Boolean: true means the program exited with no errors. The second result is a string: "exit" if the program terminated normally or "signal" if it was interrupted by a signal. A third result is the return status (if the program terminated normally) or the number of the signal that terminated the program.
