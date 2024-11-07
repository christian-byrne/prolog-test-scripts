/* -------------------------------- DATABASE -------------------------------- */

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

/**
 * The database represents two graphs related to social media with 
 * these two predicates:
 *  friend(X, Y): X is friends with Y
 *  follows(X, Y): X follows Y
 * 
 * Note that friend is a reciprocal relationship, while follows is 
 * not. However, neither one is explicitly reciprocal in the facts, so 
 * you will need to make a new predicate that uses friend to make a 
 * reciprocal friends rule.
 */

%friend facts
friend(alan, bichuan).
friend(alan, maria).  
friend(bichuan, elena).
friend(maria, elena).
friend(maria, zahra).
friend(deshawn, anna).
friend(deshawn, ali).
friend(coco, elena).
friend(coco, lucas).
friend(elena, lucas).
friend(lucas, oliver).
friend(ali, anna).
friend(ali, zahra).

% follow facts: follow(X,Y) means “X follows Y”
follows(elena, alan).
follows(elena, coco).
follows(oliver, alan).
follows(maria, oliver).
follows(bichuan, coco).
follows(bichuan, lucas).
follows(bichuan, deshawn).
follows(deshawn, ali).
follows(anna, maria).
follows(ali, anna).
follows(zahra, anna).

/**
 * ancestralLine(L): L is a list of people making up a direct line through parentage
 * EXAMPLES:
 * ?- ancestralLine([frodo|T]).
 * T = [] ;
 * T = [drogo] ;
 * T = [drogo, fosco] ;
 * T = [drogo, fosco, largo] ;
 * T = [drogo, fosco, largo, balbo] ;
 * T = [drogo, fosco, largo, berylla] ;
 * T = [drogo, fosco, tanta] ;
 * T = [drogo, ruby] ;
 * T = [primula] ;
 * false.
 * ?- ancestralLine([bilbo|T]).
 * T = [] ;
 * T = [bungo] ;
 * T = [bungo, mungo] ;
 * T = [bungo, mungo, balbo] ;
 * T = [bungo, mungo, berylla] ;
 * T = [bungo, laura] ;
 * T = [belladonna] ;
 * false.
 */
ancestralLine([_]).
ancestralLine([Child | L]) :-
  parent(Parent, Child),
  ancestralLine([Parent | NewL]),
  L = [Parent | NewL].

/**
 * friendGroup(N,G): G is a group of N people who are all friends with each other. 
 * 
 * You can use the friend facts from SA #5 for testing
 * 
 * EXAMPLES:
 * ?- friendGroup(3,X).
 * X = [deshawn, anna, ali] ;
 * X = [deshawn, ali, anna] ;
 * X = [coco, elena, lucas] ;
 * X = [coco, lucas, elena] ...
 */
friendGroup(N, G) :-
  length(G, N),
  allFriends(G).

friends(X, Y) :-
  friend(X, Y);
  friend(Y, X).

isFriendsWithAll(_, []).
isFriendsWithAll(X, [P | L]) :-
  friends(X, P),
  isFriendsWithAll(X, L).

allFriends([_]).
allFriends([P | G]) :-
  isFriendsWithAll(P, G),
  allFriends(G).

/**
 *  Question 3.
 * Implement a predicate everyOtherOne(X,Y) where X and Y are lists Y contains every
 * other element in X.
 * Example Queries:
 * ?- everyOtherOne([1,2,3,4],X).
 * X = [1, 3].
 * ?- everyOtherOne([1,2,3,4,5],X).
 * X = [1, 3, 5]
 */
hasEveryOtherOne([_], _).
hasEveryOtherOne([], _).

everyOtherOne(L1, L2) :-
  isHalfSize(L1, L2),
  hasEveryOtherOne(L1, L2).

hasEveryOtherOne([_, E2 | L1], L2) :-
  member(E2, L2),
  everyOtherOne(L1, L2).
  % length(L1, Len1),
  % length(L2, Len2),
  % Len1 > Len2,

isHalfSize(L1, L2) :-
  length(L1, Len1),
  length(L2, Len2),
  Len1 is Len2 * 2.





