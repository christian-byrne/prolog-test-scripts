% manager(X,Y) means "X is the manager of Y"
% manager(alice, bob).
% manager(alice, carla).
% manager(alice, dave).
% manager(alice, elsa).
% manager(alice, frank).
% manager(bob, george).
% manager(bob, harry).
% manager(bob, inez).
% manager(bob, juan).
% manager(bob, kevin).
% manager(george, keeley).
% manager(inez, leon).
% manager(leon, manuel).
% manager(juan, nancy).
% manager(nancy, ophelia).
% manager(ophelia, parker).
% manager(kevin, quincey).
% manager(quincey, ray).
% manager(dave, stephen).
% manager(dave, tracy).
% manager(tracy, violet).
% manager(stephen, whitney).
% manager(stephen, xavier).
% manager(whitney, angelica).
% manager(violet, zeke).
% manager(violet, betty).
% manager(violet, candace).
% manager(violet, donna).
% manager(elsa, eddie).
% manager(eddie, francine).
% manager(eddie, ginny).
% manager(eddie, hans).
% manager(ginny, iris).
% manager(hans, jack).

/**
 * Test Cases LA2
 * 
 * Usage: 
 *  ```shell
 *  swipl -g run_tests -t halt tests.pl
 *  ```
 * 
 * Note:
 *  Overly complicated in some cases just to allow printing of expected vs. 
 *  actual values.
 */


:- consult(la2).


/* -------------------------------------------------------------------------- */
/*                                  teammate                                  */
/* -------------------------------------------------------------------------- */

:- begin_tests(teammate).

% sample queries from project spec

test(teammates_of_juan, [true(Result == SortedExpected)]) :-
    setof(X, teammate(juan, X), Result),
    msort(Result, SortedExpected),
    msort([george, harry, inez, kevin], SortedExpected).

test(leon_has_no_teammates, [fail]) :-
    teammate(_, leon).

test(includes_example_pairs, [true(subset([bob-carla, bob-dave, bob-elsa], Result))]) :-
    findall(X-Y, teammate(X, Y), Result).

% edge cases 

test(teammate_is_symmetric, [true]) :-
    teammate(juan, george),
    teammate(george, juan).

test(teammate_is_not_reflexive, [fail]) :-
    teammate(juan, juan) ;
    teammate(george, george) ;
    teammate(kevin, kevin).

test(teammate_is_transitive, [true]) :-
    teammate(juan, kevin),
    teammate(kevin, george),
    teammate(juan, george).

:- end_tests(teammate).


/* -------------------------------------------------------------------------- */
/*                                 bossOfBoss                                 */
/* -------------------------------------------------------------------------- */

:- begin_tests(bossOfBoss).

% sample queries from project spec

test(bossOfBoss_bob_boss, [fail]) :-
  bossOfBoss(_, bob).

test(bossOfBoss_inez_boss, [true(Result = [alice])]) :-
  setof(X, bossOfBoss(X, inez), Result).

test(bossOfBoss_alice_workers, [true(SortedResult == SortedExpected)]) :-
  setof(X, bossOfBoss(alice, X), Result),
  msort(Result, SortedResult),
  msort([george, harry, inez, juan, kevin, stephen, tracy, eddie], SortedExpected).

test(bossOfBoss_pairs, [true(subset([alice-george, alice-harry, alice-inez, alice-juan], Result))]) :-
  findall(X-Y, bossOfBoss(X, Y), Result).

% edge cases

test(bossOfBoss_is_not_reflexive, [fail]) :-
  bossOfBoss(alice, alice) ;
  bossOfBoss(bob, bob) ;
  bossOfBoss(george, george).

:- end_tests(bossOfBoss).


/* -------------------------------------------------------------------------- */
/*                                  superior                                  */
/* -------------------------------------------------------------------------- */

:- begin_tests(superior).

% sample queries from project spec

test(superior_of_alice, [fail]) :-
  superior(_, alice).

test(superior_of_bob, [true(Result = [alice])]) :-
  setof(X, superior(X, bob), Result).

test(superior_of_eddie, [true(SortedResult == SortedExpected)]) :-
  setof(X, superior(X, eddie), Result),
  msort(Result, SortedResult),
  msort([elsa, alice], SortedExpected).

test(superior_eddie_subordinates, [true(SortedResult == SortedExpected)]) :-
  setof(X, superior(eddie, X), Result),
  msort(Result, SortedResult),
  msort([francine, ginny, hans, iris, jack], SortedExpected).

test(superior_pairs, [true(subset([alice-bob, alice-carla, alice-dave, alice-elsa, alice-frank], Result))]) :-
  findall(X-Y, superior(X, Y), Result).

% edge cases

test(superior_is_not_reflexive, [fail]) :-
  superior(alice, alice) ;
  superior(bob, bob) ;
  superior(george, george).

% test transitivity and if choice point is left after finding a superior

test(superior_leaves_choicepoint, [true]) :-
  superior(alice, keeley).

:- end_tests(superior).


