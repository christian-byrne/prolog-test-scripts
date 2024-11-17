% input : a list of items with weights and values
% Threshold for the value V: total value >= V
% Capacity of the knapsack: total weight <= C
% Output: a list of items L
% -- value of L >= V, weight of L <= C, subset of pantry

pantry([item(apple,2,200), item(bread,1,100),
item(peanuts,3,400),item(walnuts,4,500),item(lettuce,2,200),
item(cookies,4,250),item(pasta,2,250),item(cucumber,3,150)]).

solution(Pantry, Capacity, Threshold, Knapsack) :-
  pantry(Pantry),
  subset(Knapsack,Pantry),
  totalWeight(Knapsack,TW),
  TW =< Capacity,
  totalValue(Knapsack,TV),
  TV >= Threshold.

totalWeight([],0).
totalWeight([item(_,W,_)|T],TW) :- 
  totalWeight(T,TailW), 
  TW is W + TailW.

totalValue([],0).
totalValue([item(_,_,V)|T],TV) :- 
  totalValue(T,TailV), 
  TV is V + TailV.

subset([],_).
subset([H|Tail1],S) :- 
  member(H,S), 
  select(H,S,S1), 
  subset(Tail1,S1).

friendGroup(1,[_]).
friendGroup(N,[H|T]) :- 
  length([H|T],N), N > 1, 
  friendsWithAll(H,T), 
  N1 is N-1, 
  friendGroup(N1,T).

friendsWithAll(_,[]).
friendsWithAll(X,[Y|T]) :- 
  friends(X,Y), 
  friendsWithAll(X,T). 