# DataStructures #

## Exercise 14.1 ##

Write a function to add two sparse matrices.

[SparseMatricesAdd.lua](./Resources/SparseMatricesAdd.lua)

## Exercise 14.2 ##

Modify the queue implementation in Figure 14.2, “A double-ended queue” so that both indices return to zero when the queue is empty.

[ADoubleEndedQueue.lua](./Resources/ADoubleEndedQueue.lua)

## Exercise 14.3 ##

Modify the graph structure so that it can keep a label for each arc. The structure should represent each arc by an object, too, with two fields: its label and the node it points to. Instead of an adjacent set, each node keeps an incident set that contains the arcs that originate at that node.

Adapt the function readgraph to read two node names plus a label from each line in the input file.(Assume that the label is a number.)

[ReadGraph.lua](./Resources/ReadGraph.lua)

## Exercise 14.4 ##

Assume the graph representation of the previous exercise, where the label of each arc represents the distance between its end nodes. Write a function to find the shortest path between two given nodes, using Dijkstra's algorithm.


