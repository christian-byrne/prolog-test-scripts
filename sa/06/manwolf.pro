% Man Wolf Cabbage
% oppositeSides(X, Y): X and Y are opposite sides
oppositeSides(e, w).
oppositeSides(w, e).

% bad(State): State is a bad state
bad([S,O,O,_]) :- oppositeSides(S,O).
bad([S,_,O,O]) :- oppositeSides(S,O).

% move(State1, State2): State1 can move to State2
move(nothing, [M,W,G,C], [O,W,G,C]) :- oppositeSides(M,O).
move(wolf,[M,M,G,C], [O,O,G,C]) :- oppositeSides(M,O).
move(goat,[M,W,M,C], [O,W,O,C]) :- oppositeSides(M,O).
move(cabbage,[M,W,G,M], [O,W,G,O]) :- oppositeSides(M,O).
