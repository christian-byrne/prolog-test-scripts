/**
 * Author:      Christian Byrne
 * Course:      CSc 372
 * Assignment:  LA2
 */

:- consult(company).


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
  tiersFromHighestRank(X, Xtier),
  tiersFromHighestRank(Y, Ytier),
  Xtier = Ytier.

isHighestRank(X) :-
  manager(X, _),
  not(manager(_, X)).

tiersFromHighestRank(Employee, 0) :-
  isHighestRank(Employee).

tiersFromHighestRank(Employee, Tiers) :-
  manager(Manager, Employee),
  tiersFromHighestRank(Manager, ManagerTiers),
  Tiers is ManagerTiers + 1.


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

% TODO: Rename to `repeat` before turning in

repeatN(_, 0, []).
repeatN(X, 1, X).
repeatN(X, N, Z) :-
  N > 1,
  NMinus1 is N - 1,
  repeatN(X, NMinus1, Z1),
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
sublist(_, I, J, []) :-
  I >= J.
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

% TODO: Rename to `insert` before turning in

insertN(X, Y, Z) :- merge([X], Y, Z).


/* -------------------------------------------------------------------------- */
/*                             The Sodoku Problem                             */
/* -------------------------------------------------------------------------- */

% (1) Define domain of indices: D^2 = {1, 2, 3, 4}^2.     
domain(1).
domain(2).
domain(3).
domain(4).
domainSquared(I, J) :- domain(I), domain(J).

% (2) Assert all elements of D^2 are in the grid: ¬∃(i,j ∈ D)(¬(i/j ∈ X))
allDomainObjectsIn(MatrixTerms) :- \+ (domainSquared(I, J), \+ (member(I/J, MatrixTerms))).

% (3) Predicate for set of subgrid index sets: ∀p,q ∈ {0, 1},{i/j ∣ i ∈ {2p+1, 2p+2}, j ∈ {2j+1, 2j+2}},
%     row index sets, and column index sets.  
subgridOffset(0).
subgridOffset(1).
subgridDomain(Offset, X1, X2):- X1 is Offset*2 + 1, X2 is Offset*2 + 2.
subgridDomainSquared([I1/J1, I1/J2, I2/J1, I2/J2]) :- 
  subgridOffset(Offset1),
  subgridOffset(Offset2),
  subgridDomain(Offset1, I1, I2),
  subgridDomain(Offset2, J1, J2).
rows(Row, Index):- Index = Row/1 ; Index = Row/2 ; Index = Row/3 ; Index = Row/4.
cols(Col, Index):- Index = 1/Col ; Index = 2/Col ; Index = 3/Col ; Index = 4/Col.

% (5) For all sets of subgrid, row, col indices: 
%     Assert that ∃x(x ∈ PlacementIndices ∧ x ∈ Subgrid/Row/Col Indices)
isInEachSubgrid(PlacementIndices) :-
  \+ (subgridDomainSquared(Subgrid), \+ (member(Placement, PlacementIndices), member(Placement, Subgrid))).
numbersInEachSubgrid([]).
numbersInEachSubgrid([H | T]) :- isInEachSubgrid(H), numbersInEachSubgrid(T).

concatLists([], []).
concatLists([SubList | Lists], Concatenated) :-
  concatList(SubList, ConcatenatedTail, Concatenated),
  concatLists(Lists, ConcatenatedTail).

allLength4([]).
allLength4([H | T]) :- length(H, 4), allLength4(T).

all_starts_present(List, Seen) :-
    has_start(1, List, Seen),
    has_start(2, List, Seen),
    has_start(3, List, Seen),
    has_start(4, List, Seen).

all_ends_present(List, Seen) :-
    has_end(1, List, Seen),
    has_end(2, List, Seen),
    has_end(3, List, Seen),
    has_end(4, List, Seen).

has_end(End, List, Seen) :-
    member(X/End, List), 
    not(member(X/End, Seen)).

has_start(Start, List, Seen) :-
    member(Start/X, List), 
    not(member(Start/X, Seen)).

hasAll([], _).
hasAll([H | T], Seen) :-
  all_starts_present(H, Seen),
  all_ends_present(H, Seen),
  hasAll(T, [H | Seen]).

fullPlacement([[1/1, 2/3, 3/4, 4/2], [1/3, 2/2, 3/1, 4/4], [1/4, 2/1, 3/2, 4/3], [1/2, 2/4, 3/3, 4/1]]).
fullPlacement(Matrix) :-
  allLength4(Matrix),
  hasAll(Matrix, []),
  numbersInEachSubgrid(Matrix),
  concatLists(Matrix, Flattened),
  allDomainObjectsIn(Flattened), !.



