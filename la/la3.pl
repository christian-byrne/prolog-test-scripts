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

% TODO: this returns: true ; false

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

% (3) Assert all terms in grid are in D: ¬∃(i/j ∈ X)(¬(i ∈ D ∧ j ∈ D))
allMatrixTermsIn([]).
allMatrixTermsIn([R/C | T]) :- domain(R), domain(C), allMatrixTermsIn(T).

% (4) Predicate for set of subgrid index sets: ∀p,q ∈ {0, 1},{i/j ∣ i ∈ {2p+1, 2p+2}, j ∈ {2j+1, 2j+2}},
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
  \+ (domain(I), \+ (rows(I, RowIndex), member(RowIndex, PlacementIndices))).
  \+ (domain(I), \+ (cols(I, Index), member(RowIndex, PlacementIndices))).
  % \+ (cols(Col, ColIndex), \+ (member(_/ColIndex, PlacementIndices))),
  % \+ (subgridDomainSquared(Subgrid), \+ (member(Placement, PlacementIndices), member(Placement, Subgrid))).
numbersInEachSubgrid([]).
numbersInEachSubgrid([H | T]) :- isInEachSubgrid(H), numbersInEachSubgrid(T).

concat2D([], []).
concat2D([SubList | Lists], Concatenated) :-
  concatList(SubList, ConcatenatedTail, Concatenated),
  concat2D(Lists, ConcatenatedTail).

% Handle base case when there isn't a single instatiated term
fullPlacement([[1/1, 2/3, 3/4, 4/2], [1/3, 2/2, 3/1, 4/4], [1/4, 2/1, 3/2, 4/3], [1/2, 2/4, 3/3, 4/1]]).
fullPlacement(Matrix) :-
  concat2D(Matrix, Flattened),
  allMatrixTermsIn(Flattened),
  allDomainObjectsIn(Flattened),
  numbersInEachSubgrid(Matrix).


/* -------------------------------------------------------------------------- */
/*                      The Traveling Salesperson Problem                     */
/* -------------------------------------------------------------------------- */


/**
 * 7
 * merge(X, Y, Z)
 * Z is sorted list X merged with sorted list Y; do not use append or sort.
 */


/* -------------------------------------------------------------------------- */
/*                            The K-Clique Problem                            */
/* -------------------------------------------------------------------------- */


/**
 * 7
 * merge(X, Y, Z)
 * Z is sorted list X merged with sorted list Y; do not use append or sort.
 */


/* -------------------------------------------------------------------------- */
/*                         The Dominating Set Problem                         */
/* -------------------------------------------------------------------------- */



/**
 * 7
 * merge(X, Y, Z)
 * Z is sorted list X merged with sorted list Y; do not use append or sort.
 */



