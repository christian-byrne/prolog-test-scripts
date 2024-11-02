% oppositeSides(X,Y) : X and Y are opposite sides
oppositeSides(e,w).
oppositeSides(w,e).

% bad(State) : State describes a bad state
bad([S,O,O,_]) :- oppositeSides(S,O).
bad([S,_,O,O]) :- oppositeSides(S,O).

% move(Item,Start,End) : Start is the start state, End is the end state when the Item is moved across the river

move(nothing,[M,W,G,C],[O,W,G,C]) :- oppositeSides(M,O).
move(wolf,[M,M,G,C],[O,O,G,C]) :- oppositeSides(M,O).
move(goat,[M,W,M,C],[O,W,O,C]) :- oppositeSides(M,O).
move(cabbage,[M,W,G,M],[O,W,G,O]) :- oppositeSides(M,O).

% solution(Moves, States)
solution([],[[e,e,e,e]]).
solution([Move|MovesTail], [Start,End|Tail]) :-
move(Move,Start,End),
not(bad(End)),
solution(MovesTail,[End|Tail]).

