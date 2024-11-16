
/* -------------------------------------------------------------------------- */
/*                             The Sodoku Problem                             */
/* -------------------------------------------------------------------------- */

% (1) Define domain of indices: D^2 = {1, 2, 3, 4}^2.     
domain(1).
domain(2).
domain(3).
domain(4).
domainSquared(I, J) :- domain(I), domain(J).

% (2) Assert all elements of D^2 are in the grid: ¬∃(i,j ∈ D)(¬(i/j ∈ X))
allDomainObjectsIn(MatrixTerms) :- \+ (domainSquared(I, J), \+ (member(I/J, MatrixTerms))).

% (3) Predicate for set of subgrid index sets: ∀p,q ∈ {0, 1},{i/j ∣ i ∈ {2p+1, 2p+2}, j ∈ {2j+1, 2j+2}},
%     row index sets, and column index sets.  
subgridOffset(0).
subgridOffset(1).
subgridDomain(Offset, X1, X2):- X1 is Offset*2 + 1, X2 is Offset*2 + 2.
subgridDomainSquared([I1/J1, I1/J2, I2/J1, I2/J2]) :- 
  subgridOffset(Offset1),
  subgridOffset(Offset2),
  subgridDomain(Offset1, I1, I2),
  subgridDomain(Offset2, J1, J2).
rows(Row, Index):- Index = Row/1 ; Index = Row/2 ; Index = Row/3 ; Index = Row/4.
cols(Col, Index):- Index = 1/Col ; Index = 2/Col ; Index = 3/Col ; Index = 4/Col.

% (5) For all sets of subgrid, row, col indices: 
%     Assert that ∃x(x ∈ PlacementIndices ∧ x ∈ Subgrid/Row/Col Indices)
isInEachSubgrid(PlacementIndices) :-
  \+ (subgridDomainSquared(Subgrid), \+ (member(Placement, PlacementIndices), member(Placement, Subgrid))).
numbersInEachSubgrid([]).
numbersInEachSubgrid([H | T]) :- isInEachSubgrid(H), numbersInEachSubgrid(T).

concatLists([], []).
concatLists([SubList | Lists], Concatenated) :-
  concatList(SubList, ConcatenatedTail, Concatenated),
  concatLists(Lists, ConcatenatedTail).

allLength4([]).
allLength4([H | T]) :- length(H, 4), allLength4(T).

all_starts_present(List, Seen) :-
    has_start(1, List, Seen),
    has_start(2, List, Seen),
    has_start(3, List, Seen),
    has_start(4, List, Seen).

all_ends_present(List, Seen) :-
    has_end(1, List, Seen),
    has_end(2, List, Seen),
    has_end(3, List, Seen),
    has_end(4, List, Seen).

has_end(End, List, Seen) :-
    member(X/End, List), 
    not(member(X/End, Seen)).

has_start(Start, List, Seen) :-
    member(Start/X, List), 
    not(member(Start/X, Seen)).

hasAll([], _).
hasAll([H | T], Seen) :-
  all_starts_present(H, Seen),
  all_ends_present(H, Seen),
  hasAll(T, [H | Seen]).

fullPlacement([[1/1, 2/3, 3/4, 4/2], [1/3, 2/2, 3/1, 4/4], [1/4, 2/1, 3/2, 4/3], [1/2, 2/4, 3/3, 4/1]]).
fullPlacement(Matrix) :-
  allLength4(Matrix),
  hasAll(Matrix, []),
  numbersInEachSubgrid(Matrix),
  concatLists(Matrix, Flattened),
  allDomainObjectsIn(Flattened), !.
