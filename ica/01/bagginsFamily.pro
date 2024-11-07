% parent facts
parent(balbo, mungo).
parent(balbo, pansy).
parent(balbo, ponto).
parent(balbo, largo).
parent(balbo, lily).
parent(berylla, mungo).
parent(berylla, pansy).
parent(berylla, ponto).
parent(berylla, largo).
parent(berylla, lily).
parent(mungo, bungo).
parent(mungo, belba).
parent(mungo, longo).
parent(mungo, linda).
parent(mungo, bingo).
parent(laura, bungo).
parent(laura, belba).
parent(laura, longo).
parent(laura, linda).
parent(laura, bingo).
parent(bungo, bilbo).
parent(belladonna, bilbo).
parent(longo, otho).
parent(camellia, otho).
parent(otho, lotho).
parent(lobelia, lotho).
parent(linda, odo).
parent(bodo, odo).
parent(odo, olo).
parent(olo, sancho).
parent(bingo, falco).
parent(chica, falco).
parent(falco, poppy).
parent(ponto, rosa).
parent(ponto, polo).
parent(mimosa, rosa).
parent(mimosa, polo).
parent(polo, posco).
parent(polo, prisca).
parent(posco, ponto2).
parent(posco, porto).
parent(posco, peony).
parent(gilly, ponto2).
parent(gilly, porto).
parent(gilly, peony).
parent(ponto2, angelica).
parent(peony, mosco).
parent(peony, moro).
parent(peony, myrtle).
parent(peony, minto).
parent(milo, mosco).
parent(milo, moro).
parent(milo, myrtle).
parent(milo, minto).
parent(largo, fosco).
parent(tanta, fosco).
parent(fosco, dora).
parent(fosco, drogo).
parent(fosco, dudo).
parent(ruby, dora).
parent(ruby, drogo).
parent(ruby, dudo).
parent(drogo, frodo).
parent(primula, frodo).
parent(dudo, daisy).

%male facts
male(mungo).
male(balbo).
male(fastolph).
male(ponto).
male(largo).
male(togo).
male(bungo).
male(rudigar).
male(longo).
male(bodo).
male(bingo).
male(hildigrim).
male(bilbo).
male(otho).
male(lotho).
male(odo).
male(olo).
male(sancho).
male(falco).
male(polo).
male(posco).
male(ponto2).
male(porto).
male(mosco).
male(moro).
male(minto).
male(milo).
male(fosco).
male(drogo).
male(dudo).
male(frodo).
male(griffo).

%married facts
married(balbo,berylla).
married(mungo,laura).
married(pansy,fastolph).
married(ponto,mimosa).
married(largo,tanta).
married(lily,togo).
married(bungo,beladonna).
married(belba,rudigar).
married(longo,camellia).
married(linda,bodo).
married(bingo,chica).
married(rosa,hildigrim).
married(fosco,ruby).
married(otho,lobelia).
married(posco,gilly).
married(prisca,wilibald).
married(primula,drogo).
married(filibert,poppy).
married(peony,milo).
married(griffo,daisy).

/* -------------------------------------------------------------------------- */
/*                                 predicates                                 */
/* -------------------------------------------------------------------------- */

spouse(Husband, Wife) :-
    married(Husband, Wife);
    married(Wife, Husband).

grandDaughter(Gd, Gp) :-
    \+ male(Gd),           % Check that GrandDaughter is not male
    parent(P, Gd),    % Find the parent of the GrandDaughter
    parent(Gp, P).      % Find the grandparent of the Parent


% Tests for grandDaughter
% grandDaughter(berylla, rosa). % true
% grandDaughter(daisy, ruby). % true
% grandDaughter(lily, mungo). % false

brother(X, Y) :-
  parent(P, X),
  parent(P, Y).

% Tests for brother
% brother(drogo, dudo). % true
% brother(dudo, drogo). % true
% brother(daisy, frodo). % false

sibling(X, Y) :-
  parent(P, X),
  parent(P, Y),
  X \= Y.

% X is the nibling (niece or nephew) of Y
nibling(X, Y) :-
  parent(P, X),
  parent(Gp, Y),
  parent(Gp, P).

% X is the first cousin of Y
cousin(X, Y) :-
  parent(P1, X),
  parent(P2, Y),
  sibling(P1, P2).

% X is the sister of Y
sister(X, Y) :-
  sibling(X, Y),
  \+ male(X).

% X is the sister-in-law of Y
sisterInLaw(X, Y) :-
  spouse(Y, Z),
  sister(X, Z).

% X is the father-in-law of Y
fatherInLaw(X, Y) :-
  spouse(Y, Z),
  parent(X, Z),
  male(X).

