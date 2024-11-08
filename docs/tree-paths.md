- [Creating Tree-Path Lists](#creating-tree-path-lists)
  - [Upwards Paths `Node > Parent > ...`](#upwards-paths-node--parent--)
  - [Upwards Paths that must Terminate at Root `Node > Parent > ... > Root`](#upwards-paths-that-must-terminate-at-root-node--parent----root)
  - [Downards Paths `Node > Child > ...`](#downards-paths-node--child--)
  - [Downwards Paths that must Terminate at Leaf `Node > Child > ... > Leaf`](#downwards-paths-that-must-terminate-at-leaf-node--child----leaf)


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