/* -------------------------------------------------------------------------- */
/*                                  sameRank                                  */
/* -------------------------------------------------------------------------- */


:- begin_tests(sameRank).

% sample queries from project spec

test(sameRank_eddie, [true(subset([eddie, george, george, harry, harry], Result))]) :-
  findall(X, sameRank(eddie, X), Result).

test(sameRank_bob, [true(subset([bob, carla, dave, elsa, frank], Result))]) :-
  findall(X, sameRank(bob, X), Result).

test(sameRank_pairs, [true(subset([bob-carla, bob-dave, bob-elsa], Result))]) :-
  findall(X-Y, sameRank(X, Y), Result).


% exhaustive tests

% Hardcoded tiers from company data
tier0(alice).

tier1(bob).
tier1(carla).
tier1(dave).
tier1(elsa).
tier1(frank).

tier2(george).
tier2(harry).
tier2(inez).
tier2(juan).
tier2(kevin).
tier2(stephen).
tier2(tracy).
tier2(eddie).

tier3(keeley).
tier3(leon).
tier3(nancy).
tier3(quincey).
tier3(whitney).
tier3(xavier).
tier3(violet).
tier3(francine).
tier3(ginny).
tier3(hans).

tier4(manuel).
tier4(ophelia).
tier4(ray).
tier4(angelica).
tier4(zeke).
tier4(betty).
tier4(candace).
tier4(donna).
tier4(iris).
tier4(jack).

tier5(parker).

% Define a testing version of sameRank that uses the hardcoded tier predicates directly
sameRankTesting(X, Y) :-
    (tier0(X), tier0(Y)) ;
    (tier1(X), tier1(Y)) ;
    (tier2(X), tier2(Y)) ;
    (tier3(X), tier3(Y)) ;
    (tier4(X), tier4(Y)) ;
    (tier5(X), tier5(Y)).

test(sameRank_equivalence) :-
    % Collect all pairs generated by sameRank/2
    findall(X-Y, sameRank(X, Y), SameRankPairs),
    
    % Collect all pairs generated by sameRankTesting/2
    findall(X-Y, sameRankTesting(X, Y), TestingPairs),
    
    % Check that both lists contain the same pairs
    sort(SameRankPairs, SortedSameRankPairs),
    sort(TestingPairs, SortedTestingPairs),
    assertion(SortedSameRankPairs == SortedTestingPairs).

% edge cases

test(sameRank_is_reflexive, [true]) :-
  sameRank(alice, alice),
  sameRank(bob, bob),
  sameRank(george, george).

% NOTE: most likely this isnt a case that's required to be handled
% test if it works when there are multiple root nodes
% manager(alice_clone, bob).
% test(sameRank_leon, [true(subset([nancy, violet], Result))]) :-
%   findall(X, sameRank(bob, X), Result).

:- end_tests(sameRank).


/* -------------------------------------------------------------------------- */
/*                               chainOfCommand                               */
/* -------------------------------------------------------------------------- */

:- begin_tests(chainOfCommand).

% sample queries from project spec

test(chainOfCommand_alice, [true(subset([[alice, bob], [alice, bob, george], [alice, bob, george, keeley], [alice, bob, harry], [alice, bob, inez]], Result))]) :-
  findall(X, chainOfCommand(X), Result).

% The spec shows the base case as `chainOfCommand([_])`, indicating any 
% single-item path is valid. Test to assert the implemention doesn't only 
% return traversals with the root as the first item.
test(chainOfCommand_all_single_item_lists_work, [true]) :-
  chainOfCommand([bob]),
  chainOfCommand([george]),
  chainOfCommand([keeley]),
  chainOfCommand([harry]),
  chainOfCommand([inez]),
  chainOfCommand([leon]).

:- end_tests(chainOfCommand).

/* -------------------------------------------------------------------------- */
/*                                    merge                                   */
/* -------------------------------------------------------------------------- */

:- begin_tests(merge).

% sample queries from project spec

test(merge_alternating_lists, [true(Result == [1, 2, 3, 4, 5, 6, 8])]) :-
  merge([1, 3, 5], [2, 4, 6, 8], Result).

% edge cases

test(merge_longer_list, [true(Result == [1, 2, 3, 4, 5, 6, 8])]) :-
  merge([1, 3, 5, 8], [2, 4, 6], Result).

test(merge_shorter_list, [true(Result == [1, 2, 3, 4, 5, 6, 8])]) :-
  merge([1, 3, 5], [2, 4, 6, 8], Result).

test(merge_empty_lists, [true(Result == [])]) :-
  merge([], [], Result).

test(merge_empty_and_nonempty_lists, [true(Result == [1, 2, 3])]) :-
  merge([], [1, 2, 3], Result).

test(merge_nonempty_and_empty_lists, [true(Result == [1, 2, 3])]) :-
  merge([1, 2, 3], [], Result).

test(merge_two_nonempty_lists, [true(Result == [1, 2, 3, 4, 5, 6])]) :-
  merge([1, 3, 5], [2, 4, 6], Result).

test(merge_singleton_with_nonempty_list, [true(Result == [1, 2, 3, 5])]) :-
  merge([1, 3, 5], [2], Result).

