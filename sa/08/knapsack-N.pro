% solution([item(apple,2,200), item(bread,1,100),item(peanuts,3,400),item(walnuts,4,500),item(lettuce,2,200),item(cookies,4,250),item(pasta,2,250),item(cucumber,3,150)], 8, 500, S).

% solution([item(one, 1, 1),  item(two, 2, 2),  item(three, 3, 3),item(four, 4, 4), item(five, 5, 5), item(six, 6, 6)], 4, 4, S).

/** 
 * solution(D, C, T, K): K is a set of items from D whose total weight is at 
 *                       most C and total value is at least T. 
 */
solution(Pantry, Capacity, Threshold, Knapsack) :-
  isSolution(Pantry, Capacity, Threshold, [], Knapsack).

isSolution(_, Capacity, Threshold, K, K) :- Capacity >= 0, Threshold =< 0.
isSolution(Domain, Capacity, Threshold, Knapsack, NewKnapsack) :-
  member(item(Item, W, V), Domain),
  NewC is Capacity - W,
  NewC >= 0,
  NewT is Threshold - V,
  isSolution(Domain, NewC, NewT, [item(Item, W, V) | Knapsack], NewKnapsack).


:- begin_tests(knapsackN_pantry_tests).

pantry([
  item(apple,2,200),   item(bread,1,100),   item(peanuts,3,400),
  item(walnuts,4,500), item(lettuce,2,200), item(cookies,4,250),
  item(pasta,2,250),   item(cucumber,3,150)
]).

% Weight 3, Value 400 -> {(peanuts)}
test(weight3_value400) :-
    Expected = [[item(peanuts,3,400)]],
    pantry(P), findall(K, solution(P, 3, 400, K), KList),
    forall(member(K, KList), member(K, Expected)).

% Weight 4, Value 500 -> {(peanuts, bread), (walnuts), (pasta, pasta)}
test(weight4_value500) :-
    Expected = [
        [item(peanuts,3,400), item(bread,1,100)],
        [item(bread,1,100), item(peanuts,3,400)],
        [item(walnuts,4,500)],
        [item(pasta,2,250), item(pasta,2,250)]
    ],
    pantry(P), findall(K, solution(P, 4, 500, K), KList),
    forall(member(K, KList), member(K, Expected)).

% Weight 2, Value 200 -> {(apple), (lettuce), (pasta) or (bread, bread)}
test(weight2_value200) :-
    Expected = [
        [item(apple,2,200)], 
        [item(lettuce,2,200)], 
        [item(pasta,2,250)],
        [item(bread,1,100), item(bread,1,100)]
    ],
    pantry(P), findall(K, solution(P, 2, 200, K), KList),
    forall(member(K, KList), member(K, Expected)).

% Weight 1, Value 200 -> false
test(weight1_value200, [fail]) :- pantry(P), solution(P, 1, 200, _).

% Weight 8, Value 2000 -> false
test(pantry_weight8_value2000, [fail]) :- pantry(P), solution(P, 8, 2000, _).

% Weight 0, Value 0 -> {}
test(weight0_value0, [true(K == [])]) :- pantry(P), solution(P, 0, 0, K), !.

% Can repeat items
test(weight2_value200_2bread, [true]) :-
  pantry(P), Bread = item(bread, 1, 100),
  solution(P, 2, 200, [Bread, Bread]), !.

% Allows redundant items
redundantItems([item(a, 1, 50), item(b, 1, 50)]).
test(redudancy, [true]) :-
    redundantItems(RedundantItems),
    solution(RedundantItems, 2, 100, [item(a, 1, 50), item(a, 1, 50)]), !,
    solution(RedundantItems, 2, 100, [item(b, 1, 50), item(b, 1, 50)]), !,
    solution(RedundantItems, 2, 100, [item(a, 1, 50), item(b, 1, 50)]), !,
    solution(RedundantItems, 2, 100, [item(b, 1, 50), item(a, 1, 50)]), !.

:- end_tests(knapsackN_pantry_tests).


:- begin_tests(knapsackN_dice_tests).

dice([
    item(one, 1, 1),  item(two, 2, 2),  item(three, 3, 3),
    item(four, 4, 4), item(five, 5, 5), item(six, 6, 6)
]).

% 0 -> {}
test(dice_totaling_zero, [true(K == [])]) :- dice(D), solution(D, 0, 0, K), !.

% 1 -> {(1)}
test(dice_totaling_one, [true(K == [item(one, 1, 1)])]) :- 
  dice(D), solution(D, 1, 1, K), !.

% 2 -> {(1, 1), (2)}
test(dice_totaling_two) :-
    Expected = [
        [item(one, 1, 1), item(one, 1, 1)],
        [item(two, 2, 2)]
    ],
    dice(D), findall(K, solution(D, 2, 2, K), KList),
    length(KList, 2), forall(member(K, KList), member(K, Expected)).

% 3 -> {(1, 1, 1), (1, 2), (2, 1), (3)}
test(dice_totaling_three) :-
    Expected = [
        [item(one, 1, 1), item(one, 1, 1), item(one, 1, 1)],
        [item(one, 1, 1), item(two, 2, 2)],
        [item(two, 2, 2), item(one, 1, 1)],
        [item(three, 3, 3)]
    ],
    dice(D), findall(K, solution(D, 3, 3, K), KList),
    length(KList, 4), forall(member(K, KList), member(K, Expected)).

% 4 -> {(1, 1, 1, 1), (1, 1, 2), (1, 2, 1), (2, 1, 1), (1, 3), (3, 1), (2, 2), (4)}
test(dice_totaling_four) :-
    Expected = [
        [item(one, 1, 1), item(one, 1, 1), item(one, 1, 1), item(one, 1, 1)],
        [item(one, 1, 1), item(one, 1, 1), item(two, 2, 2)],
        [item(one, 1, 1), item(two, 2, 2), item(one, 1, 1)],
        [item(two, 2, 2), item(one, 1, 1), item(one, 1, 1)],
        [item(one, 1, 1), item(three, 3, 3)],
        [item(three, 3, 3), item(one, 1, 1)],
        [item(two, 2, 2), item(two, 2, 2)],
        [item(four, 4, 4)]
    ],
    dice(D),
    findall(K, solution(D, 4, 4, K), KList),
    length(KList, 8),
    forall(member(K, KList), member(K, Expected)).

:- end_tests(knapsackN_dice_tests).
