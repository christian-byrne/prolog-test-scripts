
/** intSeq(L, S, N, F): F is the sequence of ints from Start to N. */
intSeq(L, S, S, L).
intSeq(L, Start, N, NewL) :- 
  N > Start,
  N1 is N - 1, 
  intSeq([N | L],Start, N1,NewL).

legalList([], [], [], _, _).
legalList([R/C | T], Rows, Cols, DiagsP, DiagsS) :-
  member(R, Rows),
  member(C, Cols),
  PD is R - C,
  SD is R + C,
  member(PD, DiagsP),
  member(SD, DiagsS),
  select(R, Rows, NewRows),
  select(C, Cols, NewCols),
  select(PD, DiagsP, NewPDiags),
  select(SD, DiagsS, NewSDiags),
  legalList(T, NewRows, NewCols, NewPDiags, NewSDiags).

placement(L, N) :-
    length(L, N),
    NMinus1 is N - 1,
    NegN is 0 - N,
    TwoN is N * 2,
    intSeq([], 0, N, Seq),
    intSeq([], NegN, NMinus1, PrimaryDiags),
    intSeq([], 0, TwoN, SecondaryDiags), 
    legalList(L, Seq, Seq, PrimaryDiags, SecondaryDiags).

:- begin_tests(nQueens_tests_n_less_than_8).

% 2x2: has no solutions
test(two_board, [fail]) :- placement(_, 2).

% 3x3: has no solutions
test(three_board, [fail]) :- placement(_, 3).

% 4x4: has all 2 valid solutions 
test(four_board, [true(subset([
  [1/2, 2/4, 3/1, 4/3], [1/3, 2/1, 3/4, 4/2]], SolutionList))]) :-
  findall(Solution, placement(Solution, 4), SolutionList).

% 5x5: has all 10 valid solutions
sortAllSubLists([], []).
sortAllSubLists([H|T], [SH|ST]) :- sort(H, SH), sortAllSubLists(T, ST).
test(five_board) :-
  AllSolutions = [
    [1/1, 2/3, 3/5, 4/2, 5/4], [1/1, 2/4, 3/2, 4/5, 5/3],
    [1/2, 2/4, 3/1, 4/3, 5/5], [1/2, 2/5, 3/3, 4/1, 5/4],
    [1/3, 2/1, 3/4, 4/2, 5/5], [1/3, 2/5, 3/2, 4/4, 5/1],
    [1/4, 2/1, 3/3, 4/5, 5/2], [1/4, 2/2, 3/5, 4/3, 5/1],
    [1/5, 2/2, 3/4, 4/1, 5/3], [1/5, 2/3, 3/1, 4/4, 5/2]
  ],
  findall(Solution, placement(Solution, 5), SolutionList),
  sortAllSubLists(AllSolutions, AllSolutionsSorted),
  sortAllSubLists(SolutionList, SolutionListSorted),
  forall(member(S, AllSolutionsSorted), member(S, SolutionListSorted)).

:- end_tests(nQueens_tests_n_less_than_8).

:- begin_tests(nQueens_tests_n_geq_8).

% 8x8 board: valid solutions included
test(eight_board1, [true]):- placement([1/1, 2/5, 3/8, 4/6, 5/3, 6/7, 7/2, 8/4], 8), !.
test(eight_board2, [true]):- placement([1/1, 2/6, 3/8, 4/3, 5/7, 6/4, 7/2, 8/5], 8), !.
test(eight_board3, [true]):- placement([1/1, 2/7, 3/4, 4/6, 5/8, 6/2, 7/5, 8/3], 8), !.

% 9x9: valid solutions included
test(nine_board1, [true]) :- placement([1/1,2/3,3/6,4/8,6/4,5/2,9/5,7/9,8/7], 9), !.
test(nine_board2, [true]) :- placement([1/2,2/4,3/1,4/7,5/9,6/6,7/3,8/5,9/8], 9), !.
test(nine_board3, [true]) :- placement([1/3,2/1,3/4,4/7,5/9,6/2,7/5,8/8,9/6], 9), !.
test(nine_board4, [true]) :- placement([1/3,3/4,2/1,4/7,5/9,6/2,7/5,8/8,9/6], 9), !.

% 10x10: valid solutions included
test(ten_board1, [true]) :- placement([1/1,2/3,3/6,4/8,5/10,6/5,7/9,8/2,9/4,10/7], 10), !.
test(ten_board3, [true]) :- placement([1/2,2/4,3/6,4/8,5/10,6/1,7/3,8/5,9/7,10/9], 10), !.
test(ten_board2, [true]) :- placement([1/3,2/1,3/6,4/9,5/5,6/10,7/8,8/4,9/2,10/7], 10), !.
test(ten_board4, [true]) :- placement([1/4,2/1,3/5,4/8,5/10,6/3,7/7,8/9,9/2,10/6], 10), !.

% 12x12: valid solutions included
test(twleve_board1, [true]) :- 
  placement([1/1,2/3,3/6,4/8,5/11,6/5,7/12,8/10,9/4,10/7,11/9,12/2], 12), !.
test(twelve_board3, [true]) :- 
  placement([1/3,2/1,4/9,3/6,5/12,6/10,7/4,8/2,9/5,10/8,11/11,12/7], 12), !.

:- end_tests(nQueens_tests_n_geq_8).