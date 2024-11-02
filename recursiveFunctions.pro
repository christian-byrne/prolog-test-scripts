% count(X,L,C) : C is the number of occurrences of X in list L
count(_,[],0).
count(X,[X|T],C) :- count(X,T,TailC), C is 1 + TailC.
count(X,[H|T],C) :- not(X=H), count(X,T,C).

% fib(N,F): F is the Nth fibonacci number
fib(0,0).
fib(1,1).
fib(N,F) :-
N>1,
N1 is N - 1,
fib(N1,F1),
N2 is N - 2,
fib(N2,F2),
F is F1 + F2.

% removeAll(X,Y,Z): Z is list Y with all occurrences of X removed
removeAll(X,L,L) :- not(member(X,L)).
removeAll(X,L,R) :- member(X,L), select(X,L,S), removeAll(X,S,R).

% tripList(L): L is a list with every element listed three times
tripList([X,X,X]).
tripList([X,X,X|Tail]) :- tripList(Tail).

% addAll(X,S) : the sum of all the elements in X is S
% the sum of the elements in an empty list is 0
addAll([],0).
addAll([H|T],Sum) :- addAll(T,TailSum), Sum is H + TailSum.

% sequence(L,D): L is an arithmetic sequence with the common difference D
sequence([_],_).
sequence([X,Y|T], D) :- D is Y - X, sequence([Y|T],D).
