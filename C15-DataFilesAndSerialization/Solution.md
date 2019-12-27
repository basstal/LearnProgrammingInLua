# DataFilesAndSerialization #

Exercise 15.1: Modify the code in Figure 15.2, “Serializing tables without cycles” so that it indents nested tables. (Hint: add an extra parameter to serialize with the indentation string.)

Exercise 15.2: Modify the code of the previous exercise so that it uses the syntax ["key"]=value, as suggested in the section called “Saving tables without cycles”.

Exercise 15.3: Modify the code of the previous exercise so that it uses the syntax ["key"]=value only when necessary (that is, when the key is a string but not a valid identifier).

Exercise 15.4: Modify the code of the previous exercise so that it uses the constructor syntax for lists whenever possible. For instance, it should serialize the table {14, 15, 19} as {14, 15, 19}, not as {[1] = 14, [2] = 15, [3] = 19}. (Hint: start by saving the values of the keys 1, 2, ..., as
long as they are not nil. Take care not to save them again when traversing the rest of the table.)

Exercise 15.5: The approach of avoiding constructors when saving tables with cycles is too radical. It is possible to save the table in a more pleasant format using constructors for the simple case, and to use assignments later only to fix sharing and loops. Reimplement the function save (Figure 15.3, “Saving tables with cycles”) using this approach. Add to it all the goodies that you have implemented in the previous exercises (indentation, record syntax, and list syntax).