% X is the great aunt of Y
greatAunt(X, Y) :-
  grandDaughter(Y, Gp),
  sister(Gp, X).

% X is the secondCousin of Y
secondCousin(X, Y) :-
  parent(P1, X),
  parent(P2, Y),
  cousin(P1, P2).

% X is the descendant of Y
descendant(X, Y) :-
  parent(Y, X);
  parent(Z, X),
  descendant(Z, Y).

% X and Y are part of the same generation (i.e., the same level of the family tree)
depth(Person, Ancestor, Depth) :-
    parent(Ancestor, Person),
    Depth is 1.
depth(Person, Ancestor, Depth) :-
    parent(Parent, Person),
    depth(Parent, Ancestor, Depth1),
    Depth is Depth1 + 1.
 commonAncestor(X, Y, Ancestor) :-
    descendant(X, Ancestor),
    descendant(Y, Ancestor).
sameGeneration(X, Y) :-
    X = Y;
    spouse(X, Y);
    commonAncestor(X, Y, Ancestor),
    depth(X, Ancestor, DepthX),
    depth(Y, Ancestor, DepthY),
    DepthX =:= DepthY.


% REFERENCE: https://thainsbook.minastirith.cz/images/baggins-tree.gif

/* ----------------------- spouse - should return true ---------------------- */

:- (spouse(balbo, berylla) 
    -> format('Test passed: spouse(~w, ~w)\n', [balbo, berylla])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [balbo, berylla])).

:- (spouse(mungo, laura) 
    -> format('Test passed: spouse(~w, ~w)\n', [mungo, laura])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [mungo, laura])).

:- (spouse(largo, tanta) 
    -> format('Test passed: spouse(~w, ~w)\n', [largo, tanta])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [largo, tanta])).

% Reversed order
:- (spouse(berylla, balbo) 
    -> format('Test passed: spouse(~w, ~w)\n', [berylla, balbo])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [berylla, balbo])).

:- (spouse(laura, mungo) 
    -> format('Test passed: spouse(~w, ~w)\n', [laura, mungo])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [laura, mungo])).

:- (spouse(mimosa, ponto) 
    -> format('Test passed: spouse(~w, ~w)\n', [mimosa, ponto])
    ;  format('Test failed: spouse(~w, ~w) should return true\n', [mimosa, ponto])).

/* ---------------------- spouse - should return false) --------------------- */

:- (\+ spouse(balbo, laura) 
    -> format('Test passed: spouse(~w, ~w)\n', [balbo, laura])
    ;  format('Test failed: spouse(~w, ~w) should return false\n', [balbo, laura])).

:- (\+ spouse(mungo, pansy) 
    -> format('Test passed: spouse(~w, ~w)\n', [mungo, pansy])
    ;  format('Test failed: spouse(~w, ~w) should return false\n', [mungo, pansy])).

:- (\+ spouse(bingo, ruby) 
    -> format('Test passed: spouse(~w, ~w)\n', [bingo, ruby])
    ;  format('Test failed: spouse(~w, ~w) should return false\n', [bingo, ruby])).

/* --------------------- descendant - should return true -------------------- */

:- (descendant(frodo, balbo) 
    -> format('Test passed: descendant(~w, ~w)\n', [frodo, balbo])
    ;  format('Test failed: descendant(~w, ~w) should return true\n', [frodo, balbo])).

:- (descendant(bilbo, mungo) 
    -> format('Test passed: descendant(~w, ~w)\n', [bilbo, mungo])
    ;  format('Test failed: descendant(~w, ~w) should return true\n', [bilbo, mungo])).

:- (descendant(otho, longo) 
    -> format('Test passed: descendant(~w, ~w)\n', [otho, longo])
    ;  format('Test failed: descendant(~w, ~w) should return true\n', [otho, longo])).

:- (descendant(bilbo, laura) 
    -> format('Test passed: descendant(~w, ~w)\n', [bilbo, laura])
    ;  format('Test failed: descendant(~w, ~w) should return true\n', [bilbo, laura])).

:- (descendant(bilbo, mungo) 
    -> format('Test passed: descendant(~w, ~w)\n', [bilbo, mungo])
    ;  format('Test failed: descendant(~w, ~w) should return true\n', [bilbo, mungo])).

/* -------------------- descendant - should return false -------------------- */

:- (\+ descendant(balbo, frodo) 
    -> format('Test passed: descendant(~w, ~w)\n', [balbo, frodo])
    ;  format('Test failed: descendant(~w, ~w) should return false\n', [balbo, frodo])).

