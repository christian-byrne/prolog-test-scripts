

/* -------------------------------------------------------------------------- */
/*                              N-Queens Problem                              */
/* -------------------------------------------------------------------------- */

/* naturalSeqN(L, N, NewL): NewL is the sequence of natural nums 0 to N. */
naturalSeqN(L, 0, L).
naturalSeqN(L, N, NewL) :- N > 0, N1 is N - 1, naturalSeqN([N | L],N1,NewL).

/* asIndices(L1, L2): L2 is a list of pairs of the form X/_ where X ∈ L1. */
asIndices([], []).
asIndices([H1 | T1], [H1/_ | T2]) :- asIndices(T1, T2).

inBoard(R/C, N) :- 
  naturalSeqN([], N, L),
  member(R,L),
  member(C,L). 

legalPair(R1/C1, R2/C2, N) :-
  inBoard(R1/C1, N),
  inBoard(R2/C2, N),
  DR is R1 - R2,
  not(DR = 0),
  DC is C1 - C2,
  not(DC = 0),
  S is DR/DC,
  not(S = 1),
  not(S = -1).

legalLoc(_,[], _).
legalLoc(P,[X|T],N) :-
  legalPair(P,X,N),
  legalLoc(P,T,N).

legalList([],_).
legalList([P|Tail],N) :- legalLoc(P,Tail,N), legalList(Tail,N).

/* placement(X, N): X is a list of valid positions on an NxN board. */
placement(X, N) :- naturalSeqN([], N, Seq), asIndices(Seq, X), legalList(X,N).


:- begin_tests(nQueens_tests).

% 2x2: has no solutions
test(two_board, [fail]) :-
  placement(_, 2).

% 3x3: has no solutions
test(three_board, [fail]) :-
  placement(_, 3).

% 4x4: has all 2 valid solutions 
test(four_board, [true(subset(SolutionList, [[1/2, 2/4, 3/1, 4/3], [1/3, 2/1, 3/4, 4/2]]))]) :-
  findall(Solution, placement(Solution, 4), SolutionList).

% 5x5: has all 10 valid solutions
test(five_board) :-
  AllSolutions = [
    [1/1, 2/3, 3/5, 4/2, 5/4],
    [1/1, 2/4, 3/2, 4/5, 5/3],
    [1/2, 2/4, 3/1, 4/3, 5/5],
    [1/2, 2/5, 3/3, 4/1, 5/4],
    [1/3, 2/1, 3/4, 4/2, 5/5],
    [1/3, 2/5, 3/2, 4/4, 5/1],
    [1/4, 2/1, 3/3, 4/5, 5/2],
    [1/4, 2/2, 3/5, 4/3, 5/1],
    [1/5, 2/2, 3/4, 4/1, 5/3],
    [1/5, 2/3, 3/1, 4/4, 5/2]
  ],
  findall(Solution, placement(Solution, 5), SolutionList),
  length(SolutionList, 10),
  forall(member(Solution, SolutionList), member(Solution, AllSolutions)).

% % 8x8: includes 92 solutions
% test(eight_board, [true(length(SolutionList, 92))]) :-
%   findall(Solution, placement(Solution, 8), SolutionList).
% % 8x8: solutions have valid form
% test(eight_board, [true(subset(Solution, [[1/_, 2/_, 3/_, 4/_, 5/_, 6/_, 7/_, 8/_]]))]) :-
%   placement(Solution, 8).
% % 8x8 board: valid solutions included
% test(eight_board, [true]):- placement([1/1, 2/5, 3/8, 4/6, 5/3, 6/7, 7/2, 8/4], 8).
% test(eight_board, [true]):- placement([1/1, 2/6, 3/8, 4/3, 5/7, 6/4, 7/2, 8/5], 8).
% test(eight_board, [true]):- placement([1/1, 2/7, 3/4, 4/6, 5/8, 6/2, 7/5, 8/3], 8).

% 9x9: includes subset of valid solutions


% 10x10: includes 724 solutions
% test(ten_board, [true(length(SolutionList, 724))]) :-
%   findall(Solution, placement(Solution, 10), SolutionList).


:- end_tests(nQueens_tests).