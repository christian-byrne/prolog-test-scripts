/**
 * Author:      Christian Byrne
 * Course:      CSc 372
 * Assignment:  Large Assignment 2
 * Description: Practice with Prolog, emphasizing recursion, graphs and list 
 *              manipulation.
 */


/**
 * 1
 * teammate(X, Y)
 * X and Y are on the same team, managed by the same person.
 */
teammate(X, Y) :- 
  manager(CommonManager, X), 
  manager(CommonManager, Y), 
  X \= Y.

/**
 * 2
 * bossOfBoss(X, Y)
 * X is the boss of Y's boss.
 */
bossOfBoss(X, Y) :- 
  manager(X, MiddleMan),
  manager(MiddleMan, Y).

/**
 * 3
 * superior(X, Y)
 * X is a superior to Y (i.e. higher up in the chain of command).
 */
superior(X, Y) :- 
  manager(X, Y) ; 
  manager(X, Z), 
  superior(Z, Y).

/**
 * 4
 * sameRank(X, Y)
 * X and Y are at the same rank in the management chain.
 */
sameRank(X, Y) :-
  tier(X, Xtier),
  tier(Y, Ytier),
  Xtier = Ytier.

/** tier(Employee, N): Employee is N tiers from the top of the company */
tier(Employee, 0) :- isRoot(Employee).
tier(Employee, Tiers) :-
  manager(Manager, Employee),
  tier(Manager, ManagerTiers),
  Tiers is ManagerTiers + 1.
isRoot(X) :- manager(X, _), not(manager(_, X)).

/**
 * 5
 * chainOfCommand(X)
 * X is a list indicating a chain of command from highest to lowest rank.
 */
chainOfCommand([_]).
chainOfCommand([Manager | T]) :-
  manager(Manager, Employee),
  chainOfCommand([Employee | NewT]),
  T = [Employee | NewT].

/**
 * 6
 * last(X, Y)
 * X is the last element in the list Y.
 */
last(X, [X]).
last(X, [_ | Tail]) :-
  last(X, Tail).

/**
 * 7
 * merge(X, Y, Z)
 * Z is sorted list X merged with sorted list Y; do not use append or sort.
 */
merge([], X, X).
merge(X, [], X).
merge([Head1 | Tail1], [Head2 | Tail2], [Head1 | MergedTail]) :-
  Head1 =< Head2,
  merge(Tail1, [Head2 | Tail2], MergedTail).
merge([Head1 | Tail1], [Head2 | Tail2], [Head2 | MergedTail]) :-
  Head1 > Head2,
  merge([Head1 | Tail1], Tail2, MergedTail).

/**
 * 8
 * repeat(X, N, Z)
 * Z is list X repeated N times
 */
repeat(_, 0, []).
repeat(X, 1, X).
repeat(X, N, Z) :-
  N > 1,
  NMinus1 is N - 1,
  repeat(X, NMinus1, Z1),
  concatList(X, Z1, Z).
concatList([], [], []).
concatList([], [Head | Tail], [Head | Tail]).
concatList([Head | Tail], List, [Head | ConcatedTail]) :-
  concatList(Tail, List, ConcatedTail).

/**
 * 9
 * sublist(X, I, J, Y)
 * Y is a sublist of X starting at index I (inclusive) and ending at index J 
 * (exclusive); indexing starts at 0; you can assume that the indexes given 
 * will be appropriate for the list.
 */
sublist(_, I, J, []) :- I = J.
sublist(X, I, J, [H | T]) :-
  IPlus1 is I + 1,
  nth0(I, X, H),
  sublist(X, IPlus1, J, T).

/**
 * 10
 * insert(X, Y, Z)
 * Assume Y is a sorted list; Z is Y with X inserted into it so that it is 
 * still sorted.
 */
insert(X, Y, Z) :- merge([X], Y, Z).

/**
 * 11
 * fullPlacement(X): X is a possible placement for all the numbers in the grid 
 *                   (X is a list of lists)
 * 
 * The grid is a 4x4 Sudoku puzzle board. 
 * A solution to the puzzle is a placement of 1’s, 2’s, 3’s, and 4’s so that4×4
 *  - every row has a 1, a 2, a 3, and a 4
 *  - every column has a 1, a 2, a 3, and a 4
 *  - each of the four quarters of the grid has a 1, a 2, a 3, and a 4
 *  - no row has two of the same number
 *  - no column has two of the same number
 *  - none of the four quarters of the grid has two of the same number
 */
fullPlacement(Matrix) :- isSolution(Matrix, []).

/** isSolution(X, Y): X is valid solution to 4x4 Sudoku puzzle with indices Y */
isSolution([], _).
isSolution([H | T], Seen) :-
    length(H, 4),
    isValidPlacements(H, [1, 2, 3, 4], [1, 2, 3, 4], [1/1, 1/2, 2/1, 2/2], Seen, NewSeen),
    isSolution(T, NewSeen).

