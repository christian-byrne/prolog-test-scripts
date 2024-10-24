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
  
