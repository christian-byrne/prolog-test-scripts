oppositeSides(e,w).
oppositeSides(w,e).

bad([S,O,O,_]) :- oppositeSides(S,O).
bad([S,_,O,O]) :- oppositeSides(S,O).

move(nothing,[M,W,G,C],[O,W,G,C]) :- oppositeSides(M,O).
move(wolf,[M,M,G,C],[O,O,G,C]) :- oppositeSides(M,O).
move(goat,[M,W,M,C],[O,W,O,C]) :- oppositeSides(M,O).
move(cabbage,[M,W,G,M],[O,W,G,O]) :- oppositeSides(M,O).

solution([],[[e,e,e,e]]).
solution([Move|MovesTail], [Start,End|Tail]) :-
  move(Move,Start,End),
  not(bad(End)),
  solution(MovesTail,[End|Tail]).