# DateAndTime #

## Exercise 12.1 ##

Write a function that returns the date–time exactly one month after a given date–time. (Assume the numeric coding of date–time.)

```lua
function numericDateIncOneMonth(numericData)
    local d = os.date("*t", numericData)
    d.month = d.month + 1
    return d
end
```

## Exercise 12.2 ##

Write a function that returns the day of the week (coded as an integer, one is Sunday) of a given date.

```lua
local fullName = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"}

function dayOfWeek(dateTime)
    local d = os.date("%a", dateTime)
    for i, name in ipairs(fullName) do
        if name == d then
            return i
        end
    end
end
```

## Exercise 12.3 ##

Write a function that takes a date–time (coded as a number) and returns the number of seconds passed since the beginning of its respective day.

```lua
function elapseSecondsOfDay(dateTime)
    local d = os.date("*t", dateTime)
    local elapse = d.hour * 3600 + d.min * 60 + d.sec
    return elapse
end
```

## Exercise 12.4 ##

Write a function that takes a year and returns the day of its first Friday.

```lua
function firstFridayOfYear(year)
    local t = {
        year = year,
        month = 1,
        day = 1,
    }
    local time = os.time(t)
    t = os.date("*t", time)
    while t.wday ~= 6 do
        t.day = t.day + 1
        time = os.time(t)
        t = os.date("*t", time)
    end
    print(os.date("%Y/%m/%d", time))
end

firstFridayOfYear(2019)
```

## Exercise 12.5 ##

Write a function that computes the number of complete days between two given dates.

```lua
function daysOfTwoDate(date1, date2)
    local diff = os.difftime(date2, date1)
    local d = os.date("*t", diff)
    local diffDays = d.year * 365 + d.month * 30 + d.day
    return diffDays
end

```

PS:result is not exactly right

## Exercise 12.6 ##

Write a function that computes the number of complete months between two given dates.

``same as previous exercise``

## Exercise 12.7 ##

Does adding one month and then one day to a given date give the same result as adding one day and then one month?

``no``

## Exercise 12.8 ##

Write a function that produces the system's time zone.