/** quadrant(R/C, Qr/Qc): Qr/Qc are the quadrant row/column containing R/C */
quadrant(R/C, Qr/Qc) :- Qr is ceil(R / 2), Qc is ceil(C / 2).

% To Remember: base case instatiates accumulator/result in recursive predicates
% (tail recursion doesn't mean immediate resolution in prolog)
isValidPlacements([], _, _, _, Seen, Seen).
isValidPlacements([R/C | T], NotSeenRows, NotSeenCols, NotSeenQuadrants, Seen, NewSeen) :-
  member(R, NotSeenRows),
  member(C, NotSeenCols),
  not(member(R/C, Seen)),
  quadrant(R/C, Q),
  member(Q, NotSeenQuadrants),
  select(Q, NotSeenQuadrants, NewQuadrants),
  select(R, NotSeenRows, NewRows),
  select(C, NotSeenCols, NewCols),
  isValidPlacements(T, NewRows, NewCols, NewQuadrants, [R/C | Seen], NewSeen). 

/** 12
 * tsp(G, M, C, D): C is a cycle in G that visits every city exactly once and 
 * whose total distance D is less than or equal to M
 * 
 * In the traveling salesperson problem, we start with a graph where vertices 
 * are cities and the edges are the distances between those cities. The goal is 
 * to find a route that:
 *   - starts and ends at the same city
 *   - visits every city exactly once
 *   - minimizes the total distance traveled
 * 
 * Since finding a route that is actually optimal is difficult, this version of 
 * the problem specifically looks for a route that:
 *   - starts and ends at the same city
 *   - visits every city exactly once
 *   - has a total distance <= to a maximum distance parameter
 */
tsp(Graph, MaxDistance, Cycle, Distance) :-
  fullGraph(Graph), % I can't tell if we are supposed to expect this predicate to exist and if we have to verify the graph spans some other graph defined somewhere else
  length(Graph, Len),
  length(Cycle, LenCycle),
  LenCycle >= Len,
  includesVertices(Cycle, Graph),
  isClosed(Cycle),
  totalDistance(Cycle, Distance),
  Distance =< MaxDistance,
  allVisited(Graph, Cycle).

/** isClosed(Cycle): Cycle starts and ends at the same city */
isClosed([_]).
isClosed([H | T]) :- last(Last, T), H = Last.

/** allVisited(Cycle, Graph): All cities in Graph are visited in Cycle */
allVisited([], _).
allVisited([H | T], Cycle) :- member(H, Cycle), allVisited(T, Cycle).

/** totalDistance(Cycle, Dist): Dist is the total distance of Cycle */
totalDistance([_], 0).
totalDistance([H1, H2 | T], Dist):-
  distance(H1, H2, DistCur),
  totalDistance([H2 | T], NewDist),
  Dist is NewDist + DistCur.
distance(X, Y, D) :- dist(X, Y, D).
distance(X, Y, D) :- dist(Y, X, D).

/** 13
 * kclique(G,C,K): C is a clique of size K in graph G
 * 
 * Finds a clique of size K in a given graph (if one exists).
 * A clique in a graph is a subgraph in which all the vertices are connected 
 * to each other.
 */
kclique(Graph, Cycle, K) :-
  length(Cycle, K),
  includesVertices(Cycle, Graph),
  isConnected(Cycle).

/** isConnected(C): All vertices in C are connected to each other */
isConnected([_]).
isConnected([H | T]) :- isConnectedTo(H, T), isConnected(T).
isConnectedTo(_, []).
isConnectedTo(Target, [H | T]) :- edgeBetween(Target, H), isConnectedTo(Target, T).

/** edgeBetween(P, Q): There is an edge between P and Q in either direction */
edgeBetween(P, Q) :- edge(P, Q, _).
edgeBetween(P, Q) :- edge(Q, P, _).

/**
 * 14
 * dominatingSet(G,D,S): D is a dominating set of graph G of size S
 * 
 * Let G be a graph. Let D be a subset of the vertices in G. D is a dominating 
 * set of G if every vertex in G is either in D or has a neighbor in D. In 
 * this problem, you need to write a predicate (with helpers) that determines 
 * a dominating set of a graph G of a given size.
 * 
 */
dominatingSet(Graph, DominatingS, Size) :-
  length(DominatingS, Size),
  isDominating(DominatingS, Graph).

/** includesVertices(V, G): All vertices in V are in G */
includesVertices([], _).
includesVertices([H], Graph) :- member(H, Graph).
includesVertices([H | T], Graph) :-
  member(H, Graph),
  includesVertices(T, Graph).

/** isDominating(D, G): D is a dominating set of graph G */
isDominating(D, [HG]) :- inOrConnected(HG, D).
isDominating(D, [HG | TG]) :- inOrConnected(HG, D), isDominating(D, TG).

/** inOrConnected(Vertex, Graph): Vertex is in Graph or has a neighbor in Graph */
inOrConnected(Vertex, Graph) :- member(Vertex, Graph).
inOrConnected(Vertex, Graph) :- member(GE, Graph), edgeBetween(GE, Vertex).

