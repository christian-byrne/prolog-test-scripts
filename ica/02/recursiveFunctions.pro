% 1. fib
% fib(N, F): F is the Nth Fibonacci number
fib(0, 1).                % Base case: the 0th Fibonacci number is 1.
fib(1, 1).                % Base case: the 1st Fibonacci number is 1.
fib(N, F) :-
  N > 1,                  % Ensure N is greater than 1 to avoid incorrect recursion.
  N1 is N - 1,            % Calculate N-1.
  N2 is N - 2,            % Calculate N-2.
  fib(N1, OneRecurse),    % Recursive call for fib(N-1).
  fib(N2, TwoRecurse),    % Recursive call for fib(N-2).
  F is OneRecurse + TwoRecurse. % Sum the results.


% 2. Count
% count(X, L, C) : C is the number of occurrences of X in list L
count(_, [], 0).
count(X, [X|T], C) :-
  count(X, T, TailC),
  C is 1 + TailC.
count(X, [H|T], C) :-
  X \= H,
  count(X, T, C).


% 3. removeAll
% removeAll(X, L, R): R is a list L with all occurrences of X removed
removeAll(_, [], []).                   % Base case: an empty list results in an empty list.
removeAll(Target, [Target|T], R) :-     % Case when the head of the list matches the target.
  removeAll(Target, T, R).              % Skip the head and continue removing from the tail.
removeAll(Target, [X|T], [X|R]) :-      % Case when the head of the list does not match the target.
  removeAll(Target, T, R).              % Keep the head and continue removing from the tail.


% 4. addLists(L1, L2, S): S is a list containing the sums of corresponding elements in L1 and L2, which are the same length
addLists([], [], []).                     % Base case: both lists empty, so result is empty.
addLists([X|T1], [Y|T2], [Sum|T3]) :-     % Recursive case: add heads of lists and recurse on tails.
  Sum is X + Y,                           % Calculate the sum of the heads.
  addLists(T1, T2, T3).                   % Recursive call for the tails.

% 5. dupList(X, Y): Y is a list X with each element repeated once
dupList([], []).
dupList([H1|L1], [H1, H1|L2]) :-
  dupList(L1, L2).

% 6. tripList(X): X is a list where every element is repeated three times
tripList([], []).
tripList([H1|L1], [H1, H1, H1|L2]) :-
  tripList(L1, L2).

% 7. isSet(X): X is a list with unique elements
isSet([]) :- true.
isSet([X|T]) :-
  count(X, T, 0),
  isSet(T).

% 8. subset(X, Y): X is a subset of Y -- assume Y is a set
subset([], _) :- true.
subset([X|L1], L2) :-
  member(X, L2),
  subset(L1, L2).


% 9. addAll(L, S): S is the sum of all the elements in L
addAll([], S) :- S.
addAll([X|L], S) :-
  Sum is S + X,
  S is Sum,
  addAll(L, S).
