- [Instantiating an Accumulator in the Base Case](#instantiating-an-accumulator-in-the-base-case)
- [Iterating Recursively with an Index Variable](#iterating-recursively-with-an-index-variable)
- [Creating Tree-Path Lists](#creating-tree-path-lists)
  - [Upwards Paths `Node > Parent > ...`](#upwards-paths-node--parent--)
  - [Upwards Paths that must Terminate at Root `Node > Parent > ... > Root`](#upwards-paths-that-must-terminate-at-root-node--parent----root)
  - [Downards Paths `Node > Child > ...`](#downards-paths-node--child--)
  - [Downwards Paths that must Terminate at Leaf `Node > Child > ... > Leaf`](#downwards-paths-that-must-terminate-at-leaf-node--child----leaf)
- [List Operations](#list-operations)
  - [Concatenating Lists](#concatenating-lists)
  - [Reversing Lists](#reversing-lists)


# Instantiating an Accumulator in the Base Case

```prolog
isSolution(_, Capacity, Threshold, K, K) :- Capacity >= 0, Threshold =< 0.
isSolution(Domain, Capacity, Threshold, Knapsack, NewKnapsack) :-
  member(item(Item, W, V), Domain),
  NewC is Capacity - W,
  NewC >= 0,
  NewT is Threshold - V,
  isSolution(Domain, NewC, NewT, [item(Item, W, V) | Knapsack], NewKnapsack).
```

# Iterating Recursively with an Index Variable

The issue lies in how Prolog handles recursion and unification. Let’s break down why this happens:

Base Case:

The base case of your predicate is sequence(L, 0, L). This succeeds when N is 0, and the first argument (L) unifies with the third argument (NewL).
However, Prolog uses depth-first search for execution, which means it continues attempting recursive rules before trying to resolve unifications from the base case.
Recursive Case:

The recursive rule sequence(L, N, NewL) :- N1 is N - 1, sequence([N | L], N1, NewL). reduces N by 1 and prepends N to the list L. This is a tail-recursive predicate, but Prolog doesn't perform tail-call optimization, so each call consumes stack space.
Infinite Loop:

If you call sequence(L, N, L) without giving an explicit initial N, Prolog tries to unify the recursive rule repeatedly.
For instance, if you invoke sequence(L, 0, L), Prolog successfully matches the base case. But due to its execution order, it then tries the recursive rule as well, leading to another attempt to invoke sequence with decremented N values, creating an infinite loop.
Fixing the Problem
You can avoid the infinite loop and stack overflow by ensuring the recursion halts properly. Add a guard to ensure N is greater than 0 before attempting recursion:

```prolog
naturalSeqN(L, 0, L).
naturalSeqN(L, N, NewL) :- N > 0, N1 is N - 1, naturalSeqN([N | L], N1, NewL).
```

# Creating Tree-Path Lists

## Upwards Paths `Node > Parent > ...`

Creating lists the start at some node and create lists going up the tree, with the last list being `[node, parent, grandparent, ...]`.

```prolog
upwardPath([_]).
upwardPath([Node | T]) :-
  parent(Parents, Node),
  upwardPath([Parents | NewT]),
  T = [Parents | NewT].
```

It will start by finding the first `parent(X, Y)` relationship defined in the database (i.e., the first `parent` at the top of the file).

Then, it will recursively call `upwardPath` with the parent as the argument, and the tail of the list as the second argument.

The first path starting at the first `X` found to fully resolve upwards (after backtracking fully) will be printed first.

If the first relationship observed was `parent(Root, Y)`, then the very first arguments used will resolve out of the recursion immediately, and the first list will be `[Y, Root]`.

The first observed `X` in the database can be thought of as the start point for a post-order traversal of the tree. 

## Upwards Paths that must Terminate at Root `Node > Parent > ... > Root`

Same as [Upwards Paths](#upwards-paths-node--parent--) but make base case only work with root. Lists will be `[node, parent, grandparent, ..., root]`.

```prolog
upwardPath([Root]).
  isRoot(Root).
  
upwardPath([Node | T]) :-
  parent(Parents, Node),
  upwardPath([Parents | NewT]),
  T = [Parents | NewT].
```

## Downards Paths `Node > Child > ...`

Creating lists that start at some node and go down the tree, with the last list being `[node, child, grandchild, ...]`.

```prolog
downwardPath([_]).
downwardPath([Parent | T]) :-
  parent(Parent, Node),
  downwardPath([Node | NewT]),
  T = [Node | NewT].
```

## Downwards Paths that must Terminate at Leaf `Node > Child > ... > Leaf`

Same as [Downwards Paths](#downards-paths-node--child--) but make base case only work with leaf. Lists will be `[node, child, grandchild, ..., leaf]`.

```prolog
downwardPath([Leaf]) :-
  isLeaf(Leaf).

downwardPath([Parent | T]) :-
  parent(Parent, Node),
  downwardPath([Node | NewT]),
  T = [Node | NewT].
```

# List Operations

## Concatenating Lists

```prolog
concatList([], [], []).
concatList([], [Head | Tail], [Head | Tail]).
concatList([Head | Tail], List, [Head | ConcatedTail]) :-
  concatList(Tail, List, ConcatedTail).
```

## Reversing Lists

```prolog
reverseList([], []).
reverseList([Head | Tail], Reversed) :-
  reverseList(Tail, ReversedTail),
  concatList(ReversedTail, [Head], Reversed).
```