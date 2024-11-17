% R/C
inBoard(R/C) :- L = [1,2,3,4,5,6,7,8], member(R,L), member(C,L). 

legalPair(R1/C1,R2/C2) :-
  inBoard(R1/C1),
  inBoard(R2/C2),
  DR is R1 - R2,
  not(DR = 0),
  DC is C1 - C2,
  not(DC = 0),
  S is DR/DC,
  not(S = 1),
  not(S = -1).

legalLoc(_,[]).
legalLoc(P,[X|T]) :-
  legalPair(P,X),
  legalLoc(P,T).

legalList([]).
legalList([P|Tail]) :- legalLoc(P,Tail), legalList(Tail).

placement(X) :- X = [1/_,2/_,3/_,4/_,5/_,6/_,7/_,8/_], legalList(X). 