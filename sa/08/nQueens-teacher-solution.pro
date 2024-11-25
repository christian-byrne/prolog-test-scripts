% noThreat(X/Y,L): a Queen at position X/Y poses no threat to all the
% locations in list L
noThreat(_,[]).
noThreat(X/Y, [X1/Y1|Tail]) :-
X =\= X1,
Y =\= Y1,
abs(Y1-Y) =\= abs(X1-X),
noThreat(X/Y,Tail).
% board(X,N): X is a list of possible rows/columns in an NXN board
board([1],1).
board([N|Tail],N) :-
N1 is N-1,
board(Tail,N1).
% legal(X,N): all locations in list X are legal in an NXN board and present
% no threat to each other
legal([],_).
legal([X/Y|Tail],N) :-
board(B,N),
legal(Tail,N),
member(X,B),
member(Y,B),
noThreat(X/Y,Tail).
% nQueens(N,X): X is a list of N Queen placements such that none of them are
% threatening each other
nQueens(N,X) :- length(X,N), legal(X,N).