
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

/* -------------------------------- DATABASE -------------------------------- */

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

/** ------------------------------- PREDICATES ------------------------------- */

/**
 * friends(X, Y)
 * 
 * DESC: X and Y are friends-makes the friend relationship reciprocal.
 * EXAMPLES:
* ?- friends(bichuan, X).
* X = elena ;
* X = alan.
*
* ?- friends(X, lucas).
* X = coco ;
* X = elena ;
* X = oliver.
 */
friends(X, Y) :- friend(X, Y); friend(Y, X).


/**
 * commonFriend(X, Y, Z)
 * 
 * DESC: Z is a friend of both X and Y.
 * EXAMPLES:
 * ?- commonFriend(alan, elena, X).
 * X = bichuan ;
 * X = maria ;
 * false.
 *
 * ?- commonFriend(coco, X, elena).
 * X = bichuan ;
 * X = maria ;
 * X = lucas ;
 * false.
 *
 * ?- commonFriend(X, anna, ali).
 * X = deshawn ;
 * X = zahra ;
 * false.
 *
 * ?- commonFriend(X, Y, zahra).
 * X = maria, Y = ali ;
 * X = ali, Y = maria ;
 * false.
 */
commonFriend(X, Y, Z) :-
  friends(X, Z),
  friends(Y, Z),
  X \= Y,
  Z \= X,
  Z \= Y.

/**
 * suggestFriend(X, Y)
 * 
 * DESC: Suggest X and Y be friends if they have a friend in common 
 *       and are not already friends, or if they follow the same 
 *       person and are not already friends.
 * EXAMPLES:
 * ?- suggestFriend(alan, X).
 * X = elena ;
 * X = elena ;
 * X = zahra ;
 * false.
 *
 * ?- suggestFriend(X, deshawn).
 * X = zahra ;
 * false.
 *
 * ?- suggestFriend(X, Y).
 * X = alan, Y = elena ;
 * X = alan, Y = zahra ;
 * X = bichuan, Y = maria ;
 * ...
 */
suggestFriend(X, Y) :-
  commonFriend(X, Y, _),
  not(friends(X, Y)),
  X \= Y;
  follows(X, CommonFollowed),
  follows(Y, CommonFollowed),
  not(friends(X, Y)),
  X \= Y.

/**
 * Suggest that X follow Y if X follows someone who follows Y 
 *  and X does not already follow Y, or if X follows someone who 
 *  is friends with Y and X does not already follow Y, or if X 
 *  is friends with someone who follows Y and X does not already 
 *  follow Y.
 *
 * EXAMPLES:
 * ?- suggestFollow(alan, X).
 * X = coco ;
 * X = lucas ;
 * X = deshawn ;
 * X = oliver ;
 * false.
 */
suggestFollow(X, Y) :-
  followsTransitive(X, Y),
  not(follows(X, Y));
  followsFriend(X, Y),
  not(follows(X, Y));
  friendsWithFollower(X, Y),
  not(follows(X, Y)).

distinct(X, Y, Z) :- X \= Y, Y \= Z, X \= Z.

followsTransitive(X, Y) :-
  follows(X, Z),
  follows(Z, Y),
  distinct(X, Y, Z).

followsFriend(X, Y) :-
  follows(X, Z),
  friends(Z, Y),
  distinct(X, Y, Z).

friendsWithFollower(X, Y) :-
  friends(X, Z),
  follows(Z, Y),
  distinct(X, Y, Z).