test(merge_two_nonempty_lists_with_duplicates, [true(Result == [1, 1, 2, 2, 3, 3])]) :-
  merge([1, 2, 3], [1, 2, 3], Result).

test(merge_homogenous_lists, [true(Result == [1, 1, 1, 1, 1, 1])]) :-
  merge([1, 1, 1], [1, 1, 1], Result).

test(merge_nonequal_homogenous_lists, [true(Result == [1, 1, 1, 9, 9])]) :-
  merge([1, 1, 1], [9, 9], Result).

:- end_tests(merge).


/* -------------------------------------------------------------------------- */
/*                                   repeat                                   */
/* -------------------------------------------------------------------------- */

% NOTE: rename `repeat` predicate to `repeatN` in order to test it
% (`repeat` is shadowed by built-in `repeat/0` predicate)

:- begin_tests(repeat).

% sample queries from project spec

test(repeat_123_once, [true(Result == [1, 2, 3])]) :-
  repeatN([1, 2, 3], 1, Result).

test(repeat_123_twice, [true(Result == [1, 2, 3, 1, 2, 3])]) :-
  repeatN([1, 2, 3], 2, Result).

test(repeat_123_thrice, [true(Result == [1, 2, 3, 1, 2, 3, 1, 2, 3])]) :-
  repeatN([1, 2, 3], 3, Result).

test(repeat_123_four_times, [true(Result == [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3])]) :-
  repeatN([1, 2, 3], 4, Result).

test(repeat_x_to_123123, [true(Result == [1, 2, 3])]) :-
  repeatN(Result, 2, [1,2,3,1,2,3]).

% edge cases

test(repeat_empty_list_0_times, [true(Result == [])]) :-
  repeatN([], 0, Result).

test(repeat_empty_list_1_time, [true(Result == [])]) :-
  repeatN([], 1, Result).

test(repeat_empty_list, [true(Result == [])]) :-
  repeatN([], 5, Result).

test(repeatN_0_is_empty_list, [true(Result == [])]) :-
  repeatN(_, 0, Result).

test(repeatN_1_is_reflexive, [true(Result == [a])]) :-
  repeatN([a], 1, Result).

test(repeatN_2_is_doubled, [true(Result == [a, a])]) :-
  repeatN([a], 2, Result).

test(repeatN_3_is_tripled, [true(Result == [a, a, a])]) :-
  repeatN([a], 3, Result).

test(repeatN_4_is_quadrupled, [true(Result == [a, a, a, a])]) :-
  repeatN([a], 4, Result).

test(repeatN_5_is_quintupled, [true(Result == [a, a, a, a, a])]) :-
  repeatN([a], 5, Result).

:- end_tests(repeat).


/* -------------------------------------------------------------------------- */
/*                                   sublist                                  */
/* -------------------------------------------------------------------------- */

:- begin_tests(sublist).

% sample queries from project spec

test(sublist_34_at_indices_2to4, [true(Result == [3, 4])]) :-
  sublist([1, 2, 3, 4, 5, 6], 2, 4, Result).

test(sublist_X_has_sublist_123_at_indices_0to3, [true(subset([1, 2, 3], Result))]) :-
  sublist(Result, 0, 3, [1, 2, 3]).

% edge cases

test(sublist_empty_list, [true(Result == [])]) :-
  sublist([], 0, 0, Result).

:- end_tests(sublist).

/* -------------------------------------------------------------------------- */
/*                                   insert                                   */
/* -------------------------------------------------------------------------- */

% NOTE: rename `insert` predicate to `insert_` in order to test it
% (`insert` is shadowed by built-in `insert/3` predicate)

:- begin_tests(insert).

% sample queries from project spec

test(insertN_3_in_empty_list, [true(Result == [3])]) :-
  insertN(3, [], Result).

test(insertN_3_into_0246list, [true(Result == [0, 2, 3, 4, 6])]) :-
  insertN(3, [0, 2, 4, 6], Result).

test(insertN_8_into_12388list, [true(Result == [1, 2, 3, 8, 8, 8])]) :-
  insertN(8, [1, 2, 3, 8, 8], Result).

% edge cases

test(insertN_into_empty_list, [true(Result == [1])]) :-
  insertN(1, [], Result).

test(insertN_into_singleton_list, [true(Result == [1, 2])]) :-
  insertN(2, [1], Result).

test(insertN_into_longer_list, [true(Result == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])]) :-
  insertN(5, [1, 2, 3, 4, 6, 7, 8, 9, 10], Result).

% Probably not a case that needs to be handled
% test(insertN_noninteger_constant, [true(Result == [1, 2, 3, a, 4, 5])]) :-
%   insertN(a, [1, 2, 3, 4, 5], Result).

:- end_tests(insert).

/* -------------------------------------------------------------------------- */
/*                                   sudoku                                   */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
/*                            traveling salesperson                           */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
/*                              k-clique problem                              */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
/*                           dominating set problem                           */
/* -------------------------------------------------------------------------- */