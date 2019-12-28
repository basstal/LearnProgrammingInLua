# FillingSomeGaps #

## Exercise 8.1 ##

Most languages with a C-like syntax do not offer an elseif construct. Why does Lua need this construct more than those languages?

``Guess there are no switch-case statement in lua``

## Exercise 8.2 ##

Describe four different ways to write an unconditional loop in Lua. Which one do you prefer?

```markdown
1. while true do xxx end
2. repeat xxx until false
3. do ::B1:: xxx goto B1 end
4. local f1; f1 = function() xxx f1() end f1()
```

## Exercise 8.3 ##

Many people argue that repeat--until is seldom used, and therefore it should not be present in a minimalistic language like Lua. What do you think?

``I don't care``

## Exercise 8.4 ##

As we saw in the section called “Proper Tail Calls”, a tail call is a goto in disguise. Using this idea, reimplement the simple maze game from the section called “break, return, and goto” using tail calls. Each block should become a new function, and each goto becomes a tail call.

```lua
function room1()
    local move = io.read()
    local call
    if move == "south" then
        call = room3
    elseif move == "east" then
        call = room2
    else
        print("invalid move")
        call = room1
    end
    call()
end

function room2()
    local move = io.read()
    local call
    if move == "south" then
        call = room4
    elseif move == "west" then
        call = room1
    else
        print("invalid move")
        call = room2
    end
    call()
end

function room3()
    local move = io.read()
    local call
    if move == "north" then
        call = room1
    elseif move == "east" then
        call = room4
    else
            print("invalid move")
            call = room3
    end
    call()
end

function room4()
	print("Congratulations, you won!")
end
room1()
```

## Exercise 8.5 ##

Can you explain why Lua has the restriction that a goto cannot jump out of a function? (Hint: how would you implement that feature?)

``programmer will be confused``

## Exercise 8.6 ##

Assuming that a goto could jump out of a function, explain what the program in Figure 8.3, “A strange (and invalid) use of a goto” would do.

```lua
function getlabel ()
	return function () goto L1 end
	::L1::
	return 0
end

function f (n)
	if n == 0 then return getlabel()
	else
		local res = f(n - 1)
		print(n)
		return res
	end
end

x = f(10)
x()
```

Figure 8.3. A strange (and invalid) use of a goto

(Try to reason about the label using the same scoping rules used for local variables.)

[StrangeGoto](./Resources/StrangeGoto.lua)

```markdown
运行上面的Lua程序得到以下结果：
.\strange_goto.lua:3: no visible label 'L1' for <goto> at line 2
猜测可能的结果为：
print 1~10  and  x() return 0???
```
