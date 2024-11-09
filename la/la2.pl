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
  % I < J,
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

/**
 * 7
 * merge(X, Y, Z)
 * Z is sorted list X merged with sorted list Y; do not use append or sort.
 */


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



