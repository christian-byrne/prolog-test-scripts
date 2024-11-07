% Logical NOT (using Prolog's built-in negation as failure)
not(P) :- \+ P.

% Logical OR
or(P, _) :- P.
or(_, Q) :- Q.

% Logical AND
and(P, Q) :- P, Q.

% Logical implication (P -> Q)
implies(P, Q) :-
    not(P);
    Q.

% Logical equivalence (P <-> Q)
equivalent(P, Q) :-
    implies(P, Q),
    implies(Q, P).

% Logical XOR
xor(P, Q) :-
    or(P, Q),
    not(and(P, Q)).

% Logical NAND
nand(P, Q) :-
    not(and(P, Q)).

% Logical NOR
nor(P, Q) :-
    not(or(P, Q)).

% Logical XNOR
xnor(P, Q) :-
    not(xor(P, Q)).

% DERIVED RULES

% DeMorgan's Laws

% not(P and Q) is equivalent to (not P) or (not Q)
% demorgan1(P, Q) :-
%     equivalent(not(and(P, Q)), or(not(P), not(Q))).

% not(P or Q) is equivalent to (not P) and (not Q)
% demorgan2(P, Q) :-
%     equivalent(not(or(P, Q)), and(not(P), not(Q))).

% Double Negation
double_negation(P) :-
    equivalent(P, not(not(P))).

% Material Implication
material_implication(P, Q) :-
    equivalent(implies(P, Q), or(not(P), Q)).

% Material Equivalence
material_equivalence(P, Q) :-
    equivalent(equivalent(P, Q), and(implies(P, Q), implies(Q, P))).

% XOR as a combination of AND, OR, and NOT
xor2(P, Q) :-
    or(P, Q),
    not(and(P, Q)).

% NAND as a combination of AND and NOT
nand2(P, Q) :-
    not(and(P, Q)).


% Facts for propositions being true
true(p).
true(q).
false(r).

% A fact is false if it is not true
false(P) :- \+ true(P).
