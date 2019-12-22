# C11-Solution #

## Exercise 11.1 ##

When we apply the word-frequency program to a text, usually the most frequent words are uninteresting small words like articles and prepositions. Change the program so that it ignores words with less than four letters.

``string.len(word) > 4``

## Exercise 11.2 ##

Repeat the previous exercise but, instead of using length as the criterion for ignoring a word, the program should read from a text file a list of words to be ignored.

``Read this file as a dictionary and exclude those word appeared in this dictionary.``
