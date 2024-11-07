married(lily, togo).

notEqual(X, Y) :-
  X \= Y.

notEqual(lily, togo).
notEqual(togo, lily).

isMarried(X, Y) :-
  X \= Y,
  married(X, Y).