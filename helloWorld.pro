% This is a comment.

grandparent(X,Y) :- parent(X,P), parent(P,Y).

sibling(X,Y) :- parent(P,X), parent(P,Y), not(X=Y).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(P,Y), ancestor(X,P).


% to read in a file: consult(filename)