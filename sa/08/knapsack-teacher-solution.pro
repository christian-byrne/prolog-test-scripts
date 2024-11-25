pantry([food(bread,1,3200),
food(pasta,2,4500),
food(peanutButter,3,6700),
food(apple,1,2300),
food(nuts,1,3400)]).
% subsetMC(X,Y): X is a subset of Y that allows for repeated elements
subsetMC([],_).
subsetMC([X|TailX],Y) :-
member(X,Y),
subsetMC(TailX,Y).
% weight(X,Y): Y is the total weight of the items in list X
weight([],0).
weight([(food(_,W,_))|Tail],TW):-
weight(Tail,TTW),
TW is TTW + W.
% totalCal(K,TC): TC is the total number of calories of all the items in list
% K
totalCal([],0).
totalCal([(food(_,_,C))|Tail],TC) :-
totalCal(Tail,TTC),
TC is TTC + C.
% knapsackMC(P,C,K,T): K is a subset of the items in P (allowing for
% duplicates) whose total weight does not exceed C and whose total calorie
% count is at least T

knapsackMC(P,C,K,T) :-
  length(K,L),
  L > 0,
  L =< C,
  subsetMC(K,P),
  totalCal(K,TC),
  TC >= T,
  weight(K,W),
  W =< C.