/* -------------------------------------------------------------------------- */
/*                      The Traveling Salesperson Problem                     */
/* -------------------------------------------------------------------------- */


fullGraph([albany, annapolis, atlanta, austin, baton_rouge, boston]).

dist(albany, annapolis, 469).
dist(albany, atlanta, 1356).
dist(albany, austin, 2538).
dist(albany, baton_rouge, 2056).
dist(albany, boston, 224).
dist(atlanta, annapolis, 915).
dist(atlanta, austin, 1318).
dist(atlanta, baton_rouge, 736).
dist(atlanta, boston, 1507).
dist(annapolis, austin, 2168).
dist(annapolis, baton_rouge, 1639).
dist(annapolis, boston, 593).
dist(austin, baton_rouge, 634).
dist(austin, boston, 2729).
dist(baton_rouge, boston, 2225).
dist(tucson, atlanta, 2478).
dist(tucson, albany, 2526).
dist(tucson, annapolis, 3186).
dist(tucson, baton_rouge, 1887).
dist(tucson, boston, 3669).
dist(tucson, austin, 1275).

% tsp(G, M, C, D): C is a cycle in G that visits every city exactly once and whose total distance D is less than or equal to M

distance(X, Y, D) :- dist(X, Y, D).
distance(X, Y, D) :- dist(Y, X, D).

allVisited([], _).
allVisited([H | T], Cycle) :-
  member(H, Cycle),
  allVisited(T, Cycle).

isClosed([_]).
isClosed([H | T]) :-
  last(Last, T),
  H = Last.

seenAll(Cycle, Graph) :-
  allVisited(Graph, Cycle).

totalDistance([_], 0).
totalDistance([H1, H2 | T], Dist):-
  distance(H1, H2, DistCur),
  totalDistance([H2 | T], NewDist),
  Dist is NewDist + DistCur.

tsp(Graph, MaxDistance, Cycle, Distance) :-
  fullGraph(Graph),
  length(Graph, Len),
  length(Cycle, LenCycle),
  LenCycle >= Len,
  isClosed(Cycle),
  totalDistance(Cycle, Distance),
  Distance =< MaxDistance,
  seenAll(Cycle, Graph).




/* -------------------------------------------------------------------------- */
/*                            The K-Clique Problem                            */
/* -------------------------------------------------------------------------- */

% graph 1: unweighted
edge(a,b,1).
edge(a,e,1).
edge(b,c,1).
edge(b,g,1).
edge(b,d,1).
edge(b,e,1).
edge(c,e,1).
edge(c,d,1).
edge(d,e,1).
edge(d,g,1).
edge(e,f,1).
edge(f,g,1).
edge(f,h,1).

% graph 2: unweighted
edge(i,j,1).
edge(i,l,1).
edge(j,k,1).
edge(k,l,1).

% graph 3: weighted
edge(m,n,1).
edge(m,r,3).
edge(n,r,4).
edge(n,o,3).
edge(n,q,5).
edge(o,q,4).
edge(o,p,1).
edge(p,q,2).
edge(q,r,2).

graph([a,b,c,d,e,f,g,h]).
graph([i,j,k,l]).
graph([m,n,o,p,q,r]).

isConnected([_], 0).
isConnected([H1, H2], Size) :-
  edge(H1, H2, Size).
isConnected([H1, H2 | T], Size) :-
  edge(H1, H2, Add),
  isConnected([H2 | T], NS),
  Size is Add + NS.

kclique(Graph, Cycle, K) :-
  graph(Graph),
  isConnected(Cycle, K).


/* -------------------------------------------------------------------------- */
/*                         The Dominating Set Problem                         */
/* -------------------------------------------------------------------------- */




edgeBidirectional(P, Q) :- edge(P, Q, _).
edgeBidirectional(P, Q) :- edge(Q, P, _).

inOrHasNeighbor(Vertex, Graph) :- member(Vertex, Graph).
inOrHasNeighbor(Vertex, Graph) :-
  member(GE, Graph),
  edgeBidirectional(GE, Vertex).

isDominating(D, [HG]) :- inOrHasNeighbor(HG, D).
isDominating(D, [HG | TG]) :-
  inOrHasNeighbor(HG, D),
  isDominating(D, TG).

dominatingSet(Graph, DominatingS, Size) :-
  length(DominatingS, Size),
  isDominating(DominatingS, Graph).