:- (\+ descendant(pansy, bilbo) 
    -> format('Test passed: descendant(~w, ~w)\n', [pansy, bilbo])
    ;  format('Test failed: descendant(~w, ~w) should return false\n', [pansy, bilbo])).

:- (\+ descendant(ruby, otho) 
    -> format('Test passed: descendant(~w, ~w)\n', [ruby, otho])
    ;  format('Test failed: descendant(~w, ~w) should return false\n', [ruby, otho])).

% X is not a descendant of uncle
:- (\+ descendant(daisy, drogo) 
    -> format('Test passed: descendant(~w, ~w)\n', [daisy, drogo])
    ;  format('Test failed: descendant(~w, ~w) should return false (X is not a descendant of X\'s cousin\n', [daisy, drogo])).

% X is not a descendant of cousin
:- (\+ descendant(rudigar, camellia) 
    -> format('Test passed: descendant(~w, ~w)\n', [rudigar, camellia])
    ;  format('Test failed: descendant(~w, ~w) should return false (X is not a descendant of X\'s uncle\n', [rudigar, camellia])).

% X is not a descendant of sibling
:- (\+ descendant(ponto, porto) 
    -> format('Test passed: descendant(~w, ~w)\n', [ponto, porto])
    ;  format('Test failed: descendant(~w, ~w) should return false (X is not a descendant of X\'s sibling\n', [ponto, porto])).

/* -------------------- secondCousin - should return true ------------------- */

:- (secondCousin(bilbo, dora) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [bilbo, dora])
    ;  format('Test failed: secondCousin(~w, ~w) should return true\n', [bilbo, dora])).

:- (secondCousin(posco, dora) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [posco, dora])
    ;  format('Test failed: secondCousin(~w, ~w) should return true\n', [posco, dora])).

:- (secondCousin(posco, otho) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [posco, otho])
    ;  format('Test failed: secondCousin(~w, ~w) should return true\n', [posco, otho])).

/* ------------------- secondCousin - should return false ------------------- */

:- (\+ secondCousin(ponto, polo) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [ponto, polo])
    ;  format('Test failed: secondCousin(~w, ~w) should return false\n', [ponto, polo])).

:- (\+ secondCousin(mimosa, otho) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [mimosa, otho])
    ;  format('Test failed: secondCousin(~w, ~w) should return false\n', [mimosa, otho])).

:- (\+ secondCousin(fosco, ruby) 
    -> format('Test passed: secondCousin(~w, ~w)\n', [fosco, ruby])
    ;  format('Test failed: secondCousin(~w, ~w) should return false\n', [fosco, ruby])).


/* ------------------- sameGeneration - should return true ------------------ */

:- (sameGeneration(bilbo, otho) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [bilbo, otho])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [bilbo, otho])).

:- (sameGeneration(dora, falco) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [dora, falco])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [dora, falco])).

:- (sameGeneration(largo, ponto) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [largo, ponto])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [largo, ponto])).

:- (sameGeneration(fosco, linda) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [fosco, linda])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [fosco, linda])).

% X is same generation as self
:- (sameGeneration(fosco, fosco) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [fosco, fosco])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [fosco, fosco])).

% X is same generation as self (highest generation)
:- (sameGeneration(berylla, berylla) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [berylla, berylla])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [berylla, berylla])).

% X is same generation as spouse (highest generation)
:- (sameGeneration(balbo, berylla) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [balbo, berylla])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [balbo, berylla])).

% X is same generation as spouse (highest generation) (reversed)
:- (sameGeneration(berylla, balbo) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [berylla, balbo])
    ;  format('Test failed: sameGeneration(~w, ~w) should return true\n', [berylla, balbo])).

/* ------------------ sameGeneration - should return false ------------------ */

% child of cousin (one lower)
:- (\+ sameGeneration(bilbo, lotho) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [bilbo, lotho])
    ;  format('Test failed: sameGeneration(~w, ~w) should return false\n', [bilbo, lotho])).

% one lower, far removed
:- (\+ sameGeneration(bilbo, frodo) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [bilbo, frodo])
    ;  format('Test failed: sameGeneration(~w, ~w) should return false\n', [bilbo, frodo])).

% aunt (one higher)
:- (\+ sameGeneration(bilbo, chica) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [bilbo, chica])
    ;  format('Test failed: sameGeneration(~w, ~w) should return false\n', [bilbo, chica])).

% sister of grandparent (two higher)
:- (\+ sameGeneration(bilbo, pansy) 
    -> format('Test passed: sameGeneration(~w, ~w)\n', [bilbo, pansy])
    ;  format('Test failed: sameGeneration(~w, ~w) should return false\n', [bilbo, pansy])).
