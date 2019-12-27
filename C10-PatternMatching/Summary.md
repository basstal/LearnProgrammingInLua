# PatternMatching #

## Patterns ##

|pattern|meanings|
|---|---|
|.| all characters|
|%a| letters|
|%c| control characters|
|%d| digits|
|%g| printable characters except spaces|
|%l| lower-case letters|
|%p| punctuation characters|
|%s| space characters|
|%u| upper-case letters|
|%w| alphanumeric characters|
|%x| hexadecimal digits|

- **magic characters**:``( ) . % + - * ? [ ] ^ $``

|modifiers|meanings|
|---|---|
|+| 1 or more repetitions|
|*| 0 or more repetitions|
|-| 0 or more lazy repetitions|
|?| optional (0 or 1 occurrence)|