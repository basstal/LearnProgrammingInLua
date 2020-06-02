-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end
print("enter a number:")
a = io.read("*n") -- reads a number
if type(a) == "number" then
    print(fact(a))
else
    print("input is not a number!")
end